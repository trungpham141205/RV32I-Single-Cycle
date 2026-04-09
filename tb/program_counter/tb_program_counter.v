`timescale 1ns/1ps
module tb_program_counter();

    reg clk, rst;
    reg [31:0] pc_next;
    wire [31:0] pc;

    program_counter dut_tb_program_counter(
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    // =========================
    // COUNTERS
    // =========================
    integer total_tests = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // =========================
    // COVERAGE
    // =========================
    reg seen_reset = 0;
    reg seen_normal = 0;
    reg seen_transition = 0;

    // =========================
    // CLOCK
    // =========================
    always #5 clk = ~clk;

    // =========================
    // GOLDEN MODEL
    // =========================
    reg [31:0] expected_pc;

    // =========================
    // CHECKER
    // =========================
    task check;
        begin
            total_tests = total_tests + 1;
            if(pc === expected_pc) begin
                pass_count = pass_count + 1;
            end
            else begin
                fail_count = fail_count + 1;
                $display("X FAIL: pc = %h, expected = %h", pc, expected_pc);
            end
        end
    endtask

    // =========================
    // APPLY + CHECK
    // =========================
    task apply_and_check;
        input trst;
        input [31:0] tnext;
        begin
            rst = trst;
            pc_next = tnext;

            #10;

            // golden model
            expected_pc = (rst) ? 32'b0 : pc_next;

            // coverage
            if (rst) seen_reset = 1;
            else seen_normal = 1;

            // transition detect
            if (seen_reset && seen_normal)
                seen_transition = 1;

            check();          
        end
    endtask

    // =========================
    // ASSERTION (basic)
    // =========================
    always @(posedge clk) begin
        if (rst && pc !== 0) begin
            $display("X ASSERT FAIL: pc must be 0 when reset!");
        end
    end

    integer i;

    initial begin
        clk = 0;
        rst = 0;
        pc_next = 0;

        // =========================
        // 1. DIRECTED TEST
        // =========================
        apply_and_check(1, 32'h12345678); // reset → pc=0
        apply_and_check(0, 32'h00000004);
        apply_and_check(0, 32'h00000008);

        // reset giữa chừng
        apply_and_check(1, 32'hFFFFFFFF);
        apply_and_check(0, 32'hABCDEF00);

        // =========================
        // 2. RANDOM TEST
        // =========================
        repeat (20) begin
            apply_and_check($random % 2, $random);
        end

        // =========================
        // 3. CONSTRAINED RANDOM
        // =========================
        for (i = 0; i < 20; i = i + 1) begin
            apply_and_check(0, i * 4); // PC step chuẩn RISC-V
        end

        // =========================
        // REPORT
        // =========================
        $display("\n===== TEST SUMMARY =====");
        $display("Total : %0d", total_tests);
        $display("Pass  : %0d", pass_count);
        $display("Fail  : %0d", fail_count);

        // coverage report
        $display("\n===== COVERAGE =====");
        $display("Seen reset      : %0d", seen_reset);
        $display("Seen normal     : %0d", seen_normal);
        $display("Seen transition : %0d", seen_transition);

        if (seen_reset && seen_normal && seen_transition)
            $display("COVERAGE PASSED");
        else
            $display("X COVERAGE FAILED");

        $finish;
    end
endmodule
