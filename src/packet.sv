const int RJ_PKT_SIZE = 6;

typedef struct packed {
    rj_pkt_h_kind_e     kind;
    rj_pkt_h_level_e    level;
} rj_pkt_header_s;

typedef struct packed {
    bit [1:0][7:0] raw_data;
} rj_pkt_body_s;

typedef struct packed {
    bit [1:0][7:0] checksum;
} rj_pkt_footer_s;

typedef struct packed {
    rj_pkt_footer_s  f;
    rj_pkt_body_s    b;
    rj_pkt_header_s  h;
} rj_pkt_s;

typedef union packed {
    rj_pkt_s        s;
    bit [5:0][7:0]  byte_view;
} rj_pkt_u;

class rj_packet extends uvm_object;
    // unprotected: It means this block can let user to see, don't need to encrypt
    rand rj_pkt_h_level_e level_for_user;

    // proteced, below
    const int pkt_idx;
    static int global_pkt_idx_cnt;
    rand rj_pkt_u u;
    bit [7:0] raw_byte_q[$]; // used to communicate outside, can be more convenient 

    constraint basic_rj_packet {
        // for header
        u.s.h.kind == RJ_PACKET;
        u.s.h.level inside {SUPER_LIKE, NORMAL_LIKE, LITTLE_LIKE};
        level_for_user == u.s.h.level;

        // for body
        u.s.b != 0;

        // for checksum
        u.s.f == (u.s.h + u.s.b)/2;
    }

    function new(string name = "rj_packet");
        super.new(name);
        pkt_idx = global_pkt_idx_cnt;
        global_pkt_idx_cnt++;
    endfunction

    function void post_randomize();
        pack();
    endfunction

    function void pack();
        raw_byte_q.delete();
        check_chksum();
        for (int i=0; i<RJ_PKT_SIZE; i++)
            raw_byte_q.push_back(u.byte_view[i]);
    endfunction

    function void check_chksum();
        if (u.s.f != (u.s.h + u.s.b)/2)
            `uvm_error("rj_packet", "check_chksum failed")
    endfunction

    function void unpack();
        u.byte_view = '0;
        for (int i=0; i<RJ_PKT_SIZE; i++)
            u.byte_view[i] = raw_byte_q[i];
    endfunction

    function string sprint(shortint verbosity = 0);
        string s = $sformatf("\n    rj_packet#%0h(Kind:'h%h(%s))\n", pkt_idx, u.s.h.kind, rj_pkt_h_kind_e'(u.s.h.kind));
        if (verbosity <= 0)
            return s;

        s = {s, $sformatf("         header: %p", u.s.h), "\n"};
        s = {s, $sformatf("         body: %p", u.s.b), "\n"};
        s = {s, $sformatf("         footer(checksum): %p", u.s.f), "\n"};
        s = {s, $sformatf("         byte_view: %p", u.byte_view), "\n"};

        return s;
    endfunction
endclass