use common::cipher::codec::{lookup_table, RollingCursor};
use common::ffi::lookup_table_c;
use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};

fn bench_lookup_table_comparison(c: &mut Criterion) {
    let mut group = c.benchmark_group("lookup_table_comparison");

    group.bench_function("rust_implementation", |b| {
        b.iter(|| lookup_table(black_box("grin")))
    });

    group.bench_function("c_implementation", |b| {
        b.iter(|| lookup_table_c(black_box("grin")))
    });

    group.finish();

    // Verify they produce the same output
    #[cfg(test)]
    {
        let rust_result = lookup_table("grin");
        let c_result = lookup_table_c("grin");
        assert_eq!(rust_result, c_result, "Implementations don't match!");
    }

    #[test]
    fn test_get_key_deterministic() {
        use crate::ffi;
        let table = lookup_table("grin");
        let packet = [
            0xAA, 0x00, 0x08, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03,
        ];
        let cursor = RollingCursor::from_bytes(&packet[8..]).unwrap();

        assert_eq!(cursor.base, 0x27);
        assert_eq!(cursor.offset, 0x2060);

        dbg!(table);

        let key = xor_key_rolling(table, &cursor);
        dbg!(key);

        let c_key = ffi::generate_key2_wrapper(&packet, &table, true);
        dbg!(c_key);

        // assert_eq!(key, [/* expected 9 bytes from original logic */]);
    }
}

fn bench_lookup_table(c: &mut Criterion) {
    c.bench_function("lookup_table", |b| {
        b.iter(|| lookup_table(black_box("grin")))
    });

    // Test with different key sizes
    let keys = vec![
        "a",
        "test",
        "longer_key_here",
        "very_long_key_with_many_characters",
    ];
    for key in keys {
        c.bench_with_input(
            BenchmarkId::new("lookup_table_key_size", key.len()),
            &key,
            |b, k| b.iter(|| lookup_table(black_box(k))),
        );
    }
}

fn bench_rolling_cursor(c: &mut Criterion) {
    let mut group = c.benchmark_group("rolling_cursor");

    group.bench_function("to_bytes", |b| {
        let cursor = RollingCursor::new();
        b.iter(|| cursor.to_bytes())
    });

    group.bench_function("from_bytes", |b| {
        let bytes = [0x01, 0x02, 0x03];
        b.iter(|| RollingCursor::from_bytes(black_box(&bytes)))
    });

    // Benchmark from_trailer with different data sizes
    for size in [10, 100, 1000, 10000] {
        let mut data = vec![0u8; size];
        data[size - 3..].copy_from_slice(&[0x01, 0x02, 0x03]);

        group.bench_with_input(BenchmarkId::new("from_trailer", size), &data, |b, d| {
            b.iter(|| RollingCursor::from_trailer(black_box(d)))
        });
    }

    group.finish();
}

criterion_group!(benches, bench_lookup_table_comparison);
criterion_main!(benches);
