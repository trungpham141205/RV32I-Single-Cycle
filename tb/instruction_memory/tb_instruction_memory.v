`timescale 1ns/1ps
module tb_instruction_memory();

	reg [31:0] read_address;
	wire [31:0] instruction;

	instruction_memory dut_tb_instruction_memory(
		.read_address(read_address),
		.instruction(instruction)
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
	reg seen_first = 0;
	reg seen_last = 0;

	// =========================
	// GOLDEN MODEL
	// =========================
	reg [31:0] golden_mem [63:0];
	
	// =========================
	// INIT GOLDEN MEMORY
	// =========================
	initial begin
		$readmemh("../../src/memory/program.hex", golden_mem);
	end

	// =========================
	// CHECKER
	// =========================
	task check;
		input [31:0] expected;
		begin
			total_tests = total_tests + 1;
			if(instruction === expected) begin
				pass_count = pass_count + 1;	
			end
			else begin
				fail_count = fail_count + 1;
				$display("X FAIL: addr=%h instr=%h expected=%h", read_address, instruction, expected);
			end
		end
	endtask

	// =========================
	// APPLY + CHECK
	// =========================
	task apply_and_check;
		input [31:0] addr;
		reg [31:0] expected;
		begin
			read_address = addr;
			#1;
			expected = golden_mem[addr[7:2]];
			
			// COVERAGE
			if(addr[7:2] == 0) seen_first = 1;
			if(addr[7:2] == 255) seen_last = 1;
			
			check(expected);
		end
	endtask

	integer i;
	
	initial begin
		read_address = 0;
		
		// =========================
		// 1. DIRECTED TEST 
		// =========================

		apply_and_check(0);
		apply_and_check(4);
		apply_and_check(8);
		apply_and_check(16);
		
		// =========================
		// 2. EDGE CASE
		// =========================
		apply_and_check(3);
		apply_and_check(1024);
		
		// =========================
		// 3. RANDOM TEST
		// =========================
		repeat (20) begin
			apply_and_check($random);
		end

		// =========================
		// REPORT
		// =========================
		$display("\n===== TEST SUMMARY =====");
		$display("Total: %0d", total_tests);
		$display("Pass: %0d", pass_count);
		$display("Fail: %0d", fail_count);
		
		$display("\n===== COVERAGE =====");
		$display("Seen first addr: %0d", seen_first);
		$display("Senn last addr: %0d", seen_last);
		
		if(seen_first && seen_last)
			$display("COVERAGE PASSED");
		else
			$display("X COVERAGE FAILED");
		
		$finish;
	end

endmodule
