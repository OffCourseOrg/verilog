`timescale 1ns/1ps

module bench(
  output armed,
  output alarm
);
  reg clk, reset, SCL;
  wire grab_SDA, decoder_drive, decoder_recv, start, stop, edge_scl;
  wire [7:0] ref_state;

  wire SDA;       // bidirectional signal from DUT
  reg SDA_drive;  // locally driven value
  wire SDA_recv;  // locally received value (optional, but models typical pad)

  reg [8*19:0] debug;

  assign SDA = !grab_SDA ? SDA_drive : 1'bz;
  assign SDA_recv = SDA;

  decoder decoder(
    .clk(clk),
    .SCL(SCL),
    .SDA(SDA),
    .grab_SDA(grab_SDA),
    .SDA_drive(decoder_drive),
    .SDA_recv(decoder_recv),
    .start(start),
    .stop(stop),
    .edge_scl(edge_scl)
  );

  REF REF(
    .clk(clk),
    .reset(reset),
    .SCL(SCL),
    .SDA_recv(decoder_recv),
    .start(start),
    .stop(stop),
    .edge_scl(edge_scl),
    .grab_SDA(grab_SDA),
    .SDA_drive(decoder_drive),
    .state_ref(ref_state)
  );

  task STOP;
    begin
      SCL = 0;
      #2;
      SDA_drive = 0;
      #2;
      SCL = 1;
      #2
      SDA_drive = 1;
      #2;
    end
  endtask

  task START;
    begin
      SCL = 1;
      #2;
      SDA_drive = 0;
      #2
      SCL = 0;
      #2;
    end
  endtask

  task SBIT;
    input reg bit;
    begin
      SCL = 0;
      #2;
      SDA_drive = bit;
      #2;
      SCL = 1;
      #2;
      SCL = 0;
      #2;
      SDA_drive = 1;
    end
  endtask

  task SADDR;
    input reg [6:0] ADDR;
    begin
      SBIT(ADDR[6]);
      SBIT(ADDR[5]);
      SBIT(ADDR[4]);
      SBIT(ADDR[3]);
      SBIT(ADDR[2]);
      SBIT(ADDR[1]);
      SBIT(ADDR[0]);
    end
  endtask

  task SBYTE;
    input reg [7:0] BYTE;
    begin
      SBIT(BYTE[7]);
      SBIT(BYTE[6]);
      SBIT(BYTE[5]);
      SBIT(BYTE[4]);
      SBIT(BYTE[3]);
      SBIT(BYTE[2]);
      SBIT(BYTE[1]);
      SBIT(BYTE[0]);
    end
  endtask
  task RBYTE;
    output reg [7:0] BYTE;
    begin
      RBIT(BYTE[7]);
      RBIT(BYTE[6]);
      RBIT(BYTE[5]);
      RBIT(BYTE[4]);
      RBIT(BYTE[3]);
      RBIT(BYTE[2]);
      RBIT(BYTE[1]);
      RBIT(BYTE[0]);
    end
  endtask

  task RBIT;
    output reg bit;
    begin
      SCL = 0;
      #4;
      SCL = 1;
      bit = SDA;
      #2;
      SCL = 0;
      #2;
    end
  endtask

  always begin
    //Clock
    #0.5 clk = ~clk;
  end

  reg rbit;
  reg [7:0] rbyte;
  initial begin
    clk = 1;
    SCL = 1;
    reset = 1;
    SDA_drive = 1;
    debug = "";
    rbyte = 0;
    rbit = 0;

    //GTKwave
    $dumpfile("trace.vcd");
    $dumpvars(0,debug);
    $dumpvars(0,decoder);
    $dumpvars(0, REF.clk, REF.reset, REF.SCL, REF.SDA_recv, REF.start, REF.stop, REF.grab_SDA, REF.SDA_drive, REF.state_ref, REF.state_next, REF.edge_scl, REF.memory);

    #2
    reset=0;

    //Write to memory
    debug = "START";
    START();
    debug = "ADDRESS";
    SADDR(69);
    debug = "W";
    SBIT(0); //write
    debug = "ACK";
    RBIT(rbit); //ACK
    $display("ACK/NACK? => %s", rbit ? "NACK" : "ACK");
    debug = "BYTE";
    $display("Writing Byte => %b", 8'b00110011);
    SBYTE(8'b00110011);
    debug = "ACK";
    RBIT(rbit); //ACK
    $display("ACK/NACK? => %s", rbit ? "NACK" : "ACK");
    debug = "STOP";
    STOP();
    debug = "";

    //Read from memory
    debug = "START";
    START();
    debug = "ADDRESS";
    SADDR(69);
    debug = "R";
    SBIT(1); //read
    debug = "ACK";
    RBIT(rbit); //ACK
    $display("ACK/NACK? => %s", rbit ? "NACK" : "ACK");
    debug = "BYTE";
    RBYTE(rbyte);
    $display("byte => %b", rbyte);
    debug = "ACK";
    SBIT(0); //ACK
    $display("Sending ACK");
    debug = "STOP";
    STOP();
    debug = "";

    #10;

    $finish;
  end
endmodule