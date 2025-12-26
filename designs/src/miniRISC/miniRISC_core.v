`timescale 1ns / 1ps

///////////fields of IR
`define oper_type IR[31:27]
`define rdst      IR[26:22]
`define rsrc1     IR[21:17]
`define imm_mode  IR[16]
`define rsrc2     IR[15:11]
`define isrc      IR[15:0]


////////////////arithmetic operation
`define movsgpr        5'b00000
`define mov            5'b00001
`define add            5'b00010
`define sub            5'b00011
`define mul            5'b00100

////////////////logical operations : and or xor xnor nand nor not

`define ror            5'b00101
`define rand           5'b00110
`define rxor           5'b00111
`define rxnor          5'b01000
`define rnand          5'b01001
`define rnor           5'b01010
`define rnot           5'b01011

/////////////////////// load & store instructions

`define storereg       5'b01101   //////store content of register in data memory
`define storedin       5'b01110   ////// store content of din bus in data memory
`define senddout       5'b01111   /////send data from DM to dout bus
`define sendreg        5'b10001   ////// send data from DM to register

///////////////////////////// Jump and branch instructions
`define jump           5'b10010  ////jump to address
`define jcarry         5'b10011  ////jump if carry
`define jnocarry       5'b10100
`define jsign          5'b10101  ////jump if sign
`define jnosign        5'b10110
`define jzero          5'b10111  //// jump if zero
`define jnozero        5'b11000
`define joverflow      5'b11001 ////jump if overflow
`define jnooverflow    5'b11010

