# A Whole New Protocol: rjptl
Purpose: Only transmit a packet to tell the world how much you like rj

Packet Summary
-
Partition: *Packet Header* | *Packet Body* | *Packet Footer*

Total Bytes: 6(=2 + 2 + 2)

Type: *rj_packet*

Packet Detail
-
*Packet Header*: 2 bytes

    - 1st byte: Packet Type
        - rj_packet == 'hCC;

    - 2nd byte: How much I like rj
        - Super  Like: 8'b11111111
        - Normal Like: 8'b11110000
        - Little Like: 8'b00001111

*Packet Body*: 2 bytes

    - Random data

*Packet Footer*: 2 bytes

    - Checksum: Add the Packet Header and the Packet Body, then divide the result by two.