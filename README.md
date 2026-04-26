# 4-bit-ALU

# 4-Bit ALU IP Core in Verilog

## 📌 Overview

This repository contains the RTL design of a 4-bit Arithmetic Logic Unit (ALU) built from scratch in Verilog HDL. The design covers 4 arithmetic operations and 3 logical operations, with the adder and subtractor implemented using a ripple-carry chain of individual full adder modules — no built-in arithmetic operators used.

This project was developed as part of a chip design bootcamp, building on prior FPGA work (a moving average filter implemented for a Signals & Systems course). The goal was to move beyond HDL syntax and actually understand how arithmetic and logic are physically structured in hardware.

---

## ✨ Key Features

- **8 Operations** covered across arithmetic, logic, and shift categories via a 3-bit opcode.
- **Modular Design:** Adder and subtractor are built from a shared `full_adder` primitive, demonstrating hierarchical RTL design.
- **Ripple-Carry Architecture:** Carry and borrow propagate bit-by-bit through four chained full adder instances.
- **Unary Operation Select:** A `sel` input chooses between operand A and B for NOT and shift operations.
- **Status Flags:** `alu_carry` output captures carry and borrow results from arithmetic operations.
- **Fully Combinational:** The entire design lives in `always @(*)` and `assign` blocks — no clock, no registers.

---

## 🏗️ Architecture & Modules

### 1. Full Adder (`full_adder.v`)
Single-bit full adder. The primitive building block for both the adder and subtractor.
```
sum  = a ^ b ^ cin
cout = (a & b) | (cin & (a ^ b))
```

### 2. Ripple-Carry Adder (`adder_4bit.v`)
Four `full_adder` instances chained in series. The carry-out of each stage feeds into the carry-in of the next, propagating from bit 0 to bit 3.

### 3. Subtractor (`subtractor_4bit.v`)
Same ripple-chain structure as the adder, with borrow propagation instead of carry.

### 4. ALU Top-Level (`alu_4bit.v`)
Instantiates the adder and subtractor, computes all logic and shift results in parallel via `assign` statements, then selects the final output using a `case` block on `opcode`.

```
alu_4bit
├── adder_4bit
│   └── full_adder (x4)
├── subtractor_4bit
│   └── full_adder (x4)
└── assign statements — AND, OR, XOR, NOT, SLL, SRL
```

---

## 🔢 Operation Table

| Opcode | Operation | Type |
|--------|-----------|------|
| `000` | ADD | Arithmetic |
| `001` | SUB | Arithmetic |
| `010` | AND | Logic |
| `011` | OR | Logic |
| `100` | NOT A / NOT B (`sel`) | Logic |
| `101` | XOR | Logic |
| `110` | Shift Left Logical (`sel`) | Shift |
| `111` | Shift Right Logical (`sel`) | Shift |

> For opcodes `100`, `110`, `111` — `sel=1` operates on A, `sel=0` operates on B.

---

## 🔌 Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `A` | input | 4-bit | First operand |
| `B` | input | 4-bit | Second operand |
| `opcode` | input | 3-bit | Selects the operation |
| `sel` | input | 1-bit | Selects A or B for unary operations |
| `alu_out` | output | 4-bit | Result |
| `alu_carry` | output | 1-bit | Carry or borrow flag |

---

## 🧠 Key Learnings

- **Ripple-carry tradeoff:** Carry has to pass through every full adder stage sequentially — this is why wider adders (16-bit, 32-bit) use carry-lookahead instead.
- **Subtraction via 2's complement:** `A - B` is fundamentally `A + (~B) + 1`. Understanding this makes the carry/borrow flag behaviour make sense.
- **Logical vs. arithmetic shift:** `>>` fills with 0; `>>>` fills with the sign bit. Critical difference for signed numbers.
- **Named port mapping:** `.port(signal)` syntax is safer than positional — argument order changes won't silently break the design.
- **Hardware bugs are silent:** Unlike software crashes, wrong wiring just produces wrong values. You have to trace every signal deliberately.

---

## 📁 File Structure

```
├── full_adder.v
├── adder_4bit.v
├── subtractor_4bit.v
├── alu_4bit.v
└── README.md
```
