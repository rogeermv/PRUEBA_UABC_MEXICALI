`default_nettype none

module tt_um_seven_segment_seconds #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;
    wire [6:0] led_out;
    assign uo_out[6:0] = led_out;
    assign uo_out[7] = 1'b0;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    // put bottom 8 bits of second counter out on the bidirectional gpio
    assign uio_out = second_counter[7:0];

    // external clock is 10MHz, so need 24 bit counter
    reg [23:0] second_counter;
    reg [3:0] digit;
    reg reloj;

    // if external inputs are set then use that as compare count
    // otherwise use the hard coded MAX_COUNT
    wire [23:0] compare = ui_in == 0 ? MAX_COUNT: {6'b0, ui_in[7:0], 10'b0};


    always @(posedge clk) begin
        second_counter <= second_counter + 1;
        if(second_counter == 5000000) begin
            second_counter <= 0;
            reloj <= ~reloj;
        end
    end
    
    
    always @(posedge reloj) begin
        if (reset) begin
            second_counter <= 0;
            digit <= 0;
        end else begin
            if (digit == 7) begin
                // reset
                digit <= 0;
            end else
                // increment counter
                digit <= digit + 1'b1;
        end
    end

    // instantiate segment display
    seg7 seg7(.counter(digit), .segments(led_out));

endmodule
