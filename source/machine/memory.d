module machine.memory;

struct MemoryMap {
    ubyte[0x8000] cart;
    ubyte[0x2000] sram;
    ubyte[0x100] io;
    ubyte[0x2000] vram;
    ubyte[0x2000] wram;
}

/// Read a ubyte at address and map it in the memory map
/// Params:
///   map = 
///   addr = 
/// Returns: The ubyte read
ubyte readByte(MemoryMap map, ushort addr) {
    if (addr <= 0x7fff) {
        return map.cart[addr];
    } else if (addr >= 0xa000 && addr <= 0xbfff) {
        return map.sram[addr - 0xa000];
    } else if (addr >= 0x8000 && addr <= 0x9fff) {
        return map.vram[addr - 0x8000];
    } else if (addr >= 0xc000 && addr <= 0xdfff) {
        return map.wram[addr - 0xc000];
    } else if (addr >= 0xe000 && addr <= 0xfdff) {
        return map.wram[addr - 0xe000];
    } else {
        return 0x0;
    }
}

ubyte[] loadROM(string path) {
    import std.stdio : writefln, writeln;
    import std.file : read;

    ubyte[] rom = cast(ubyte[]) read(path, 0x8000);

    scope (failure) {
        writeln("[E] Failed to read ROM file");
    }

    writefln("Read %d ubytes successfully", rom.length);
    return rom;
}