//////////////////////////halt
`define halt           5'b11011



module miniRISC(
input clk,sys_rst,
input [15:0] din,
output reg [15:0] dout
);

////////////////adding program and data memory
// inst_mem is now a hardcoded ROM (synthesizable)
(* keep *) reg [15:0] data_mem [15:0]; ////data memory

// Hardcoded instruction ROM - synthesizes to logic gates
// Program: multiply 5 * 6 = 30 using a loop
function [31:0] inst_rom;
    input [3:0] addr;
    begin
        case(addr)
            // MOV R0, #5        - Load multiplier
            4'd0: inst_rom = 32'b00001_00000_00000_1_0000000000000101;
            // MOV R1, #6        - Load multiplicand (also loop count)
            4'd1: inst_rom = 32'b00001_00001_00000_1_0000000000000110;
            // MOV R2, #0        - Clear accumulator
            4'd2: inst_rom = 32'b00001_00010_00000_1_0000000000000000;
            // MOV R3, #6        - Loop counter
            4'd3: inst_rom = 32'b00001_00011_00000_1_0000000000000110;
            // ADD R2, R2, R0    - Accumulate: R2 += R0
            4'd4: inst_rom = 32'b00010_00010_00010_0_00000_00000000000;
            // SUB R3, R3, #1    - Decrement counter
            4'd5: inst_rom = 32'b00011_00011_00011_1_0000000000000001;
            // JNOZERO 4         - Loop if R3 != 0
            4'd6: inst_rom = 32'b11000_00000_00000_0_0000000000000100;
            // MOV R4, R2        - Copy result to R4 (register mode)
            4'd7: inst_rom = 32'b00001_00100_00010_0_00000_00000000000;
            // HALT              - Stop execution
            4'd8: inst_rom = 32'b11011_00000_00000_0_0000000000000000;
            // Unused addresses - NOP (halt)
            default: inst_rom = 32'b11011_00000_00000_0_0000000000000000;
        endcase
    end
endfunction





(* keep *) reg [31:0] IR = 32'h0;    ////// instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_date      -->

(* keep *) reg [15:0] GPR [31:0] ;   ///////general purpose register gpr[0] ....... gpr[31]



reg [15:0] SGPR = 0;      ///// msb of multiplication --> special register

reg [31:0] mul_res;


reg sign = 0, zero = 0, overflow = 0, carry = 0; ///condition flag
reg [16:0] temp_sum;

reg jmp_flag = 0;
reg stop = 0;

////////////////////////////////////////////////////
////////////////////////////////// fsm states
parameter idle = 0, fetch_inst = 1, dec_exec_inst = 2, next_inst = 3, sense_halt = 4, delay_next_inst = 5;
//////idle : check reset state
///// fetch_inst : load instrcution from Program memory
///// dec_exec_inst : execute instruction + update condition flag
///// next_inst : next instruction to be fetched
reg [2:0] state = idle, next_state = idle;
////////////////////////////////// fsm states

////////////////////////////////////////////////////
//////////reading instructions one after another
(* keep *) reg [2:0] count = 0;
(* keep *) reg [3:0] PC = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

// No $readmemb needed - instructions are hardcoded in inst_rom function

///////////////////reset decoder
always@(posedge clk)
begin
 if(sys_rst)
   state <= idle;
 else
   state <= next_state;
end


//////////////////next state decoder (combinational - only next_state logic)

always@(*)
begin
  case(state)
   idle: begin
     next_state = fetch_inst;
   end

  fetch_inst: begin
    next_state  = dec_exec_inst;
  end

  dec_exec_inst: begin
    next_state  = delay_next_inst;
  end

  delay_next_inst: begin
    if(count < 4)
       next_state  = delay_next_inst;
    else
       next_state  = next_inst;
  end

  next_inst: begin
      next_state = sense_halt;
  end

 sense_halt: begin
    if(stop == 1'b0)
      next_state = fetch_inst;
    else if(sys_rst == 1'b1)
      next_state = idle;
    else
      next_state = sense_halt;
 end

  default : next_state = idle;

  endcase

end


////////////////////////////////// sequential updates (count, PC, IR, decode)

always@(posedge clk)
begin
  if(sys_rst) begin
    count <= 0;
    PC <= 0;
    IR <= 32'h0;
    jmp_flag <= 0;
    stop <= 0;
    sign <= 0;
    zero <= 0;
    overflow <= 0;
    carry <= 0;
    dout <= 0;
  end
  else begin
    case(state)

     idle : begin
        count <= 0;
        PC <= 0;
        IR <= 32'h0;
     end

     fetch_inst: begin
       count <= 0;
       IR <= inst_rom(PC);
     end

     dec_exec_inst : begin
       count <= 0;
       // Decode and execute instruction
       jmp_flag <= 1'b0;
       stop <= 1'b0;

       case(IR[31:27])  // oper_type
         `movsgpr: begin
           GPR[IR[26:22]] <= SGPR;
         end

         `mov: begin
           if(IR[16])  // imm_mode
             GPR[IR[26:22]] <= IR[15:0];
           else
             GPR[IR[26:22]] <= GPR[IR[21:17]];
         end

         `add: begin
           if(IR[16]) begin
             GPR[IR[26:22]] <= GPR[IR[21:17]] + IR[15:0];
             zero <= ((GPR[IR[21:17]] + IR[15:0]) == 16'd0) ? 1'b1 : 1'b0;
             sign <= (GPR[IR[21:17]] + IR[15:0]) >> 15;
             carry <= (({1'b0, GPR[IR[21:17]]} + {1'b0, IR[15:0]}) >> 16);
           end
           else begin
             GPR[IR[26:22]] <= GPR[IR[21:17]] + GPR[IR[15:11]];
             zero <= ((GPR[IR[21:17]] + GPR[IR[15:11]]) == 16'd0) ? 1'b1 : 1'b0;
             sign <= (GPR[IR[21:17]] + GPR[IR[15:11]]) >> 15;
             carry <= (({1'b0, GPR[IR[21:17]]} + {1'b0, GPR[IR[15:11]]}) >> 16);
           end
         end

         `sub: begin
           if(IR[16]) begin
             GPR[IR[26:22]] <= GPR[IR[21:17]] - IR[15:0];
             zero <= ((GPR[IR[21:17]] - IR[15:0]) == 16'd0) ? 1'b1 : 1'b0;
             sign <= (GPR[IR[21:17]] - IR[15:0]) >> 15;
           end
           else begin
             GPR[IR[26:22]] <= GPR[IR[21:17]] - GPR[IR[15:11]];
             zero <= ((GPR[IR[21:17]] - GPR[IR[15:11]]) == 16'd0) ? 1'b1 : 1'b0;
             sign <= (GPR[IR[21:17]] - GPR[IR[15:11]]) >> 15;
           end
         end

         `mul: begin
           if(IR[16]) begin
             GPR[IR[26:22]] <= (GPR[IR[21:17]] * IR[15:0]);
             SGPR <= (GPR[IR[21:17]] * IR[15:0]) >> 16;
           end
           else begin
             GPR[IR[26:22]] <= (GPR[IR[21:17]] * GPR[IR[15:11]]);
             SGPR <= (GPR[IR[21:17]] * GPR[IR[15:11]]) >> 16;
           end
         end

         `ror: begin
           if(IR[16])
             GPR[IR[26:22]] <= GPR[IR[21:17]] | IR[15:0];
           else
             GPR[IR[26:22]] <= GPR[IR[21:17]] | GPR[IR[15:11]];
         end

         `rand: begin
           if(IR[16])
             GPR[IR[26:22]] <= GPR[IR[21:17]] & IR[15:0];
           else
             GPR[IR[26:22]] <= GPR[IR[21:17]] & GPR[IR[15:11]];
         end

         `rxor: begin
           if(IR[16])
             GPR[IR[26:22]] <= GPR[IR[21:17]] ^ IR[15:0];
           else
             GPR[IR[26:22]] <= GPR[IR[21:17]] ^ GPR[IR[15:11]];
         end

         `rxnor: begin
           if(IR[16])
             GPR[IR[26:22]] <= GPR[IR[21:17]] ~^ IR[15:0];
           else
             GPR[IR[26:22]] <= GPR[IR[21:17]] ~^ GPR[IR[15:11]];
         end

         `rnand: begin
           if(IR[16])
             GPR[IR[26:22]] <= ~(GPR[IR[21:17]] & IR[15:0]);
           else
             GPR[IR[26:22]] <= ~(GPR[IR[21:17]] & GPR[IR[15:11]]);
         end

         `rnor: begin
           if(IR[16])
             GPR[IR[26:22]] <= ~(GPR[IR[21:17]] | IR[15:0]);
           else
             GPR[IR[26:22]] <= ~(GPR[IR[21:17]] | GPR[IR[15:11]]);
         end

         `rnot: begin
           if(IR[16])
             GPR[IR[26:22]] <= ~(IR[15:0]);
           else
             GPR[IR[26:22]] <= ~(GPR[IR[21:17]]);
         end

         `storedin: begin
           data_mem[IR[15:0]] <= din;
         end

         `storereg: begin
           data_mem[IR[15:0]] <= GPR[IR[21:17]];
         end

         `senddout: begin
           dout <= data_mem[IR[15:0]];
         end

         `sendreg: begin
           GPR[IR[26:22]] <= data_mem[IR[15:0]];
         end

         `jump: begin
           jmp_flag <= 1'b1;
         end

         `jcarry: begin
           jmp_flag <= (carry == 1'b1) ? 1'b1 : 1'b0;
         end

         `jsign: begin
           jmp_flag <= (sign == 1'b1) ? 1'b1 : 1'b0;
         end

         `jzero: begin
           jmp_flag <= (zero == 1'b1) ? 1'b1 : 1'b0;
         end

         `joverflow: begin
           jmp_flag <= (overflow == 1'b1) ? 1'b1 : 1'b0;
         end

         `jnocarry: begin
           jmp_flag <= (carry == 1'b0) ? 1'b1 : 1'b0;
         end

         `jnosign: begin
           jmp_flag <= (sign == 1'b0) ? 1'b1 : 1'b0;
         end

         `jnozero: begin
           jmp_flag <= (zero == 1'b0) ? 1'b1 : 1'b0;
         end

         `jnooverflow: begin
           jmp_flag <= (overflow == 1'b0) ? 1'b1 : 1'b0;
         end

         `halt: begin
           stop <= 1'b1;
         end

         default: begin
           // Do nothing
         end
       endcase

       // Update condition flags (simplified - flags update after ALU ops)
       // Note: This happens one cycle after the operation due to sequential logic
     end

     delay_next_inst: begin
       count <= count + 1;
     end

     next_inst : begin
        count <= 0;
        if(jmp_flag == 1'b1)
          PC <= IR[3:0];  // Use lower 4 bits for 16 instruction memory
        else
          PC <= PC + 1;
     end

     sense_halt : begin
        count <= 0;
     end

     default : count <= 0;

    endcase
  end
end

endmodule
