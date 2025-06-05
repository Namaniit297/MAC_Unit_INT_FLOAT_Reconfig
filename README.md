# MAC_Unit_INT_FLOAT_Reconfig
🚀 TS MAC UNITS — A Next-Generation Multiply-Accumulate Architecture Suite
This repository encapsulates a comprehensive collection of cutting-edge Multiply-Accumulate (MAC) units, architected for precision, performance, and configurability in AI/ML inference engines, DSP blocks, and reconfigurable accelerators.

We have engineered three versatile MAC cores, each tailored to a distinct computational paradigm:

⚙️ 1. MAC_INT8: Ultra-Efficient 8-bit Integer MAC
A highly optimized, latency-aware MAC unit supporting signed 8-bit operands. This module features:

Double-buffered weight interface for uninterrupted operand flow.

Zero-skipping logic to eliminate redundant computations.

Three-stage pipelined architecture ensuring maximal throughput.

Optional chained accumulation via last_sum input for fused operations across layers.

This MAC is ideal for low-power inference engines such as TPUs and edge AI accelerators, where integer quantization is dominant.

🌐 2. MAC_FLOAT32_16: Dynamic Precision Floating Point MAC
A dual-mode MAC unit that enables:

Full-precision IEEE-754 compliant float32 operations.

Runtime quantization to float16, drastically reducing resource utilization.

Overflow/underflow detection with adaptive rescaling, preserving numerical stability.

Perfect for architectures balancing accuracy and efficiency—including neural nets with mixed-precision quantized training/inference.

🧩 3. MAC_BITFUSION: Reconfigurable Bit-Level Fusion MAC
Inspired by BitFusion-style datapaths, this design features:

Bit-tiled reconfigurability to support 2-bit, 4-bit, and 8-bit MACs in parallel.

Hardware-level fused micro-operations across sub-word partitions.

Dynamic mode switching, ideal for workloads like MobileNet, SqueezeNet, and TinyML.

This MAC adapts to data precision at runtime, unlocking substantial energy and area efficiency.

