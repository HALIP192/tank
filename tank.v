
`include "hvsync_generator.v"

`include "sprite_rotation.v"
`include "sprite_rotation.v"


/*
Tank game.

minefield - Displays the minefield.
playfield - Displays the playfield maze.
tank_game_top - Runs the tank game, using two tank_controller
  modules.
*/



module playfield(hpos, vpos, playfield_gfx);
  
  input [8:0] hpos;
  input [8:0] vpos;
  output playfield_gfx;
  
  reg [31:0] maze [0:27];
  
  wire [4:0] x = hpos[7:3];
  wire [4:0] y = vpos[7:3] - 2;
  
  assign playfield_gfx = maze[y][x];
  
  initial begin/*{w:32,h:28,bpw:32}*/
    maze[0]  = 32'b00000000000000000000000000000000;
    maze[1]  = 32'b00000000000000000000000000000000;
    maze[2]  = 32'b00000000000000000000000000000000;
    maze[3]  = 32'b00000000000000000000000000000000;
    maze[4]  = 32'b00000000000000000000000000000000;
    maze[5]  = 32'b00000000000000000000000000000000;
    maze[6]  = 32'b00000000000000000000000000000000;
    maze[7]  = 32'b00000000000000000000000000000000;
    maze[8]  = 32'b00000000000000000000000000000000;
    maze[9]  = 32'b00000000000000000000000000000000;
    maze[10] = 32'b00000000000000000000000000000000;
    maze[11] = 32'b00000000000000000000000000000000;
    maze[12] = 32'b00000000000000000000000000000000;
    maze[13] = 32'b00000000000000000000000000000000;
    maze[14] = 32'b00000000000000000000000000000000;
    maze[15] = 32'b00000000000000000000000000000000;
    maze[16] = 32'b00000000000000000000000000000000;
    maze[17] = 32'b00000000000000000000000000000000;
    maze[18] = 32'b00000000000000000000000000000000;
    maze[19] = 32'b00000000000000000000000000000000;
    maze[20] = 32'b00000000000000000000000000000000;
    maze[21] = 32'b00000000000000000000000000000000;
    maze[22] = 32'b00000000000000000000000000000000;
    maze[23] = 32'b00000000000000000000000000000000;
    maze[24] = 32'b00000000000000000000000000000000;
    maze[25] = 32'b00000000000000000000000000000000;
    maze[26] = 32'b00000000000000000000000000000000;
    maze[27] = 32'b00000000000000000000000000000000;
  end
  
endmodule

module tank_game_top(clk, reset, hsync, vsync, rgb, switches_p1);

  input clk, reset;
  input [7:0] switches_p1;

  output hsync, vsync;
  output [2:0] rgb;
  
  
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;
  localparam applex=100;
  localparam appleY=100; 
  reg inX, inY;
  reg l = 'b0;
  reg ri = 'b1;
  reg u = 'b0;
  reg d = 'b0;
  reg [8:0] snake_hpos[0:29]; // ball current X position
  reg [8:0] snake_vpos[0:29]; // ball current Y position
  reg [26:0] flag ;
  reg [1:0]flag_gotit='b0;
  
  reg [8:0] snake_horiz_initial = 100;
  reg [8:0] snake_vert_initial = 40;
  localparam SNAKE_SIZE_HEIGHT = 8; 
  localparam APPLE_SIZE_HEIGHT = 8;
  
  //wire mine_gfx;		// minefield video
  wire playfield_gfx;		// playfield video
 
 
  reg [8:0] snake_hpos_buff; // ball current X position
  reg [8:0] snake_vpos_buff;
  reg [8:0]randX = 100 ;
  reg [8:0]randY = 100;
  reg [8:0] i=100;
  reg [8:0] j = 100;
  reg update_clk;
reg [21:0] check;

  always @(posedge vsync or posedge reset)
  begin
    if (reset || snake_hpos[0]<=8 || snake_hpos[0]>=248-SNAKE_SIZE_HEIGHT || snake_vpos[0]>=230-SNAKE_SIZE_HEIGHT || snake_vpos[0]<=24) begin
      // reset ball position to center
      
      snake_hpos[0] <= snake_horiz_initial;
      snake_vpos[0] <= snake_vert_initial;
      
      snake_hpos[1] <= snake_horiz_initial;
      snake_vpos[1] <= snake_vert_initial;
      
      snake_hpos[2] <= snake_horiz_initial;
      snake_vpos[2] <= snake_vert_initial;
      
      snake_hpos[3] <= snake_horiz_initial;
      snake_vpos[3] <= snake_vert_initial;
      
      snake_hpos[4] <= snake_horiz_initial;
      snake_vpos[4] <= snake_vert_initial;
      
      snake_hpos[5] <= snake_horiz_initial;
      snake_vpos[5] <= snake_vert_initial;
      
      snake_hpos[6] <= snake_horiz_initial;
      snake_vpos[6] <= snake_vert_initial;
      
      snake_hpos[7] <= snake_horiz_initial;
      snake_vpos[7] <= snake_vert_initial;
      
      snake_hpos[8] <= snake_horiz_initial;
      snake_vpos[8] <= snake_vert_initial;
      
      snake_hpos[9] <= snake_horiz_initial;
      snake_vpos[9] <= snake_vert_initial;
      
      snake_hpos[10] <= snake_horiz_initial;
      snake_vpos[10] <= snake_vert_initial;
      
      snake_hpos[11] <= snake_horiz_initial;
      snake_vpos[11] <= snake_vert_initial;
      
      snake_hpos[12] <= snake_horiz_initial;
      snake_vpos[13] <= snake_vert_initial;
      
      snake_hpos[14] <= snake_horiz_initial;
      snake_vpos[14] <= snake_vert_initial;
      
      snake_hpos[15] <= snake_horiz_initial;
      snake_vpos[15] <= snake_vert_initial;
      
      snake_hpos[16] <= snake_horiz_initial;
      snake_vpos[16] <= snake_vert_initial;
      
      snake_hpos[17] <= snake_horiz_initial;
      snake_vpos[17] <= snake_vert_initial;
      
      snake_hpos[18] <= snake_horiz_initial;
      snake_vpos[18] <= snake_vert_initial;
      
      snake_hpos[19] <= snake_horiz_initial;
      snake_vpos[19] <= snake_vert_initial;
      
      snake_hpos[20] <= snake_horiz_initial;
      snake_vpos[20] <= snake_vert_initial;
      
      snake_hpos[21] <= snake_horiz_initial;
      snake_vpos[21] <= snake_vert_initial;
      
      snake_hpos[22] <= snake_horiz_initial;
      snake_vpos[22] <= snake_vert_initial;
      
      snake_hpos[23] <= snake_horiz_initial;
      snake_vpos[23] <= snake_vert_initial;
      
      snake_hpos[24] <= snake_horiz_initial;
      snake_vpos[24] <= snake_vert_initial;
      
      snake_hpos[25] <= snake_horiz_initial;
      snake_vpos[25] <= snake_vert_initial;
      
      snake_hpos[26] <= snake_horiz_initial;
      snake_vpos[26] <= snake_vert_initial;
      
      snake_hpos[27] <= snake_horiz_initial;
      snake_vpos[27] <= snake_vert_initial;
      
      snake_hpos[28] <= snake_horiz_initial;
      snake_vpos[28] <= snake_vert_initial;
      
      snake_hpos[29] <= snake_horiz_initial;
      snake_vpos[29] <= snake_vert_initial;
      
     
    end else begin
      // add velocity vector to ball position
      if (switches_p1 == 'b0001)
        begin
       
          
          snake_hpos[29] <= snake_hpos[28];
          snake_vpos[29] <= snake_vpos[28];
           
          snake_hpos[28] <= snake_hpos[27];
          snake_vpos[28] <= snake_vpos[27];
          
          snake_hpos[27] <= snake_hpos[26];
          snake_vpos[27] <= snake_vpos[26];
           
          snake_hpos[26] <= snake_hpos[25];
          snake_vpos[26] <= snake_vpos[25];
          
          snake_hpos[25] <= snake_hpos[24];
          snake_vpos[25] <= snake_vpos[24];
           
          snake_hpos[24] <= snake_hpos[23];
          snake_vpos[24] <= snake_vpos[23];
          
          snake_hpos[23] <= snake_hpos[22];
          snake_vpos[23] <= snake_vpos[22];
           
          snake_hpos[22] <= snake_hpos[21];
          snake_vpos[22] <= snake_vpos[21];
          
          snake_hpos[21] <= snake_hpos[20];
          snake_vpos[21] <= snake_vpos[20];
           
          snake_hpos[20] <= snake_hpos[19];
          snake_vpos[20] <= snake_vpos[19];
          
          snake_hpos[19] <= snake_hpos[18];
          snake_vpos[19] <= snake_vpos[18];
           
          snake_hpos[18] <= snake_hpos[17];
          snake_vpos[18] <= snake_vpos[17];
          
          snake_hpos[17] <= snake_hpos[16];
          snake_vpos[17] <= snake_vpos[16];
           
          snake_hpos[16] <= snake_hpos[15];
          snake_vpos[16] <= snake_vpos[15];
          
          snake_hpos[15] <= snake_hpos[14];
          snake_vpos[15] <= snake_vpos[14];
          
          snake_hpos[14] <= snake_hpos[13];
          snake_vpos[14] <= snake_vpos[13];
           
          snake_hpos[13] <= snake_hpos[12];
          snake_vpos[13] <= snake_vpos[12];
          
          snake_hpos[12] <= snake_hpos[11];
          snake_vpos[12] <= snake_vpos[11];
           
          snake_hpos[11] <= snake_hpos[10];
          snake_vpos[11] <= snake_vpos[10];
          
          snake_hpos[10] <= snake_hpos[9];
          snake_vpos[10] <= snake_vpos[9];
           
          snake_hpos[9] <= snake_hpos[8];
          snake_vpos[9] <= snake_vpos[8];
          
          snake_hpos[8] <= snake_hpos[7];
          snake_vpos[8] <= snake_vpos[7];
           
          snake_hpos[7] <= snake_hpos[6];
          snake_vpos[7] <= snake_vpos[6];
          
          snake_hpos[6] <= snake_hpos[5];
          snake_vpos[6] <= snake_vpos[5];
           
          snake_hpos[5] <= snake_hpos[4];
          snake_vpos[5] <= snake_vpos[4];
          
          snake_hpos[4] <= snake_hpos[3];
          snake_vpos[4] <= snake_vpos[3];
           
          snake_hpos[3] <= snake_hpos[2];
          snake_vpos[3] <= snake_vpos[2];
          
          snake_hpos[2] <= snake_hpos[1];
          snake_vpos[2] <= snake_vpos[1];
           
          snake_hpos[1] <= snake_hpos[0];
          snake_vpos[1] <= snake_vpos[0];
          
          snake_hpos[0] <= snake_hpos[0]-3;
          snake_vpos[0] <= snake_vpos[0];
         
        end
      else if(switches_p1 == 'b10 )
        begin
          
          snake_hpos[29] <= snake_hpos[28];
          snake_vpos[29] <= snake_vpos[28];
           
          snake_hpos[28] <= snake_hpos[27];
          snake_vpos[28] <= snake_vpos[27];
          
          snake_hpos[27] <= snake_hpos[26];
          snake_vpos[27] <= snake_vpos[26];
           
          snake_hpos[26] <= snake_hpos[25];
          snake_vpos[26] <= snake_vpos[25];
          
          snake_hpos[25] <= snake_hpos[24];
          snake_vpos[25] <= snake_vpos[24];
           
          snake_hpos[24] <= snake_hpos[23];
          snake_vpos[24] <= snake_vpos[23];
          
          snake_hpos[23] <= snake_hpos[22];
          snake_vpos[23] <= snake_vpos[22];
           
          snake_hpos[22] <= snake_hpos[21];
          snake_vpos[22] <= snake_vpos[21];
          
          snake_hpos[21] <= snake_hpos[20];
          snake_vpos[21] <= snake_vpos[20];
           
          snake_hpos[20] <= snake_hpos[19];
          snake_vpos[20] <= snake_vpos[19];
          
          snake_hpos[19] <= snake_hpos[18];
          snake_vpos[19] <= snake_vpos[18];
           
          snake_hpos[18] <= snake_hpos[17];
          snake_vpos[18] <= snake_vpos[17];
          
          snake_hpos[17] <= snake_hpos[16];
          snake_vpos[17] <= snake_vpos[16];
           
          snake_hpos[16] <= snake_hpos[15];
          snake_vpos[16] <= snake_vpos[15];
          
          snake_hpos[15] <= snake_hpos[14];
          snake_vpos[15] <= snake_vpos[14];
          
          snake_hpos[14] <= snake_hpos[13];
          snake_vpos[14] <= snake_vpos[13];
           
          snake_hpos[13] <= snake_hpos[12];
          snake_vpos[13] <= snake_vpos[12];
          
          snake_hpos[12] <= snake_hpos[11];
          snake_vpos[12] <= snake_vpos[11];
           
          snake_hpos[11] <= snake_hpos[10];
          snake_vpos[11] <= snake_vpos[10];
          
          snake_hpos[10] <= snake_hpos[9];
          snake_vpos[10] <= snake_vpos[9];
           
          snake_hpos[9] <= snake_hpos[8];
          snake_vpos[9] <= snake_vpos[8];
          
          snake_hpos[8] <= snake_hpos[7];
          snake_vpos[8] <= snake_vpos[7];
           
          snake_hpos[7] <= snake_hpos[6];
          snake_vpos[7] <= snake_vpos[6];
          
          snake_hpos[6] <= snake_hpos[5];
          snake_vpos[6] <= snake_vpos[5];
           
          snake_hpos[5] <= snake_hpos[4];
          snake_vpos[5] <= snake_vpos[4];
          
          snake_hpos[4] <= snake_hpos[3];
          snake_vpos[4] <= snake_vpos[3];
           
          snake_hpos[3] <= snake_hpos[2];
          snake_vpos[3] <= snake_vpos[2];
          
          snake_hpos[2] <= snake_hpos[1];
          snake_vpos[2] <= snake_vpos[1];
           
          snake_hpos[1] <= snake_hpos[0];
          snake_vpos[1] <= snake_vpos[0];
          
          snake_hpos[0] <= snake_hpos[0]+3;
          snake_vpos[0] <= snake_vpos[0];
          
         
        end
      else if(switches_p1 == 'b1000)
        begin
          snake_hpos[29] <= snake_hpos[28];
          snake_vpos[29] <= snake_vpos[28];
           
          snake_hpos[28] <= snake_hpos[27];
          snake_vpos[28] <= snake_vpos[27];
          
          snake_hpos[27] <= snake_hpos[26];
          snake_vpos[27] <= snake_vpos[26];
           
          snake_hpos[26] <= snake_hpos[25];
          snake_vpos[26] <= snake_vpos[25];
          
          snake_hpos[25] <= snake_hpos[24];
          snake_vpos[25] <= snake_vpos[24];
           
          snake_hpos[24] <= snake_hpos[23];
          snake_vpos[24] <= snake_vpos[23];
          
          snake_hpos[23] <= snake_hpos[22];
          snake_vpos[23] <= snake_vpos[22];
           
          snake_hpos[22] <= snake_hpos[21];
          snake_vpos[22] <= snake_vpos[21];
          
          snake_hpos[21] <= snake_hpos[20];
          snake_vpos[21] <= snake_vpos[20];
           
          snake_hpos[20] <= snake_hpos[19];
          snake_vpos[20] <= snake_vpos[19];
          
          snake_hpos[19] <= snake_hpos[18];
          snake_vpos[19] <= snake_vpos[18];
           
          snake_hpos[18] <= snake_hpos[17];
          snake_vpos[18] <= snake_vpos[17];
          
          snake_hpos[17] <= snake_hpos[16];
          snake_vpos[17] <= snake_vpos[16];
           
          snake_hpos[16] <= snake_hpos[15];
          snake_vpos[16] <= snake_vpos[15];
          
          snake_hpos[15] <= snake_hpos[14];
          snake_vpos[15] <= snake_vpos[14];
          
          snake_hpos[14] <= snake_hpos[13];
          snake_vpos[14] <= snake_vpos[13];
           
          snake_hpos[13] <= snake_hpos[12];
          snake_vpos[13] <= snake_vpos[12];
          
          snake_hpos[12] <= snake_hpos[11];
          snake_vpos[12] <= snake_vpos[11];
           
          snake_hpos[11] <= snake_hpos[10];
          snake_vpos[11] <= snake_vpos[10];
          
          snake_hpos[10] <= snake_hpos[9];
          snake_vpos[10] <= snake_vpos[9];
           
          snake_hpos[9] <= snake_hpos[8];
          snake_vpos[9] <= snake_vpos[8];
          
          snake_hpos[8] <= snake_hpos[7];
          snake_vpos[8] <= snake_vpos[7];
           
          snake_hpos[7] <= snake_hpos[6];
          snake_vpos[7] <= snake_vpos[6];
          
          snake_hpos[6] <= snake_hpos[5];
          snake_vpos[6] <= snake_vpos[5];
           
          snake_hpos[5] <= snake_hpos[4];
          snake_vpos[5] <= snake_vpos[4];
          
          snake_hpos[4] <= snake_hpos[3];
          snake_vpos[4] <= snake_vpos[3];
           
          snake_hpos[3] <= snake_hpos[2];
          snake_vpos[3] <= snake_vpos[2];
          
          snake_hpos[2] <= snake_hpos[1];
          snake_vpos[2] <= snake_vpos[1];
           
          snake_hpos[1] <= snake_hpos[0];
          snake_vpos[1] <= snake_vpos[0];
          
          snake_hpos[0] <= snake_hpos[0];
          snake_vpos[0] <= snake_vpos[0]+3;
          
        end
      else if(switches_p1 == 'b0100)
        begin
          snake_hpos[29] <= snake_hpos[28];
          snake_vpos[29] <= snake_vpos[28];
           
          snake_hpos[28] <= snake_hpos[27];
          snake_vpos[28] <= snake_vpos[27];
          
          snake_hpos[27] <= snake_hpos[26];
          snake_vpos[27] <= snake_vpos[26];
           
          snake_hpos[26] <= snake_hpos[25];
          snake_vpos[26] <= snake_vpos[25];
          
          snake_hpos[25] <= snake_hpos[24];
          snake_vpos[25] <= snake_vpos[24];
           
          snake_hpos[24] <= snake_hpos[23];
          snake_vpos[24] <= snake_vpos[23];
          
          snake_hpos[23] <= snake_hpos[22];
          snake_vpos[23] <= snake_vpos[22];
           
          snake_hpos[22] <= snake_hpos[21];
          snake_vpos[22] <= snake_vpos[21];
          
          snake_hpos[21] <= snake_hpos[20];
          snake_vpos[21] <= snake_vpos[20];
           
          snake_hpos[20] <= snake_hpos[19];
          snake_vpos[20] <= snake_vpos[19];
          
          snake_hpos[19] <= snake_hpos[18];
          snake_vpos[19] <= snake_vpos[18];
           
          snake_hpos[18] <= snake_hpos[17];
          snake_vpos[18] <= snake_vpos[17];
          
          snake_hpos[17] <= snake_hpos[16];
          snake_vpos[17] <= snake_vpos[16];
           
          snake_hpos[16] <= snake_hpos[15];
          snake_vpos[16] <= snake_vpos[15];
          
          snake_hpos[15] <= snake_hpos[14];
          snake_vpos[15] <= snake_vpos[14];
          
          snake_hpos[14] <= snake_hpos[13];
          snake_vpos[14] <= snake_vpos[13];
           
          snake_hpos[13] <= snake_hpos[12];
          snake_vpos[13] <= snake_vpos[12];
          
          snake_hpos[12] <= snake_hpos[11];
          snake_vpos[12] <= snake_vpos[11];
           
          snake_hpos[11] <= snake_hpos[10];
          snake_vpos[11] <= snake_vpos[10];
          
          snake_hpos[10] <= snake_hpos[9];
          snake_vpos[10] <= snake_vpos[9];
           
          snake_hpos[9] <= snake_hpos[8];
          snake_vpos[9] <= snake_vpos[8];
          
          snake_hpos[8] <= snake_hpos[7];
          snake_vpos[8] <= snake_vpos[7];
           
          snake_hpos[7] <= snake_hpos[6];
          snake_vpos[7] <= snake_vpos[6];
          
          snake_hpos[6] <= snake_hpos[5];
          snake_vpos[6] <= snake_vpos[5];
           
          snake_hpos[5] <= snake_hpos[4];
          snake_vpos[5] <= snake_vpos[4];
          
          snake_hpos[4] <= snake_hpos[3];
          snake_vpos[4] <= snake_vpos[3];
           
          snake_hpos[3] <= snake_hpos[2];
          snake_vpos[3] <= snake_vpos[2];
          
          snake_hpos[2] <= snake_hpos[1];
          snake_vpos[2] <= snake_vpos[1];
           
          snake_hpos[1] <= snake_hpos[0];
          snake_vpos[1] <= snake_vpos[0];
          
          snake_hpos[0] <= snake_hpos[0];
          snake_vpos[0] <= snake_vpos[0]-3;
          
        end
    end
  end
  
  always @(posedge clk)
  begin
    if(check < 4000000)
      begin
        check <= check + 1;
        update_clk <= 0;
      end
    else
      begin 
        check <= 0;
        update_clk <= 1;
      end
  end
  
  reg update_2_clk;
  reg [21:0] check_2;
always @(posedge clk)
  begin
    if(check_2 < 2000000)
      begin
        check_2 <= check_2 + 1;
        update_2_clk <= 0;
      end
    else
      begin 
        check_2 <= 0;
        update_2_clk <= 1;
      end
  end
  

  always @( posedge reset or posedge clk)
     begin
 
       if(reset || snake_hpos[0]<=8 || snake_hpos[0]>=248-SNAKE_SIZE_HEIGHT || snake_vpos[0]>=230-SNAKE_SIZE_HEIGHT || snake_vpos[0]<=24)
         flag <=0;
       else if( flag_gotit[0]||flag_gotit[1])
         flag <= {3'b111,flag[26:3]};
     end
  
always @(posedge flag_gotit[0] or posedge flag_gotit[1])
  begin

    if (i<=230-APPLE_SIZE_HEIGHT) 
      begin
      i <= i+30;
        if(i>200-APPLE_SIZE_HEIGHT)
          i <=i-150;
      end
  
  end
  always @(posedge flag_gotit[0] or posedge flag_gotit[1] )
  begin
    if (j<200-APPLE_SIZE_HEIGHT && j>=24-APPLE_SIZE_HEIGHT)
      begin
     j <= j + 40;
      end
        if(j>=200 - APPLE_SIZE_HEIGHT)
          j <= j-160;
      
  end
  
  always @(posedge clk) 
  begin
      begin
   	randX <= i;
   	randY <= j;
 
      end
  end
  
 
  
  wire [8:0] snakes[0:29];
  assign snakes[0][8:0] = vpos - snake_vpos[0] ;
  assign snakes[1][8:0] = vpos - snake_vpos[1] ;
  assign snakes[2][8:0] = vpos - snake_vpos[2] ;
  assign snakes[3][8:0] = vpos - snake_vpos[3] ;
  assign snakes[4][8:0] = vpos - snake_vpos[4] ;
  assign snakes[5][8:0] = vpos - snake_vpos[5] ;
  assign snakes[6][8:0] = vpos - snake_vpos[6] ;
  assign snakes[7][8:0] = vpos - snake_vpos[7] ;
  assign snakes[8][8:0] = vpos - snake_vpos[8] ;
  assign snakes[9][8:0] = vpos - snake_vpos[9] ;
  assign snakes[10][8:0] = vpos - snake_vpos[10] ;
  assign snakes[11][8:0] = vpos - snake_vpos[11] ;
  assign snakes[12][8:0] = vpos - snake_vpos[12] ;
  assign snakes[13][8:0] = vpos - snake_vpos[13] ;
  assign snakes[14][8:0] = vpos - snake_vpos[14] ;
  assign snakes[15][8:0] = vpos - snake_vpos[15] ;
  assign snakes[16][8:0] = vpos - snake_vpos[16] ;
  assign snakes[17][8:0] = vpos - snake_vpos[17] ;
  assign snakes[18][8:0] = vpos - snake_vpos[18] ;
  assign snakes[19][8:0] = vpos - snake_vpos[19] ;
  assign snakes[20][8:0] = vpos - snake_vpos[20] ;
  assign snakes[21][8:0] = vpos - snake_vpos[21] ;
  assign snakes[22][8:0] = vpos - snake_vpos[22] ;
  assign snakes[23][8:0] = vpos - snake_vpos[23] ;
  assign snakes[24][8:0] = vpos - snake_vpos[24] ;
  assign snakes[25][8:0] = vpos - snake_vpos[25] ;
  assign snakes[26][8:0] = vpos - snake_vpos[26] ;
  assign snakes[27][8:0] = vpos - snake_vpos[27] ;
  assign snakes[28][8:0] = vpos - snake_vpos[28] ;
  assign snakes[29][8:0] = vpos - snake_vpos[29] ;
 
  wire [8:0] snake_hdiff[0:29];
  assign snake_hdiff[0][8:0] = hpos - snake_hpos[0] ;
  assign snake_hdiff[1][8:0] = hpos - snake_hpos[1] ;
  assign snake_hdiff[2][8:0] = hpos - snake_hpos[2] ;
  assign snake_hdiff[3][8:0] = hpos - snake_hpos[3] ;
  assign snake_hdiff[4][8:0] = hpos - snake_hpos[4] ;
  assign snake_hdiff[5][8:0] = hpos - snake_hpos[5] ;
  assign snake_hdiff[6][8:0] = hpos - snake_hpos[6] ;
  assign snake_hdiff[7][8:0] = hpos - snake_hpos[7] ;
  assign snake_hdiff[8][8:0] = hpos - snake_hpos[8] ;
  assign snake_hdiff[9][8:0] = hpos - snake_hpos[9] ;
  assign snake_hdiff[10][8:0] = hpos - snake_hpos[10] ;
  assign snake_hdiff[11][8:0] = hpos - snake_hpos[11] ;
  assign snake_hdiff[12][8:0] = hpos - snake_hpos[12] ;
  assign snake_hdiff[13][8:0] = hpos - snake_hpos[13] ;
  assign snake_hdiff[14][8:0] = hpos - snake_hpos[14] ;
  assign snake_hdiff[15][8:0] = hpos - snake_hpos[15] ;
  assign snake_hdiff[16][8:0] = hpos - snake_hpos[16] ;
  assign snake_hdiff[17][8:0] = hpos - snake_hpos[17] ;
  assign snake_hdiff[18][8:0] = hpos - snake_hpos[18] ;
  assign snake_hdiff[19][8:0] = hpos - snake_hpos[19] ;
  assign snake_hdiff[20][8:0] = hpos - snake_hpos[20] ;
  assign snake_hdiff[21][8:0] = hpos - snake_hpos[21] ;
  assign snake_hdiff[22][8:0] = hpos - snake_hpos[22] ;
  assign snake_hdiff[23][8:0] = hpos - snake_hpos[23] ;
  assign snake_hdiff[24][8:0] = hpos - snake_hpos[24] ;
  assign snake_hdiff[25][8:0] = hpos - snake_hpos[25] ;
  assign snake_hdiff[26][8:0] = hpos - snake_hpos[26] ;
  assign snake_hdiff[27][8:0] = hpos - snake_hpos[27] ;
  assign snake_hdiff[28][8:0] = hpos - snake_hpos[28] ;
  assign snake_hdiff[29][8:0] = hpos - snake_hpos[29] ;
  
  wire [8:0] aple;
  assign aple[8:0] = vpos - randY ;
  wire [8:0] aple_hdiff;
  assign aple_hdiff[8:0] = hpos - randX ;
  
  
 
  
  
  wire [29:0] flag_one;
  always @(posedge clk)
    begin
	flag_one <= { (snake_hdiff[0] < SNAKE_SIZE_HEIGHT) && (snakes[0][8:0] < SNAKE_SIZE_HEIGHT ),
                          (snake_hdiff[1] < SNAKE_SIZE_HEIGHT) && (snakes[1][8:0] < SNAKE_SIZE_HEIGHT ) ,
                          (snake_hdiff[2] < SNAKE_SIZE_HEIGHT) && (snakes[2][8:0] < SNAKE_SIZE_HEIGHT ) ,
                          (snake_hdiff[3] < SNAKE_SIZE_HEIGHT) && (snakes[3][8:0] < SNAKE_SIZE_HEIGHT ) && flag[26] ,
                          (snake_hdiff[4] < SNAKE_SIZE_HEIGHT) && (snakes[4][8:0] < SNAKE_SIZE_HEIGHT ) && flag[25] ,
                          (snake_hdiff[5] < SNAKE_SIZE_HEIGHT) && (snakes[5][8:0] < SNAKE_SIZE_HEIGHT ) && flag[24] ,
                          (snake_hdiff[6] < SNAKE_SIZE_HEIGHT) && (snakes[6][8:0] < SNAKE_SIZE_HEIGHT ) && flag[23] ,
                          (snake_hdiff[7] < SNAKE_SIZE_HEIGHT) && (snakes[7][8:0] < SNAKE_SIZE_HEIGHT ) && flag[22] ,
                          (snake_hdiff[8] < SNAKE_SIZE_HEIGHT) && (snakes[8][8:0] < SNAKE_SIZE_HEIGHT ) && flag[21] ,
                          (snake_hdiff[9] < SNAKE_SIZE_HEIGHT) && (snakes[9][8:0] < SNAKE_SIZE_HEIGHT ) && flag[20] ,
                          (snake_hdiff[10] < SNAKE_SIZE_HEIGHT) && (snakes[10][8:0] < SNAKE_SIZE_HEIGHT )  && flag[19],
                          (snake_hdiff[11] < SNAKE_SIZE_HEIGHT) && (snakes[11][8:0] < SNAKE_SIZE_HEIGHT )  && flag[18],
                          (snake_hdiff[12] < SNAKE_SIZE_HEIGHT) && (snakes[12][8:0] < SNAKE_SIZE_HEIGHT )  && flag[17],
                          (snake_hdiff[13] < SNAKE_SIZE_HEIGHT) && (snakes[13][8:0] < SNAKE_SIZE_HEIGHT )  && flag[16],
                          (snake_hdiff[14] < SNAKE_SIZE_HEIGHT) && (snakes[14][8:0] < SNAKE_SIZE_HEIGHT )  && flag[15],
                          (snake_hdiff[15] < SNAKE_SIZE_HEIGHT) && (snakes[15][8:0] < SNAKE_SIZE_HEIGHT )  && flag[14],
                          (snake_hdiff[16] < SNAKE_SIZE_HEIGHT) && (snakes[16][8:0] < SNAKE_SIZE_HEIGHT )  && flag[13],
                          (snake_hdiff[17] < SNAKE_SIZE_HEIGHT) && (snakes[17][8:0] < SNAKE_SIZE_HEIGHT )  && flag[12],
                          (snake_hdiff[18] < SNAKE_SIZE_HEIGHT) && (snakes[18][8:0] < SNAKE_SIZE_HEIGHT )  && flag[11],
                          (snake_hdiff[19] < SNAKE_SIZE_HEIGHT) && (snakes[19][8:0] < SNAKE_SIZE_HEIGHT )  && flag[10],
                          (snake_hdiff[20] < SNAKE_SIZE_HEIGHT) && (snakes[20][8:0] < SNAKE_SIZE_HEIGHT )  && flag[9],
                          (snake_hdiff[21] < SNAKE_SIZE_HEIGHT) && (snakes[21][8:0] < SNAKE_SIZE_HEIGHT )  && flag[8],
                          (snake_hdiff[22] < SNAKE_SIZE_HEIGHT) && (snakes[22][8:0] < SNAKE_SIZE_HEIGHT )  && flag[7],
                          (snake_hdiff[23] < SNAKE_SIZE_HEIGHT) && (snakes[23][8:0] < SNAKE_SIZE_HEIGHT )  && flag[6],
                          (snake_hdiff[24] < SNAKE_SIZE_HEIGHT) && (snakes[24][8:0] < SNAKE_SIZE_HEIGHT )  && flag[5],
                          (snake_hdiff[25] < SNAKE_SIZE_HEIGHT) && (snakes[25][8:0] < SNAKE_SIZE_HEIGHT )  && flag[4],
                          (snake_hdiff[26] < SNAKE_SIZE_HEIGHT) && (snakes[26][8:0] < SNAKE_SIZE_HEIGHT )  && flag[3],
                          (snake_hdiff[27] < SNAKE_SIZE_HEIGHT) && (snakes[27][8:0] < SNAKE_SIZE_HEIGHT )  && flag[2],
                          (snake_hdiff[28] < SNAKE_SIZE_HEIGHT) && (snakes[28][8:0] < SNAKE_SIZE_HEIGHT )  && flag[1],
                          (snake_hdiff[29] < SNAKE_SIZE_HEIGHT) && (snakes[29][8:0] < SNAKE_SIZE_HEIGHT )  && flag[0]
                         };
  
    end
  wire apple_flag = aple_hdiff<APPLE_SIZE_HEIGHT && (aple<APPLE_SIZE_HEIGHT);
  
  

  // video sync generator  
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(0),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );
  
  //touch #(SNAKE_SIZE_HEIGHT, SNAKE_SIZE_HEIGHT) two_two
 // (.hpos_one(snake_hpos[0]), 
//.vpos_one(snake_vpos[0]), 
 //  .hpos_two(randX), 
  // .vpos_two(randY), 
 //  .flag(flag_gotit));
  
  collider col(
    .hpos1(snake_hpos[0]-SNAKE_SIZE_HEIGHT),
    .vpos1(snake_vpos[0]-SNAKE_SIZE_HEIGHT),
    .hpos2(randX-APPLE_SIZE_HEIGHT),
    .vpos2(randY-APPLE_SIZE_HEIGHT),
    .hor_collide(flag_gotit[0]),
    .ver_collide(flag_gotit[1]) 
  ) ;
  // minefield (video output -> mine_gfx)
  //minefield mine_gen(
  //  .hpos(hpos),
  //  .vpos(vpos),
  //  .mine_gfx(mine_gfx)
  //);

  // playfield (video output -> playfield_gfx)
  playfield playfield_gen(
    .hpos(hpos),
    .vpos(vpos),
    .playfield_gfx(playfield_gfx)
  );

  // multiplex player 1 and 2 load times during hsync
  wire p2sel = hpos > 280;
  
  // sprite ROM inputs for each player
 
 // wire [7:0] tank2_sprite_addr;
  
  // multiplex sprite ROM output
  wire [7:0] tank_sprite_bits;
  
  // bitmap ROM is shared between tank 1 and 2
  

  // player 1 tank controller  


  // player 2 tank controller
  //tank_controller #(220,190,12) tank2(
  //  .clk(clk),
  // .reset(reset),
 //   .hpos(hpos),
 //   .vpos(vpos),
 //   .hsync(hsync && p2sel),
 //   .vsync(vsync),
 //   .sprite_addr(tank2_sprite_addr), 
 //   .sprite_bits(tank_sprite_bits),
 //   .gfx(tank2_gfx),
 //   .playfield(playfield_gfx),
 //   .switch_left(switches_p2[0]),
 //   .switch_right(switches_p2[1]),
 //   .switch_up(switches_p2[2])
 // );

  // video signal mixer
  reg r;
  reg g; 
  reg b; 
  always @(posedge clk)
    begin
   r <= display_on && apple_flag!=0;//display_on && mine_gfx; //|| tank2_gfx);
   g <= display_on && (flag_one!=0) ;
   b <= display_on && (hpos<8 &&(vpos>23)&&(vpos<231) || hpos > 248 &&(vpos>23)&&(vpos<231) || vpos>230 && vpos<240 || vpos<24 && vpos>15);// || tank2_gfx);
  
    end
  assign rgb = {b,g,r};
endmodule
  

module touch(hpos_one, vpos_one, hpos_two, vpos_two, flag);
  parameter HEIGHT = 0;
  parameter LENGTH = 0;
  input [8:0] hpos_one;
  input [8:0] vpos_one;
  input [8:0] hpos_two;
  input [8:0] vpos_two;
  output [1:0] flag;
  assign flag[0] = ((hpos_one == hpos_two + LENGTH) || 
                     (hpos_one + LENGTH == hpos_two)) && 
                    ((vpos_two <= vpos_one && vpos_one <= vpos_two + HEIGHT) || 
                     (vpos_two <= vpos_one + HEIGHT && vpos_one + HEIGHT <= vpos_two + HEIGHT));
  assign flag[1] = (((vpos_one == vpos_two + HEIGHT) || 
                     (vpos_one + HEIGHT == vpos_two)) && 
                    (hpos_two <= hpos_one && hpos_one <= hpos_two + LENGTH));
endmodule
module collider(hpos1, hpos2, vpos1, vpos2, hor_collide, ver_collide);
        input    [8 : 0] hpos1;
        input    [8 : 0] hpos2;
        input    [8 : 0] vpos1;
        input    [8 : 0] vpos2;
        output    hor_collide;
        output    ver_collide;

        parameter hspeed = 6;
        parameter vspeed = 6;
        parameter BALL_VSIZE = 8;
        parameter BALL_HSIZE = 8;

        wire hor_collide_left = hpos1 + BALL_HSIZE >= hpos2 && hpos1 + BALL_HSIZE <= hpos2 + 2 * hspeed;
        wire hor_collide_righ = hpos1 <= hpos2 + BALL_HSIZE && hpos1 >= hpos2 + BALL_HSIZE - 2 * hspeed; 
        wire hor_collide_nsid = vpos1 >= vpos2 - BALL_VSIZE && vpos1 <= vpos2 + BALL_VSIZE;

        wire ver_collide_left = vpos1 + BALL_VSIZE >= vpos2 && vpos1 + BALL_VSIZE < vpos2 + 2 * vspeed;
        wire ver_collide_righ = vpos1 <= vpos2 + BALL_VSIZE && vpos1 >= vpos2 + BALL_VSIZE - 2 * vspeed; 
        wire ver_collide_nsid = hpos1 >= hpos2 - BALL_HSIZE && hpos1 <= hpos2 + BALL_HSIZE;

        assign hor_collide = (hor_collide_left || hor_collide_righ) && hor_collide_nsid;
        assign ver_collide = (ver_collide_left || ver_collide_righ) && ver_collide_nsid;

    endmodule