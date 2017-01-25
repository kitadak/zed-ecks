SRC_DIR 	:= src
TAPE_DIR 	:= tapes

ASM 		:= zasm
ASM_FLAGS	:= -l0
SOURCES		:= $(shell find $(SRC_DIR) -name '*.asm' -type 'f')
TAPES 		:= $(SOURCES:$(SRC_DIR)/%.asm=$(TAPE_DIR)/%.tap)

all: $(TAPES)

$(TAPE_DIR)/%.tap: $(SRC_DIR)/%.asm
	@mkdir -p $(dir $@)
	$(ASM) $(ASM_FLAGS) -i $< -o $@

clean:
	rm -rf $(TAPE_DIR)