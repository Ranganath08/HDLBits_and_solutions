// ============================================
// HDLBits Problem :  FSM
// Topic           :  Lemmings2
// Solved by       :  Ranganath H L
// Date            :  2026-06-01
// Link            : https://hdlbits.01xz.net/wiki/Lemmings2
// ============================================
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    parameter left=0, right=1, fall_l=2, fall_r=3;
    reg [1:0] state, next_state;
    
    always @ (*) begin
        case(state)
            left : next_state = !ground ? fall_l : (bump_left ? right : left);
            right : next_state = !ground ? fall_r : (bump_right ? left : right);
            fall_l : next_state = ground ? left : fall_l;
            fall_r : next_state = ground ? right : fall_r;
        endcase
    end
    
    always @ (posedge clk , posedge areset) begin
        if (areset)
            state <= left;
        else 
            state <= next_state;
    end
    
    assign walk_left = (state == left);
    assign walk_right = (state == right);
    assign aaah = (state == fall_l) | (state == fall_r);
    
endmodule
