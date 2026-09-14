// Icarus-GPU package — shared parameters and ISA defines
package icarus_pkg;
  // Core counts — v0.5 free Sky130: 16 cores @100MHz (10ns) — 3000MHz requires 3nm ASIC
  parameter int NUM_CORES = 16;
  parameter int LANES_PER_CORE = 4;
  parameter int NUM_THREADS = NUM_CORES * LANES_PER_CORE; // 64 threads
  parameter int CLK_MHZ = 100; // free Sky130: 100MHz, 10ns period — yosys proven, FPGA compatible
  parameter logic FPGA_COMPATIBLE = 1'b1;

  // Memory
  parameter int L1_SIZE_KB = 16;
  parameter int L2_SIZE_KB = 256;
  parameter int AXI_ADDR_W = 32;
  parameter int AXI_DATA_W = 64;
  parameter int AXIS_DATA_W = 64; // command stream

  // Framebuffer
  parameter int FB_WIDTH = 640;
  parameter int FB_HEIGHT = 480;

  // ISA — RV32IM base + custom vector
  typedef enum logic [6:0] {
    OP_ALU  = 7'b0110011,
    OP_ALUI = 7'b0010011,
    OP_LOAD = 7'b0000011,
    OP_STORE= 7'b0100011,
    OP_BRANCH=7'b1100011,
    OP_VEC  = 7'b1010011  // custom vector
  } opcode_e;

  // Command packet (AXI-Stream payload)
  typedef struct packed {
    logic [7:0]  cmd_type; // 0=NOP, 1=DRAW, 2=DISPATCH
    logic [15:0] width;
    logic [15:0] height;
    logic [31:0] addr;    // vertex buffer / kernel addr
    logic [15:0] count;   // vertex count / workgroups
  } cmd_packet_t;

  // Thermal / power stub
  typedef struct packed {
    logic [15:0] temp_c_x100;
    logic [15:0] power_mw;
  } sensor_t;

endpackage
