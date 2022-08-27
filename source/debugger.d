module debugger;

import std.stdio;
import machine.memory : MemoryMap;
import machine.cpu : Registers;

void writeAddress(MemoryMap mmap, ushort addr) {
    import machine.memory;

    string location = "????";
    if (addr >= 0 && addr <= 0x7fff) {
        location = "CART";
    } else if (addr >= 0xa000 && addr <= 0xbfff) {
        location = "SAVE";
    } else if (addr >= 0x8000 && addr <= 0x9fff) {
        location = "VRAM";
    } else if (addr >= 0xc000 && addr <= 0xdfff) {
        location = "WORK";
    } else if (addr >= 0xe000 && addr <= 0xfdff) {
        location = "WORK";
    }

    writefln("[I] Read from address 0x%04X (%s): %04X", addr, location, readByte(mmap, addr));
}

/// Dump the contents of the registers to the screen
/// Params:
///   r = 
void dumpRegisters(Registers r) {
    writefln("PC:%08X\tSP:%08X\tFLAG:%04x", r.pc, r.sp, r.flag);
    writefln("A:%08X\tB:%08X\tC:%08X\tD:%08X\tE:%08X\tF:%08X",
        r.af.a, r.bc.a, r.bc.b, r.de.a, r.de.b, r.af.b);
    writefln("AF:%08X\tBC:%08X\tDE:%08X\tHL:%08X\tH:%08X\tL:%08X",
        r.af.af, r.bc.bc, r.de.de, r.hl.hl, r.hl.a, r.hl.b);
}

/// Dump the entire contents of the memory map to a file
/// Params:
///   mmap = 
void dumpMemoryMap(MemoryMap mmap) {
    import std.file : write;

    byte[0x7fffff] dump;

    for (int i = 0; i < 0x7fff; i++) {
        dump[i] = mmap.cart[i];
    }

    for (int i = 0xa000; i < 0xbfff; i++) {
        dump[i] = mmap.sram[i - 0xa000];
    }

    for (int i = 0x8000; i < 0x9fff; i++) {
        dump[i] = mmap.vram[i - 0x8000];
    }

    for (int i = 0xc000; i < 0xdfff; i++) {
        dump[i] = mmap.wram[i - 0xc000];
    }

    for (int i = 0xe000; i < 0xfdff; i++) {
        dump[i] = mmap.wram[i - 0xe000];
    }

    write("memory.hex", dump);
    scope (failure) {
        writeln("[E] Failed to dump the current memory map");
    }
}
