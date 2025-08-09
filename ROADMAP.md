### Yuri Migration Roadmap

This roadmap describes how we will migrate the legacy C gameserver to a modern Rust-based, service-oriented architecture with minimal risk and small, reviewable steps.

---

## Objectives
- Reduce and then eliminate C from the runtime, module by module.
- Isolate concerns: protocol, transport, domain (world/char/map), persistence, config, telemetry.
- Centralize character state and writes in the world-server (formerly charserver).
- Make login stateless and scriptable (Lua), fronted by a proxy.
- Terminate client connections at a map-proxy that parses packets and applies framing/crypto.
- Run each map in its own independent tick loop (tokio task).
- Use NATS for pub/sub and request/reply between services.
- Move SQL out of hot game loops; keep world-server as source of truth and persistence.

---

## Target Architecture (v1)
- `world-server` (renamed from charserver): owns character/inventory/boards/clan state; performs all durable writes; exposes NATS RPC.
- `login-proxy`: stateless, executes Lua scripts; routes stateful ops to world-server over NATS.
- `map-proxy`: all client TCP connections terminate here; handles protocol framing + crypto; forwards to map server(s) or Rust map-runtime.
- `map-runtime` (Rust): per-map tokio tasks and game loop; owns in-memory map state and transient character attributes (position, hp/mp, etc.); publishes lazy syncs to world-server; sends important mutations to world-server via RPC.
- `NATS`: transport fabric for gossip and RPC; optional persistence/WAL later.
- `DB` (initially Postgres/SQLite): only world-server writes/reads durable character data.

---

## Milestones

- M0: C-first hygiene (no behavioral changes)
  - Split `c_src` into server-scoped subdirs and common sources.
  - Stop cross-shadowing by namespacing server-local functions and making file-local helpers `static`.
  - Keep headers in place initially to avoid include churn.
  - Build continues to use CMake; keep changes mechanical and small.

- M1: Rust workspace scaffolding (no prod traffic)
  - Create Rust workspace with crates: `protocol`, `crypto`, `transport`, `telemetry`, `config`, `persistence`, and bins: `map-proxy`, `login-proxy`, `world-server`.
  - Maintain current C servers; add Rust sidecars only.

- M2: Crypto to Rust
  - Implement stream/static XOR in `crates/crypto` with test vectors.
  - Replace `net_crypt.c` via a small C→Rust FFI; delete `c_src/net_crypt.c`.

- M3: NATS + world-server (initial)
  - Stand up `world-server` with `persistence` (SQLx). Add a couple of RPC endpoints (e.g., `world.inv.add`, `world.char.get`).
  - Replace direct SQL in C hot paths by calling a tiny FFI that publishes NATS RPC (request/reply with timeouts).

- M4: Proxies & login
  - `map-proxy` Phase 1: transparent framed TCP forwarder; Phase 2: terminate client framing/crypto; Phase 3: parse selected opcodes.
  - `login-proxy`: handle 0x00, 0x02, 0x60, 0x66, 0x7B via Lua + RPC to world-server; decommission C login.

- M5: Map runtime & scene
  - Per-map tokio tasks; move movement/spawn/combat gradually from C to Rust; route specific opcodes via proxy.
  - Load scenes from Tiled; implement warps/NPCs in Lua.
  - Decommission C `map_server` incrementally.

- M6: Decommission legacy C
  - After features are fully covered, remove CMake and remaining C sources.

---

## Incremental PR sequence (small changes)

1) C hygiene split (mechanical)
- Create `c_src/login`, `c_src/char`, `c_src/map`.
- Move only .c files into subdirs; keep headers in `c_src` to avoid include path changes.
- Update `CMakeLists.txt` source lists to new paths.

2) Rust workspace skeleton
- Add new crates/bins with minimal code; compile-only.

3) Crypto swap
- Implement Rust crypto + C FFI calls; delete `net_crypt.c`.

4) NATS + world-server
- Add request/reply for a single mutation (e.g., item pickup) and read (e.g., character load).
- Replace the corresponding C code path to call the FFI.

5) Map-proxy in front of clients
- Start as transparent; then terminate crypto; then parse a subset of opcodes.

6) Login-proxy + Lua
- Move login business logic to Lua scripts; make the proxy stateless.

7) Map runtime features
- Migrate maps incrementally; keep C map server for the rest.

8) Remove unused C and CMake
- Delete modules as they are replaced; simplify build.

---

## Conventions & guardrails
- Small PRs only; single-area diffs (e.g., "move login .c files" or "add crypto crate").
- No behavior changes in hygiene PRs; CI must compile both C and Rust parts (when present).
- Add unit tests for new Rust crates; property tests for protocol/crypto.
- Use `tracing` + JSON logs for Rust services; keep existing C logging.

---

## Immediate next steps (M0)
- [ ] Move login server .c files into `c_src/login` (keep headers in `c_src`).
- [ ] Update `CMakeLists.txt` for login sources.
- [ ] Verify build (or at least CMake generation) still succeeds.
- [ ] Repeat for char and map in follow-up PRs.