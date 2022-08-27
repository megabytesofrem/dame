module machine.cpu;

import std.stdio : writefln;
import std.functional : toDelegate;

import machine.instruction;
import machine.memory;
import debugger;

// https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html
static Instruction[256] opcodes = [
    I("NOP", 1, 4, &nop), // 00
    I("LD BC,nn", 3, 12, &ld_bc_nn), // 01
    I("LD (BC),A", 1, 8, &ld_bc_a), // 02
    I("INC BC", 1, 8, &inc_bc), // 03
    I("INC B", 1, 4, &inc_b), // 04
    I("DEC B", 1, 4, &dec_b), // 05
    I("LD B,d8", 2, 8, &dec_b), // 06
    I("RLCA", 1, 4, &rlca), // 07
    I("LD (a16), SP", 3, 20, &ld_a16_sp), // 08
    I("ADD HL,BC", 1, 8, &add_hl_bc),
];

/// A register pair represented as either two 8 bit registers,
/// or together as one 16 bit.
union Register {
    private struct _U8 {
        ubyte low;
        ubyte high;
    }

    _U8 u8;
    ushort u16;
}

struct Registers {
    ubyte flag;
    ushort pc, sp;

    // Register pairs of either two 8 bit, or accessed as one 16 bit
    Register af;
    Register bc;
    Register de;
    Register hl;
}

ubyte highByte(ushort val) {
    return cast(ubyte)(val >> 8);
}

ubyte lowByte(ushort val) {
    return cast(ubyte)(val & 0x00FF);
}

/// Emulate the Gameboy's Z80 CPU
class CPU {
    Registers regs;
    MemoryMap mmap;

    this() {
        // Pad out the unimplemented opcodes
        for (int i = 0x03; i <= 0xff; i++) {
            opcodes[i] = I("NOT_IMPL", 1, 4, &notImplemented);
        }
    }

    /// Decode a single operation and advance PC by the number of cycles
    /// that the instruction takes to perform
    /// Params:
    ///   op = 
    void decode(ubyte op) {
        opcodes[op].handler(this);
        regs.pc += opcodes[op].cycles;
    }

    /// Run the CPU cycles
    void run() {
        while (true) {
            writeAddress(mmap, regs.pc);
            decode(readByte(mmap, regs.pc));
        }
    }
}
