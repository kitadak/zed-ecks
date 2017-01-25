SRC_DIR 	:= src
TAPE_DIR 	:= tapes
TMP_FILENAME	:= tmp
TEMPLATE_HEAD	:= zasm_header.asm
TEMPLATE_FOOT	:= zasm_footer.asm

ASM 		:= zasm
ASM_FLAGS	:= -l0
SOURCES		:= $(shell find $(SRC_DIR) -name '*.asm' -type 'f')
TAPES 		:= $(SOURCES:$(SRC_DIR)/%.asm=$(TAPE_DIR)/%.tap)

all: $(TAPES)

$(TAPE_DIR)/%.tap: $(SRC_DIR)/%.asm
	@mkdir -p $(dir $@)
	@cat $(TEMPLATE_HEAD) $< $(TEMPLATE_FOOT) > $(TMP_FILENAME)
	$(ASM) $(ASM_FLAGS) -i $(TMP_FILENAME) -o $@
	@rm $(TMP_FILENAME)

clean:
	rm -rf $(TAPE_DIR)
