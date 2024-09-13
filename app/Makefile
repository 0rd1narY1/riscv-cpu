CC 		= riscv64-linux-gnu-gcc 
CC_OBJ 	= riscv64-linux-gnu-objdump
CFLAGS 	= -march=rv32i -mabi=ilp32 
SRC 	= $(wildcard ./test/*.c)
TARGETS = $(patsubst ./test/%.c, ./asm/%.asm, $(SRC))
OBJ = $(patsubst ./test/%.c, ./obj/%.o, $(SRC))
BIN = $(patsubst ./test/%.c, ./bin/%.bin, $(SRC))
TXT = $(patsubst ./test/%.c, ./txt/%.txt, $(SRC))

all: $(OBJ) $(TARGETS) $(BIN) $(TXT)

$(OBJ):./obj/%.o:./test/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGETS):./asm/%.asm:./test/%.c
	$(CC) $(CFLAGS) -S $< -o $@

$(BIN):./bin/%.bin:./obj/%.o
	$(CC_OBJ) -d $^ > $@

$(TXT):./txt/%.txt:./bin/%.bin
	awk 'NR>7{print}' $^ | awk '{print $$2}' > $@

clean:
	rm asm/* txt/* obj/* bin/*
