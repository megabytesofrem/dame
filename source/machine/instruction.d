module machine.instruction;

import std.stdio : writeln, writefln;
import machine.cpu;
import machine.memory : readByte;

/// Alias to prevent typing Instruction 400 times
alias I = Instruction;

struct Instruction {
    /// Short description of the instruction
    string desc;

    /// Length of the instruction (in bytes)
    int length;

    /// Number of CPU cycles the instruction takes up
    int cycles;

    /// Handler
    void function(CPU cpu) handler;
}

/// Routines

void notImplemented(CPU cpu) {
    import debugger : dumpRegisters;

    writefln("[E] Instruction not implemented yet: %04X", readByte(cpu.mmap, cpu.regs.pc));

    // Dump the contents of the registers to the screen
    dumpRegisters(cpu.regs);
}

void nop(CPU cpu) {
    writeln("NOP");
}

void ld_bc_nn(CPU cpu) {
}

void ld_bc_a(CPU cpu) {
}

void inc_bc(CPU cpu) {
    cpu.regs.bc.bc++;
}

void inc_b(CPU cpu) {
    cpu.regs.bc.b++;
}

void dec_b(CPU cpu) {
    cpu.regs.bc.b--;
}

void ld_b_d8(CPU cpu) {

}

void rlca(CPU cpu) {

}

void ld_a16_sp(CPU cpu) {

}

void add_hl_bc(CPU cpu) {
    // flags: - 0 H C
}
