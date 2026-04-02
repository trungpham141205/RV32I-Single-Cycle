'`timescale 1ns/1ps
module tb_riscv;

    reg clk, rst;

    initial clk = 0;
    always #5 clk = ~clk;

    riscv_top dut(
        .clk (clk),
        .rst (rst)
    );

    integer pass_count;
    integer fail_counter;

    task check_reg;
        input [4:0]  reg_num;
        input [31:0] expected;
        input [255:0] test_name;
        begin
            if (dut.dut_register_file.registers[reg_num] === expected) begin
                $display("  PASS | %-25s | x%0d = %0d (0x%08h)",
                    test_name, reg_num, expected, expected);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL | %-25s | x%0d expected %0d, got %0d",
                    test_name, reg_num, expected,
                    dut.dut_register_file.registers[reg_num]);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task check_mem;
        input [31:0] byte_addr;
        input [31:0] expected;
        begin
            if (dut.dut_data_memory.data_mem[byte_addr[7:2]] === expected) begin
                $display("  PASS | %-25s | mem[0x%02h] = %0d (0x%08h)",
                    "mem check", byte_addr, expected, expected);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL | %-25s | mem[0x%02h] expected %0d, got %0d",
                    "mem check", byte_addr, expected,
                    dut.dut_data_memory.data_mem[byte_addr[7:2]]);
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer cycle_count;
    initial cycle_count = 0;
 
    always @(posedge clk) begin
        if (!rst) begin
            cycle_count = cycle_count + 1;
            $display("  [cycle %02d] PC=0x%08h | INSTR=0x%08h | x1=%0d x2=%0d x3=%0d",
                cycle_count,
                dut.pc,
                dut.instruction,
                dut.dut_register_file.registers[1],
                dut.dut_register_file.registers[2],
                dut.dut_register_file.registers[3]
            );
        end
    end

        initial begin
        // Waveform dump
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_riscv);
 
        pass_count = 0;
        fail_count = 0;
 
        $display("\n======================================");
        $display("       RISC-V RV32I CPU TESTBENCH     ");
        $display("======================================\n");
 
        // ── Reset ────────────────────────────
        $display("[RESET]");
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        $display("[RUN]\n");
 
        // ── Chạy đủ cycle ────────────────────
        // 16 lệnh, +4 dự phòng
        repeat(20) @(posedge clk);
 
        // ── Kiểm tra register ────────────────
        $display("\n------ REGISTER CHECK ------");
        check_reg(1,  32'd5,  "addi x1, x0, 5");
        check_reg(2,  32'd3,  "addi x2, x0, 3");
        check_reg(3,  32'd8,  "add  x3, x1, x2");
        check_reg(4,  32'd2,  "sub  x4, x1, x2");
        check_reg(5,  32'd1,  "and  x5, x1, x2");
        check_reg(6,  32'd7,  "or   x6, x1, x2");
        check_reg(7,  32'd6,  "xor  x7, x1, x2");
        check_reg(8,  32'd1,  "slt  x8, x2, x1");
        check_reg(9,  32'd8,  "lw   x9, 0(x0)");
        check_reg(10, 32'd42, "beq  skip -> x10=42");
        check_reg(11, 32'h38, "jal  x11 = PC+4");
 
        // ── x10 không được = 99 (beq phải nhảy) ──
        if (dut.dut_register_file.registers[10] !== 32'd99) begin
            $display("  PASS | %-25s | x10 != 99 (beq taken)", "beq not fall-through");
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL | %-25s | beq không nhảy", "beq not fall-through");
            fail_count = fail_count + 1;
        end
 
        // ── x12 không được = 99 (jal phải nhảy) ──
        if (dut.dut_register_file.registers[12] !== 32'd99) begin
            $display("  PASS | %-25s | x12 != 99 (jal taken)", "jal not fall-through");
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL | %-25s | jal không nhảy", "jal not fall-through");
            fail_count = fail_count + 1;
        end
 
        // ── x0 luôn = 0 ─────────────────────
        check_reg(0, 32'd0, "x0 always zero");
 
        // ── Kiểm tra memory ──────────────────
        $display("\n------ MEMORY CHECK ------");
        check_mem(32'h00, 32'd8);   // sw x3, 0(x0)
 
        // ── Tóm tắt ──────────────────────────
        $display("\n======================================");
        $display("  PASS: %0d | FAIL: %0d | TOTAL: %0d",
            pass_count, fail_count, pass_count + fail_count);
        if (fail_count == 0)
            $display("  >>> ALL TESTS PASSED <<<");
        else
            $display("  >>> %0d TEST(S) FAILED <<<", fail_count);
        $display("======================================\n");
 
        $finish;
    end

endmodule