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
  'eql': 14,
  'str': 1
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

# LUT for various used values
LOOK_UP_TABLE = {
  '0': 0,
  '1': 1,
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
  '10': 10,
  '11': 11,
  '12': 12,
  '13': 13,
  '14': 14,
  '15': 15
}

# Label table storing line number
LABEL_TABLE = {}

def intToBinary(i):
  return "{0:b}".format(i).zfill(9)

if __name__ == '__main__':
  args = sys.argv
  if len(args) != 3:
    print("Usage: python3 assembler.py <input_file> <output_file>")
    sys.exit(0)

  # Get labels and check ISA instructions to make sure it is correct
  with open(args[1], 'r') as input_file:

    lineCount = 0
    
    lines = input_file.readlines()
    for line in lines:
      # Skip comments and blank lines
      if line.startswith('#') or line == "\n":
        continue

      line = line.rstrip()

      # Label
      if line.count(':') > 0:
        label = line[:line.index(':')]
        LABEL_TABLE[label] = lineCount
      else:
        lineCount += 1
        op = line.split(" ")[0]
        if op not in OP_TABLE:
          print("Unknown instruction op: {}".format(op))
          sys.exit(0)
        if op not in ['halt', 'rst', 'bne', 'str']:
          reg = line.split(" ")[1]
          if reg not in REGISTER_TABLE:
            print("Unknown register reg: {}".format(reg))
            sys.exit(0)

  # Start writing out binary instructions
  with open(args[1], 'r') as input_file, open(args[2], 'w') as output_file:
    lines = input_file.readlines()
    for line in lines:
      # Skip comments and blank lines and labels
      if line.startswith('#') or line == "\n" or line.count(':') > 0:
        continue

      line = line.rstrip()

      op = line.split(" ")[0]
      if op in ['str']:
        continue
      reg = ''
      if len(line.split(" ")) > 1 and line.split(" ")[1] in REGISTER_TABLE:
        reg = line.split(" ")[1]
      if reg != '':
        print(intToBinary(OP_TABLE[op] << 4 | REGISTER_TABLE[reg]), op, reg)
      elif op == 'bne':
        print(intToBinary(OP_TABLE[op] << 4), op, line.split(" ")[1])
      else:
        print(intToBinary(OP_TABLE[op] << 4), op)