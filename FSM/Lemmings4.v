// ============================================
// HDLBits Problem :  FSM
// Topic           :  Lemmings4
// Solved by       :  Ranganath H L
// Date            :  2026-06-16
// Link            : https://hdlbits.01xz.net/wiki/Lemmings4
// ============================================
module top_module(
    input clk,
    input areset,    
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter left=0, right=1, dig_l=2, dig_r=3, fall_l=4, fall_r=5, splat=6;
    reg [2:0] state, next_state;
    
    // INCREASED SIZE: 8 bits to safely handle longer falls
    reg [7:0] count; 

    // Sequential State and Counter Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= left;
            count <= 0;
        end else begin
            state <= next_state;
            
            if (state == fall_l || state == fall_r) begin
                // OVERFLOW PROTECTION: Cap the counter at 255 so it never rolls over to 0
                if (count < 8'hFF)
                    count <= count + 1'b1;
            end else begin
                count <= 0;
            end
        end
    end

    // Combinational Next State Logic
    always @(*) begin
        case (state)
            left:  next_state = !ground ? fall_l : (dig ? dig_l : (bump_left ? right : left));
            right: next_state = !ground ? fall_r : (dig ? dig_r : (bump_right ? left : right));
            
            dig_l: next_state = !ground ? fall_l : dig_l;
            dig_r: next_state = !ground ? fall_r : dig_r;
            
            fall_l: next_state = ground ? (count > 19 ? splat : left) : fall_l;
            fall_r: next_state = ground ? (count > 19 ? splat : right) : fall_r;
            
            splat:  next_state = splat;
            default: next_state = left;
        endcase
    end

    // Output Logic
    assign walk_left  = (state == left);
    assign walk_right = (state == right);
    assign aaah       = (state == fall_l || state == fall_r);
    assign digging    = (state == dig_l || state == dig_r);

endmodule
