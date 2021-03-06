`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yoan Andreev
// 
// Create Date: 02/15/2020 06:25:46 PM
// Design Name: 
// Module Name: pulseDriver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Takes a 12 bit number and creates a pulse with that period in nanoseconds
//              on the output. Has three parameters; minPulse - minimum servo accepted pulse,
//              maxPulse - maximum servo accepted pulse,
//              clkDiv - clock divider scale. (default 100 for 100MHz clock
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: None
// Revision 0.02 - Paramterized some constants
// Additional Comments: Still need to implement deadband and the enable pin (maybe)
//                      Does not simulate but does run on hardware.
//////////////////////////////////////////////////////////////////////////////////


module pulseDriver  #(
    parameter minPulse = 500,
              maxPulse = 2500,
              clkDiv = 100
    )
    (
    input wire [11:0] value,
    input wire clk, rst_n, en_n,
    output reg pulse
    );
    
    reg [19:0] counter; // 20 bit counter. ( divide by 100 to account for 100mhz clock
    
    always @ (posedge clk, negedge rst_n)
    begin
        if(~rst_n)
        begin
            pulse <= 0;
            counter <= 5'h0_0000;
        end
        else
        begin
            if(value >= minPulse && value <= maxPulse)
            begin
                counter <= counter+1;
                if(counter/clkDiv > value)
                begin
                    counter <= 5'h0_0000;
                    pulse <= ~pulse;
                end
            end
            else
                pulse <= 0;
        end
    end
    
endmodule
