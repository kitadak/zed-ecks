SRC_DIR 	:= src
OTHER_DIRS	:= assets/sprites
BIN_DIR 	:= bin
DEMO_NAME	:= hovav_god
TMP_FILENAME	:= $(BIN_DIR)/assembleme

MAIN_SRC	:= $(shell find $(SRC_DIR) -name 'main.asm' -type 'f')
SOURCES		:= $(shell find $(SRC_DIR) $(OTHER_DIRS) -iname '*.asm' -type 'f')

TEMPLATE_HEAD	:= tests/zasm_header.asm
TEMPLATE_FOOT	:= tests/zasm_footer.asm

ASM 		:= zasm
ASM_FLAGS	:= -l0

$(BIN_DIR)/$(DEMO_NAME).tap: $(MAIN_SRC) $(SOURCES)
	mkdir -p $(dir $@)
	cat $(TEMPLATE_HEAD) $^ $(TEMPLATE_FOOT) > $(TMP_FILENAME)
	$(ASM) $(ASM_FLAGS) -i $(TMP_FILENAME) -o $@

clean:
	rm -rf $(BIN_DIR)
