# MIPS-processor-Implementation

### Overview

Utilizing the **Vivado Design Suite**, I design a single-cycle and multi-cycle MIPS processor using **Verilog**. After design, I simulate the processor to verify its accuracy and correct operation.

### Single-cycle

Design a single cycle CPU that supports 16 MIPS(`add`, `sub`, `and`, `or`, `addi`, `andi`, `ori`,` slt`,`lw`, `sw`, `beq`, `j`,` jal`, `jr`) instructions

<img src=".\figure\1.jpg" style="zoom:67%;" />

Implements CPU modules, such as ALU, Register, Memory, Mux, etc. And connect each module through `Top.v`

### Multi-cycle

Based on the single-cycle processor, designed a five stage pipelined multi-cycle MIPS processor.

<img src=".\figure\2.jpg" style="zoom:67%;" />

* Understand the **pipeline** of the CPU
* Design pipelined CPUs to address **data, control, and structure risks**.
* Add **forwarding** mechanism, improving Pipeline Processor Performance

**Notice:** For more information, please refer to README.md in each file folder