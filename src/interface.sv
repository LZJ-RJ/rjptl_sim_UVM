`timescale 1ps/1ps

interface rj_if;
    logic [1:0] rj_lane; // [0]: for data; [1]: for clk

    // set clock by high low period 
    task automatic gen_tx_clk(
        real clk_h,
        real clk_l
        );
        time t_h = clk_h * 1ps;
        time t_l = clk_l * 1ps;
        
        rj_lane[1] = 0;
        # t_l;
        rj_lane[1] = 1;
        # t_h;
    endtask
endinterface