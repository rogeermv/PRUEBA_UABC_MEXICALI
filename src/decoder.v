
/*
      -- 1 --
     |       |
     6       2
     |       |
      -- 7 --
     |       |
     5       3
     |       |
      -- 4 --
*/

module seg7 (
    input wire [3:0] counter,
    output reg [6:0] segments
);

    always @(*) begin
        case(counter)
            0:  segments = 7'b0000000;
            1:  segments = 7'b1110000; //R
            2:  segments = 7'b0111111; //O
            3:  segments = 7'b1101111; //G
            4:  segments = 7'b1111001; //E
            5:  segments = 7'b0111000; //L
            6:  segments = 7'b0110000; //I
            7:  segments = 7'b0111111; //O
	    default:
                segments = 7'b0000000;
        endcase
    end

endmodule

