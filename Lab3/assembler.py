# Assembler for ISA to binary
import sys

# OP codes for our ISA
OP_TABLE = {
  'add': 0,
  'sub': 1,
  'load': 2,
  'store': 3,
  'mov': 4,
  'cpy': 5,
  'nand': 6,
  'or': 7,
  'sll': 8,
  'slr': 9,
  'rst': 10,
  'halt': 11,
  'bne': 12,
  'lt': 13,
  'eql': 14
}

# Registers for our CPU
REGISTER_TABLE = {
  '$r0': 0,
  '$r1': 1,
  '$r2': 2,
  '$r3': 3,
  '$r4': 4,
  '$r5': 5,
  '$r6': 6,
  '$r7': 7,
  '$r8': 8,
  '$r9': 9,
  '$r10': 10,
  '$r11': 11,
  '$r12': 12,
  '$r13': 13,
  '$r14': 14,
  '$r15': 15
}

# LUT
LOOK_UP_TABLE = {

}

# Label table storing line number
LABEL_TABLE = {}

if __name__ == '__main__':
  args = sys.argv
  if len(args) != 3:
    print("py assembler.py <input_file> <output_file>")
    sys.exit(0)

  print(args)