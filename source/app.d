import std.stdio;

import machine.cpu;
import machine.memory;

void main() {
	auto cpu = new CPU;

	cpu.mmap.cart = loadROM("Tetris.gb");
	cpu.run();
}
