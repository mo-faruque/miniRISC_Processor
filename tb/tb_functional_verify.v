`timescale 1ns / 1ps

// Testbench for synthesizable miniRISC - verifies functional correctness
module tb_functional_verify;

    reg clk = 0;
    reg sys_rst = 0;
    reg [15:0] din = 0;
    wire [15:0] dout;

    // Instantiate the design
    top dut(clk, sys_rst, din, dout);

    // Clock generation - 10ns period (100MHz)
    always #5 clk = ~clk;

    // Test program:
    // GPR[0] = 5, GPR[1] = 6, GPR[2] = 0, GPR[3] = 6
    // Loop: GPR[2] += GPR[0], GPR[3] -= 1, if GPR[3] != 0 goto loop
    // Result: GPR[2] = 5*6 = 30, GPR[4] = GPR[2]

    integer cycle_count;
    integer errors;

    initial begin
        $dumpfile("tb_functional_verify.vcd");
        $dumpvars(0, tb_functional_verify);

        // Explicitly dump GPR array elements (not auto-dumped)
        $dumpvars(1, dut.GPR[0], dut.GPR[1], dut.GPR[2], dut.GPR[3], dut.GPR[4]);
        $dumpvars(1, dut.GPR[5], dut.GPR[6], dut.GPR[7], dut.GPR[8], dut.GPR[9]);

        // Dump key control signals explicitly
        $dumpvars(1, dut.IR, dut.PC, dut.state, dut.stop);
        $dumpvars(1, dut.zero, dut.sign, dut.carry, dut.overflow, dut.jmp_flag);

        errors = 0;
        cycle_count = 0;

        $display("===========================================");
        $display("miniRISC Synthesizable Design - Test Start");
        $display("===========================================");

        // Apply reset
        sys_rst = 1'b1;
        repeat(5) @(posedge clk);
        sys_rst = 1'b0;

        $display("Reset released at cycle %0d", cycle_count);

        // Wait for program to execute
        // The loop runs 6 times, each instruction takes ~7 cycles (fetch, decode, delay*5, next, sense)
        // 9 instructions * ~7 cycles * 6 iterations + setup = ~400 cycles max
        repeat(500) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;

            // Debug: Print instruction at each fetch
            if (dut.state == 1) begin  // fetch_inst
                $display("[Cycle %0d] FETCH: PC=%d IR will be=%h", cycle_count, dut.PC, dut.inst_rom(dut.PC));
            end
            // Debug: Print state when executing
            if (dut.state == 2) begin  // dec_exec_inst
                $display("[Cycle %0d] EXEC: IR=%h oper=%b GPR[0]=%d GPR[2]=%d",
                    cycle_count, dut.IR, dut.IR[31:27], dut.GPR[0], dut.GPR[2]);
            end

            // Check for halt condition
            if (dut.stop == 1'b1) begin
                $display("HALT detected at cycle %0d", cycle_count);

                // Wait a few more cycles for final values to settle
                repeat(5) @(posedge clk);

                // Check results
                $display("-------------------------------------------");
                $display("Final Register Values:");
                $display("  GPR[0] = %0d (expected: 5)", dut.GPR[0]);
                $display("  GPR[1] = %0d (expected: 6)", dut.GPR[1]);
                $display("  GPR[2] = %0d (expected: 30)", dut.GPR[2]);
                $display("  GPR[3] = %0d (expected: 0)", dut.GPR[3]);
                $display("  GPR[4] = %0d (expected: 30)", dut.GPR[4]);
                $display("-------------------------------------------");

                // Verify expected values
                if (dut.GPR[0] !== 16'd5) begin
                    $display("ERROR: GPR[0] mismatch!");
                    errors = errors + 1;
                end
                if (dut.GPR[1] !== 16'd6) begin
                    $display("ERROR: GPR[1] mismatch!");
                    errors = errors + 1;
                end
                if (dut.GPR[2] !== 16'd30) begin
                    $display("ERROR: GPR[2] mismatch! Got %0d, expected 30", dut.GPR[2]);
                    errors = errors + 1;
                end
                if (dut.GPR[3] !== 16'd0) begin
                    $display("ERROR: GPR[3] mismatch!");
                    errors = errors + 1;
                end
                if (dut.GPR[4] !== 16'd30) begin
                    $display("ERROR: GPR[4] mismatch! Got %0d, expected 30", dut.GPR[4]);
                    errors = errors + 1;
                end

                if (errors == 0) begin
                    $display("===========================================");
                    $display("TEST PASSED - All registers correct!");
                    $display("===========================================");
                end else begin
                    $display("===========================================");
                    $display("TEST FAILED - %0d errors found", errors);
                    $display("===========================================");
                end

                $finish;
            end
        end

        $display("ERROR: HALT not reached within 500 cycles!");
        $display("  Current state: %0d", dut.state);
        $display("  PC: %0d", dut.PC);
        $display("  stop flag: %0d", dut.stop);
        $display("TEST FAILED");
        $finish;
    end

endmodule
