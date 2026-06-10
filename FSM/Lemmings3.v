// ============================================
// HDLBits Problem :  FSM
// Topic           :  Lemmings3
// Solved by       :  Ranganath H L
// Date            :  2026-06-10
// Link            : https://hdlbits.01xz.net/wiki/Lemmings3
// ============================================

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    
    parameter left=0, right=1, fall_l=2, fall_r=3, dig_l=4, dig_r=5;
    
    reg [2:0] state, next_state;
  
    always @ (*) begin 
        case (state)
            left : next_state = !ground ? fall_l : (dig ? dig_l : (bump_left ? right : left));
            right : next_state = !ground ? fall_r : (dig ? dig_r : (bump_right ? left : right));
            fall_l : next_state = !ground ? fall_l : left;
            fall_r : next_state = !ground ? fall_r : right;
            dig_l : next_state = !ground ? fall_l : dig_l;
            dig_r : next_state = !ground ? fall_r : dig_r;
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
    assign aaah = (state == fall_l | state == fall_r);
    assign digging = (state == dig_l | state == dig_r);
    
endmodule
