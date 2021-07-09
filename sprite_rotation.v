
`ifndef SPRITE_ROTATION_H
`define SPRITE_ROTATION_H

`include "hvsync_generator.v"

/*
tank_bitmap - ROM for tank bitmaps (5 different rotations)
sprite_renderer2 - Displays a 16x16 sprite.
tank_controller - Handles display and movement for one tank.
*/

module tank_bitmap(addr, bits);
  
  input [7:0] addr;
  output [7:0] bits;
  
  reg [15:0] bitarray[0:255];
  
  assign bits = (addr[0]) ? bitarray[addr>>1][15:8] : bitarray[addr>>1][7:0];
  
  initial begin/*{w:16,h:16,bpw:16,count:5}*/
    bitarray['h00] = 16'b0;
    bitarray['h01] = 16'b0;
    bitarray['h02] = 16'b0;
    bitarray['h03] = 16'b0;
    bitarray['h04] = 16'b0;
    bitarray['h05] = 16'b0;
    bitarray['h06] = 16'b0;
    bitarray['h07] = 16'b0;
    bitarray['h08] = 16'b0;
    bitarray['h09] = 16'b0;
    bitarray['h0a] = 16'b0;
    bitarray['h0b] = 16'b0;
    bitarray['h0c] = 16'b0;
    bitarray['h0d] = 16'b0;
    bitarray['h0e] = 16'b0;
    bitarray['h0f] = 16'b0;
    
    bitarray['h10] = 16'b111111111111111;
    bitarray['h11] = 16'b111111111111111;
    bitarray['h12] = 16'b111111111111111;
    bitarray['h13] = 16'b111111111111111;
    bitarray['h14] = 16'b111111111111111;
    bitarray['h15] = 16'b111111111111111;
    bitarray['h16] = 16'b111111111111111;
    bitarray['h17] = 16'b111111111111111;
    bitarray['h18] = 16'b111111111111111;
    bitarray['h19] = 16'b111111111111111;
    bitarray['h1a] = 16'b111111111111111;
    bitarray['h1b] = 16'b111111111111111;
    bitarray['h1c] = 16'b111111111111111;
    bitarray['h1d] = 16'b111111111111111;
    bitarray['h1e] = 16'b111111111111111;
    bitarray['h1f] = 16'b111111111111111;
    
    bitarray['h20] = 16'b111111111111111;
    bitarray['h21] = 16'b111111111111111;
    bitarray['h22] = 16'b111111111111111;
    bitarray['h23] = 16'b111111111111111;
    bitarray['h24] = 16'b111111111111111;
    bitarray['h25] = 16'b111111111111111;
    bitarray['h26] = 16'b111111111111111;
    bitarray['h27] = 16'b111111111111111;
    bitarray['h28] = 16'b111111111111111;
    bitarray['h29] = 16'b111111111111111;
    bitarray['h2a] = 16'b111111111111111;
    bitarray['h2b] = 16'b111111111111111;
    bitarray['h2c] = 16'b111111111111111;
    bitarray['h2d] = 16'b111111111111111;
    bitarray['h2e] = 16'b111111111111111;
    bitarray['h2f] = 16'b111111111111111;

    bitarray['h30] =16'b111111111111111;
    bitarray['h31] =16'b111111111111111;
    bitarray['h32] =16'b111111111111111;
    bitarray['h33] =16'b111111111111111;
    bitarray['h34] =16'b111111111111111;
    bitarray['h35] =16'b111111111111111;
    bitarray['h36] =16'b111111111111111;
    bitarray['h37] =16'b111111111111111;
    bitarray['h38] =16'b111111111111111;
    bitarray['h39] =16'b111111111111111;
    bitarray['h3a] =16'b111111111111111;
    bitarray['h3b] =16'b111111111111111;
    bitarray['h3c] =16'b111111111111111;
    bitarray['h3d] =16'b111111111111111;
    bitarray['h3e] =16'b111111111111111;
    bitarray['h3f] =16'b111111111111111;

    bitarray['h40] = 16'b111111111111111;
    bitarray['h41] = 16'b111111111111111;
    bitarray['h42] = 16'b111111111111111;
    bitarray['h43] = 16'b111111111111111;
    bitarray['h44] = 16'b111111111111111;
    bitarray['h45] = 16'b111111111111111;
    bitarray['h46] = 16'b111111111111111;
    bitarray['h47] = 16'b111111111111111;
    bitarray['h48] = 16'b111111111111111;
    bitarray['h49] = 16'b111111111111111;
    bitarray['h4a] = 16'b111111111111111;
    bitarray['h4b] = 16'b111111111111111;
    bitarray['h4c] = 16'b111111111111111;
    bitarray['h4d] = 16'b111111111111111;
    bitarray['h4e] = 16'b111111111111111;
    bitarray['h4f] = 16'b111111111111111;
  end
endmodule

// 16xundefined sprite renderer that supports rotation
module sprite_renderer2(clk, vstart, load, hstart, rom_addr, rom_bits, 
                       hmirror, vmirror,
                       gfx, busy);
  
  input clk, vstart, load, hstart;
  input hmirror, vmirror;
  output [4:0] rom_addr;
  input [7:0] rom_bits;
  output gfx;
  output busy;
  
  assign busy = state != WAIT_FOR_VSTART;

  reg [2:0] state;
  reg [3:0] ycount;
  reg [3:0] xcount;
  
  reg [15:0] outbits;
  
  localparam WAIT_FOR_VSTART = 0;
  localparam WAIT_FOR_LOAD   = 1;
  localparam LOAD1_SETUP     = 2;
  localparam LOAD1_FETCH     = 3;
  localparam LOAD2_SETUP     = 4;
  localparam LOAD2_FETCH     = 5;
  localparam WAIT_FOR_HSTART = 6;
  localparam DRAW            = 7;
  
  always @(posedge clk)
    begin
      case (state)
        WAIT_FOR_VSTART: begin
          ycount <= 0;
          // set a default value (blank) for pixel output
          // note: multiple non-blocking assignments are vendor-specific
	  gfx <= 0;
          if (vstart) state <= WAIT_FOR_LOAD;
        end
        WAIT_FOR_LOAD: begin
          xcount <= 0;
	  gfx <= 0;
          if (load) state <= LOAD1_SETUP;
        end
        LOAD1_SETUP: begin
          rom_addr <= {vmirror?~ycount:ycount, 1'b0};
          state <= LOAD1_FETCH;
        end
        LOAD1_FETCH: begin
	  outbits[7:0] <= rom_bits;
          state <= LOAD2_SETUP;
        end
        LOAD2_SETUP: begin
          rom_addr <= {vmirror?~ycount:ycount, 1'b1};
          state <= LOAD2_FETCH;
        end
        LOAD2_FETCH: begin
          outbits[15:8] <= rom_bits;
          state <= WAIT_FOR_HSTART;
        end
        WAIT_FOR_HSTART: begin
          if (hstart) state <= DRAW;
        end
        DRAW: begin
          // mirror graphics left/right
          gfx <= outbits[hmirror ? ~xcount[3:0] : xcount[3:0]];
          xcount <= xcount + 1;
          if (xcount == 15) begin // pre-increment value
            ycount <= ycount + 1;
            if (ycount == 15) // pre-increment value
              state <= WAIT_FOR_VSTART; // done drawing sprite
            else
	      state <= WAIT_FOR_LOAD; // done drawing this scanline
          end
        end
      endcase
    end
  
endmodule

// converts 0..15 rotation value to bitmap index / mirror bits
module rotation_selector(rotation, bitmap_num, hmirror, vmirror);
  
  input [3:0] rotation;	   // angle (0..15)
  output [2:0] bitmap_num; // bitmap index (0..4)
  output hmirror, vmirror; // horiz & vert mirror bits
  
  always @(*)
    case (rotation[3:2])	// 4 quadrants
      0: begin			// 0..3 -> 0..3
        bitmap_num = {1'b0, rotation[1:0]};
        hmirror = 0;
        vmirror = 0;
      end
      1: begin			// 4..7 -> 4..1
        bitmap_num = -rotation[2:0];
        hmirror = 0;
        vmirror = 1;
      end
      2: begin			// 8-11 -> 0..3
        bitmap_num = {1'b0, rotation[1:0]};
        hmirror = 1;
        vmirror = 1;
      end
      3: begin			// 12-15 -> 4..1
        bitmap_num = -rotation[2:0];
        hmirror = 1;
        vmirror = 0;
      end
    endcase

endmodule

// tank controller module -- handles rendering and movement


//TODO: debouncing

module control_test_top(clk, reset, hsync, vsync, rgb, switches_p1);

  input clk;
  input reset;
  output hsync;
  output vsync;
  output [2:0] rgb;
  input [7:0] switches_p1;
  
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;

  reg [7:0] paddle_x;
  reg [7:0] paddle_y;
  
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );
  
  wire [7:0] tank_sprite_addr;
  wire [7:0] tank_sprite_bits;
  
  tank_bitmap tank_bmp(
    .addr(tank_sprite_addr), 
    .bits(tank_sprite_bits));
  
  tank_controller tank1(
    .clk(clk),
    .reset(reset),
    .hpos(hpos),
    .vpos(vpos),
    .hsync(hsync),
    .vsync(vsync),
    .sprite_addr(tank_sprite_addr), 
    .sprite_bits(tank_sprite_bits),
    .gfx(tank1_gfx),
    .playfield(playfield_gfx),
    .switch_left(switches_p1[0]),
    .switch_right(switches_p1[1]),
    .switch_up(switches_p1[2])
  );
  
  wire tank1_gfx;
  wire playfield_gfx = hpos[5] && vpos[5];
  
  wire r = display_on && tank1_gfx;
  wire g = display_on && tank1_gfx;
  wire b = display_on && (tank1_gfx || playfield_gfx);
  assign rgb = {b,g,r};

endmodule

`endif
