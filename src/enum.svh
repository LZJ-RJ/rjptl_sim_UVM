typedef enum bit[7:0] {
    RJ_PACKET   = 8'hCC
} rj_pkt_h_kind_e;

typedef enum bit[7:0] {
    SUPER_LIKE  = 8'hFF,
    NORMAL_LIKE = 8'hF0,
    LITTLE_LIKE = 8'h0F
} rj_pkt_h_level_e;