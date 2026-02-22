module RangeFinder
   #(parameter WIDTH=16)
    (input  logic [WIDTH-1:0] data_in,
     input  logic             clock, reset,
     input  logic             go, finish,
     output logic [WIDTH-1:0] range,
     output logic             error);

   enum logic [1:0] {START, EVAL, ERROR} state, nextState;

   logic [WIDTH-1:0] prevMax, prevMin, max, min;
   logic prevFinish, prevGo;
   
   // Output logic
   always_comb begin
      max = prevMax;
      min = prevMin;
      // If we receive a go signal, start keeping track of data_in
      if ((state == START || state == ERROR) && go && !finish) begin
         max = data_in;
         min = data_in;
      end
      // While evaluating, replace max/min with data_in if it is greater/lesser
      // than the current saved values
      else if (state == EVAL) begin
         if (data_in > prevMax) max = data_in;
         if (data_in < prevMin) min = data_in;
      end

      error = 1'b0;
      // Set an error flag while in the error state
      if (state == ERROR && !(go && !finish)) error = 1'b1;
      // Or if finish happens before go (in start state and a new finish signal appears)
      else if (state == START && !prevFinish && finish) error = 1'b1;
      // Or if go and finish are asserted at the same time
     else if (go && !prevGo && finish && !prevFinish) error = 1'b1;
      // Or if go happens a second time before finish
     else if (state == EVAL && go && !prevGo) error = 1'b1;

     range = max - min;
   end

   // Next state logic
   always_comb begin
      case (state)
      START: begin
         // Error if finish before go 
         if (!prevFinish && finish) nextState = ERROR;
         else if (go) nextState = EVAL;
         else nextState = START;
      end
      EVAL: begin
         // Go back to the start when done
        if (go && !prevGo) nextState = ERROR;
         else if (finish) nextState = START;
         else nextState = EVAL;
      end
      ERROR: begin
         // Exit error state on go & start evaluating
         if (go && !finish) nextState = EVAL;
         else nextState = ERROR;
      end
      default: nextState = START;
      endcase
   end

   // FF logic
   always_ff @(posedge clock, posedge reset) begin
      if (reset) begin
         state <= START;
         prevMax <= 'b0;
         prevMin <= 'b0;
         prevFinish <= 1'b0;
         prevGo <= 1'b0;
      end
      else if (clock) begin
         state <= nextState;
         prevMax <= max;
         prevMin <= min;
         prevFinish <= finish;
         prevGo <= go;
      end

   end

endmodule: RangeFinder