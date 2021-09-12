# should be defined:
# "SOURCES"
VERILOGCC?=iverilog
SIM?=vvp
FLAGS?=-Wall -Winfloop
TARGET?=target
VCD_FILENAME?=test.vcd


test: $(TARGET)
	$(SIM) $(TARGET)

# Binary depends on the object file
$(TARGET):$(SOURCES)
	$(VERILOGCC)  $(FLAGS) -o $(TARGET) $(SOURCES)


clean:
	echo "Cleaning up..."
	rm -f *.o *_testbench $(TARGET) work*.cf e*.lst *.vcd
view:
	gtkwave $(VCD_FILENAME)

all:$(TARGET)
