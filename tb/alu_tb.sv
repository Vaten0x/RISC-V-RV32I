module alu_tb();
    logic [31:0] a, b, result;
    logic [3:0] op;
    
    logic [31:0] ra, rb; //random stimulus
    logic [3:0] rop;
    int errors = 0;

    alu dut (.a(a), .b(b), .op(op), .result(result));

    //this is the reference model
    function automatic logic [31:0] model(logic [31:0] x, y, logic [3:0] f);
        case (f)
            4'b0000: return x + y;
            4'b0001: return x - y;
            4'b0010: return (x << y[4:0]);
            4'b0011: return (($signed(x) < $signed(y)) ? 32'd1 : 32'b0);
            4'b0100: return (($unsigned(x) < $unsigned(y)) ? 32'd1 : 32'b0);
            4'b0101: return x ^ y;
            4'b0110: return x >> y[4:0];
            4'b0111: return ($signed(x) >>> y[4:0]);
            4'b1000: return x | y;
            4'b1001: return x & y;
            default: return '0;
        endcase
    endfunction

    task automatic check(logic [31:0] a_in, b_in, logic [3:0] op_in, logic [31:0] expected);
        a = a_in; b = b_in; op = op_in;
        #1;
        if (result !== expected) begin
            $display("ERROR op=%0d a=%h b=%h got=%h expected=%h", op, a, b, result, expected);
            errors++;
        end
    endtask

    initial begin
        check(32'hFFFFFFFF, 32'd1, 4'd0, 32'h00000000);

        repeat (1000) begin
            ra = $urandom();
            rb = $urandom();
            rop = $urandom_range(0, 9);
            check(ra, rb, rop, model(ra, rb, rop));
        end

        if (errors == 0) $display("PASS");
        else $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule