# FPGA Go Board

This project implements a simplified **Go Board** using an FPGA, Verilog, and MIPS assembly.  
Players interact with the system by placing magnetic pieces on a physical board, which is equipped with **16 Hall Effect sensors** and **16 LEDs**. The FPGA detects moves, validates them, makes decisions for the opposing player, and determines game end conditions.

---

## Features

- **Sensor-based input**  
  - Detects moves when a player places a magnetized piece on one of the 16 board positions.  
  - Reads state from Hall Effect sensors in real time.

- **Move generation and validation**  
  - Uses an **LFSR** (linear-feedback shift register) to pseudo-randomly generate moves for the FPGA-controlled player.  
  - Checks for illegal moves and retries until a valid move is found.  
  - Allows the FPGA to **pass** if no legal moves are available.

- **LED-based output**  
  - FPGA communicates chosen moves by lighting up the corresponding LED.  
  - LEDs are also used for signaling game states.

- **Game control logic**  
  - Tracks player turns.  
  - Detects when the game ends.  
  - Determines and signals the winner.

- **Hardware/software co-design**  
  - **Verilog** wrapper for a 32-bit MIPS CPU that handles sensor/LED I/O.  
  - **MIPS assembly** that implements the move logic, validation, and game control.

---

## Repository Structure

├── [CPU Files]/ # Verilog source files for MIPS CPU and sub-modules  
│ ├── [processor.v]  
│ └── ...  
├── [Go.s]/ # MIPS assembly source file  
├── [LFSR]/ # LFSR source file and wrapper file  
│ ├── [lfsr.v]  
│ └── [lfsr_wrapper.v]  
├── [GO_CPU_Wrapper.v]/ # CPU Wrapper, FPGA I/O, FPGA board pin mappings and constraints  
└── README.md  

---

## How It Works

1. **Player Move**  
   - Player places a magnetic stone on the board.  
   - The FPGA polls all Hall Effect sensors to detect the new placement.  

2. **FPGA Turn**  
   - Assembly logic initiates move selection.  
   - LFSR generates candidate moves.  
   - Illegal moves are rejected until a valid move is found or the FPGA passes.  

3. **Feedback**  
   - Selected move is displayed via the corresponding LED.  
   - If the FPGA passes, a designated signal LED lights up.  

4. **End of Game**  
   - Assembly code checks for endgame conditions.  
   - FPGA determines and signals the winner.  

---

## Getting Started

### Requirements
- FPGA development board  
- 16 Hall Effect sensors  
- 16 LEDs  
- Radial magnets  
- Xilinx Vivado  

---

## Demo

- **Video/GIF demo link here**  
- **Images of hardware setup here**

---

## Future Improvements

- Expand beyond 16 positions to a larger Go board.  
- Smarter algorithm for FPGA moves.  
- Implement Ko rule and advanced scoring.  

---

## Author

- Shelby Hartman   
- LinkedIn: [https://www.linkedin.com/in/shelby-g-hartman/]
- Github: [https://github.com/shelbyhrtmn24]
