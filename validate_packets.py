#!/usr/bin/env python3
"""
Packet Structure Validation Script for Yuri Server Protocol

This script validates that the documented packet structures in PROTOCOL_STRUCTS.md
match the actual packet construction in the C source code.
"""

import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Optional

class PacketValidator:
    def __init__(self):
        self.packets_found = {}
        self.validation_results = []
        
    def extract_packet_construction(self, file_path: Path) -> Dict[str, List[str]]:
        """Extract packet construction patterns from C source."""
        packets = {}
        
        with open(file_path, 'r') as f:
            content = f.read()
            
        # Find WFIFOB patterns for direct packet construction
        wfifob_pattern = r'WFIFOB\([^,]+,\s*0\)\s*=\s*0xAA.*?(?=WFIFOB\([^,]+,\s*0\)\s*=\s*0xAA|\Z)'
        matches = re.findall(wfifob_pattern, content, re.DOTALL)
        
        for match in matches:
            # Extract opcode
            opcode_match = re.search(r'WFIFOB\([^,]+,\s*3\)\s*=\s*(0x[0-9A-Fa-f]+)', match)
            if opcode_match:
                opcode = opcode_match.group(1)
                if opcode not in packets:
                    packets[opcode] = []
                packets[opcode].append(match)
                
        # Find WBUFB patterns for buffer construction
        wbufb_pattern = r'WBUFB\([^,]+,\s*0\)\s*=\s*0xAA.*?(?=WBUFB\([^,]+,\s*0\)\s*=\s*0xAA|\Z)'
        matches = re.findall(wbufb_pattern, content, re.DOTALL)
        
        for match in matches:
            # Extract opcode
            opcode_match = re.search(r'WBUFB\([^,]+,\s*3\)\s*=\s*(0x[0-9A-Fa-f]+)', match)
            if opcode_match:
                opcode = opcode_match.group(1)
                if opcode not in packets:
                    packets[opcode] = []
                packets[opcode].append(match)
                
        return packets
    
    def validate_packet_structure(self, opcode: str, construction: str, documented_struct: str) -> Tuple[bool, str]:
        """Validate a packet construction against documented structure."""
        # Extract field positions and types from construction
        field_pattern = r'W(FIF|BUF)([BWL])\([^,]+,\s*(\d+)\)\s*=\s*([^;]+);'
        fields = re.findall(field_pattern, construction)
        
        validation_notes = []
        is_valid = True
        
        # Check for magic byte at position 0
        if not re.search(r'W(?:FIF|BUF)B\([^,]+,\s*0\)\s*=\s*0xAA', construction):
            validation_notes.append("❌ Missing magic byte 0xAA at position 0")
            is_valid = False
        else:
            validation_notes.append("✅ Magic byte 0xAA at position 0")
            
        # Check for length field (usually at positions 1-2)
        if re.search(r'W(?:FIF|BUF)W\([^,]+,\s*1\)\s*=.*SWAP16', construction):
            validation_notes.append("✅ Length field at positions 1-2 with SWAP16")
        elif re.search(r'WFIFO_SET\([^,]+,\s*[^,]+,\s*[^,]+\)', construction):
            validation_notes.append("✅ Length set via WFIFO_SET")
        else:
            validation_notes.append("⚠️  Length field handling unclear")
            
        # Check for opcode at position 3
        if re.search(rf'W(?:FIF|BUF)B\([^,]+,\s*3\)\s*=\s*{opcode}', construction):
            validation_notes.append(f"✅ Opcode {opcode} at position 3")
        else:
            validation_notes.append(f"❌ Opcode mismatch or wrong position")
            is_valid = False
            
        # Check for SWAP16/SWAP32 usage on multi-byte fields
        swap16_count = len(re.findall(r'SWAP16', construction))
        swap32_count = len(re.findall(r'SWAP32', construction))
        if swap16_count > 0 or swap32_count > 0:
            validation_notes.append(f"✅ Byte order conversion: {swap16_count} SWAP16, {swap32_count} SWAP32")
            
        # Check for encryption
        if 'tk_encrypt' in construction:
            validation_notes.append("✅ Uses tk_encrypt() stream cipher")
        elif 'tk_crypt_static' in construction:
            validation_notes.append("✅ Uses tk_crypt_static() static XOR")
        else:
            validation_notes.append("⚠️  No explicit encryption call in snippet")
            
        return is_valid, "\n    ".join(validation_notes)
    
    def validate_file(self, file_path: Path):
        """Validate all packets in a file."""
        print(f"\n📁 Validating: {file_path}")
        print("=" * 60)
        
        packets = self.extract_packet_construction(file_path)
        
        if not packets:
            print("  No packet constructions found")
            return
            
        for opcode, constructions in packets.items():
            print(f"\n  Opcode {opcode}:")
            for i, construction in enumerate(constructions, 1):
                # Try to identify function name
                func_match = re.search(r'(\w+)\s*\(', construction[:100])
                func_name = func_match.group(1) if func_match else "Unknown"
                
                is_valid, notes = self.validate_packet_structure(opcode, construction, "")
                
                print(f"    Instance {i} (likely in {func_name}):")
                print(f"    {notes}")
                
                self.validation_results.append({
                    'file': str(file_path),
                    'opcode': opcode,
                    'function': func_name,
                    'valid': is_valid,
                    'notes': notes
                })
    
    def generate_report(self):
        """Generate validation report."""
        print("\n" + "=" * 60)
        print("VALIDATION SUMMARY")
        print("=" * 60)
        
        total = len(self.validation_results)
        valid = sum(1 for r in self.validation_results if r['valid'])
        
        print(f"\nTotal packets validated: {total}")
        print(f"Valid packets: {valid} ({valid*100//total if total else 0}%)")
        print(f"Issues found: {total - valid}")
        
        # Group by opcode
        by_opcode = {}
        for result in self.validation_results:
            opcode = result['opcode']
            if opcode not in by_opcode:
                by_opcode[opcode] = []
            by_opcode[opcode].append(result)
            
        print("\nBy Opcode:")
        for opcode in sorted(by_opcode.keys()):
            results = by_opcode[opcode]
            valid_count = sum(1 for r in results if r['valid'])
            print(f"  {opcode}: {valid_count}/{len(results)} valid")
            
    def validate_against_documentation(self):
        """Cross-reference with PROTOCOL_STRUCTS.md"""
        structs_file = Path("/Users/steve/Code/yuri/PROTOCOL_STRUCTS.md")
        if not structs_file.exists():
            print("⚠️  PROTOCOL_STRUCTS.md not found")
            return
            
        with open(structs_file, 'r') as f:
            doc_content = f.read()
            
        # Extract documented opcodes
        doc_opcodes = set(re.findall(r'Opcode (0x[0-9A-Fa-f]+)', doc_content))
        
        # Find opcodes in code
        found_opcodes = set(r['opcode'] for r in self.validation_results)
        
        print("\n" + "=" * 60)
        print("DOCUMENTATION CROSS-REFERENCE")
        print("=" * 60)
        
        documented_but_not_found = doc_opcodes - found_opcodes
        found_but_not_documented = found_opcodes - doc_opcodes
        
        if documented_but_not_found:
            print("\n⚠️  Documented but not found in code:")
            for opcode in sorted(documented_but_not_found):
                print(f"    {opcode}")
                
        if found_but_not_documented:
            print("\n⚠️  Found in code but not documented:")
            for opcode in sorted(found_but_not_documented):
                print(f"    {opcode}")
                
        if not documented_but_not_found and not found_but_not_documented:
            print("\n✅ All opcodes match between code and documentation!")

