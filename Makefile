# Written according to this guide:
# https://makefiletutorial.com/
# also i used this one:
# https://www.gnu.org/software/make/manual/html_node/Text-Functions.html

NAME := genericName

SRCS_DIR := Src
INCS_DIR := Inc
BUILD_DIR := Build
LINKER := LinkerScript.ld

C_SRCS := $(wildcard $(SRCS_DIR)/*.c)
S_SRCS := $(wildcard $(SRCS_DIR)/*.s)

OBJ := $(patsubst $(SRCS_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRCS))
OBJ += $(patsubst $(SRCS_DIR)/%.s, $(BUILD_DIR)/%.o, $(S_SRCS))

DEPS := $(OBJ:.o=.d)

INC_FLAGS := -I$(INCS_DIR)

CPU_FLAGS := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard	-mlittle-endian 

GCC_FLAGS := -fdata-sections -ffunction-sections -O0 -g3 -Wall -Wextra -std=gnu2x -DSTM32F411xE -MMD -MP #added MMD and MP to 
#generate dependency files for each source file

CFLAGS := $(CPU_FLAGS) $(GCC_FLAGS) $(INC_FLAGS)

LINKER_FLAGS := $(CPU_FLAGS) -T	$(LINKER) -Wl,--gc-sections --specs=nano.specs 

.DELETE_ON_ERROR:
.PHONY: all clean flash

all: $(BUILD_DIR)/$(NAME).bin
$(BUILD_DIR)/$(NAME).elf: $(OBJ)
	arm-none-eabi-gcc $(OBJ) $(LINKER_FLAGS) -o $@
	arm-none-eabi-size $@

$(BUILD_DIR)/$(NAME).bin: $(BUILD_DIR)/$(NAME).elf
	arm-none-eabi-objcopy -O binary $< $@

$(BUILD_DIR)/%.o: $(SRCS_DIR)/%.c
	@mkdir -p $(dir $@)
	arm-none-eabi-gcc -c $(CFLAGS) $< -o $@ 

$(BUILD_DIR)/%.o: $(SRCS_DIR)/%.s
	@mkdir -p $(dir $@)
	arm-none-eabi-gcc -c $(CFLAGS) $< -o $@ 

flash: $(BUILD_DIR)/$(NAME).bin
	dfu-util -a 0 -s 0x08000000:leave -D $(BUILD_DIR)/$(NAME).bin

clean:
	@echo "Yeetus deletus"
	@rm -rf $(BUILD_DIR)

-include $(DEPS)