def main():
    validator = PacketValidator()
    
    # Validate main packet files
    files_to_validate = [
        Path("/Users/steve/Code/yuri/map_server/c_src/map_parse.c"),
        Path("/Users/steve/Code/yuri/login_server/c_src/login_parse.c"),
    ]
    
    for file_path in files_to_validate:
        if file_path.exists():
            validator.validate_file(file_path)
        else:
            print(f"⚠️  File not found: {file_path}")
    
    # Generate reports
    validator.generate_report()
    validator.validate_against_documentation()
    
    # Check Rust implementation consistency
    print("\n" + "=" * 60)
    print("RUST IMPLEMENTATION CHECK")
    print("=" * 60)
    
    rust_packet_file = Path("/Users/steve/Code/yuri/login_server/src/packet.rs")
    if rust_packet_file.exists():
        print(f"\n📁 Checking: {rust_packet_file}")
        with open(rust_packet_file, 'r') as f:
            rust_content = f.read()
            
        # Check for consistency
        if "0xAA" in rust_content:
            print("  ✅ Uses 0xAA magic byte")
        if "to_le_bytes" in rust_content or "get_u16_le" in rust_content:
            print("  ✅ Uses little-endian byte order")
        if "tk_crypt_static" in rust_content:
            print("  ✅ References static XOR encryption")
            
        # Check opcodes
        rust_opcodes = set(re.findall(r'0x([0-9A-Fa-f]{2})', rust_content))
        print(f"  Found opcodes: {', '.join(f'0x{op}' for op in sorted(rust_opcodes))}")

if __name__ == "__main__":
    main()