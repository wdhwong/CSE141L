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
  'lkup': 12,
  'lt': 13,
  'eql': 14,
  'not': 15,
  'bne': 1
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

# LUT for hardcoded numbers like 128, 16, etc
LOOK_UP_TABLE = {
  '0': 1,
  '1': 2,
  '2': 4,
  '3': 8,
  '4': 9,
  '5': 10,
  '6': 11,
  '7': 128,
  '8': 16,
  '9': 7,
  '10': 0,
  '11': 17,
  '12': 18,
  '13': -1,
  '14': 5,
  '15': 6
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

  print ("Printing cleaned up assembly")

  # Get labels and check ISA instructions to make sure it is correct
  with open(args[1], 'r') as input_file:

    lineCount = 0
    lineCountAsm = 0
    
    lines = input_file.readlines()
    for line in lines:
      lineCountAsm += 1
      # Skip comments and blank lines
      if line.startswith('#') or line == "\n":
        continue

      # Remove newline delimiter
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
          print(lineCountAsm)
          sys.exit(0)
        if op not in ['halt', 'rst', 'bne', 'lkup']:
          reg = line.split(" ")[1]
          if reg not in REGISTER_TABLE:
            print("Unknown register reg: {}".format(reg))
            print(lineCountAsm)
            sys.exit(0)

    print ("Label Table: {}".format(LABEL_TABLE))

  print ("Writing machine code")

  # Start writing out binary instructions
  with open(args[1], 'r') as input_file, open(args[2], 'w') as output_file:
    lines = input_file.readlines()
    for line in lines:
      # Skip comments and blank lines and labels
      if line.startswith('#') or line == "\n" or line.count(':') > 0:
        continue

      # Remove newline delimiter
      line = line.rstrip()

      op = line.split(" ")[0]
      reg = ''
      if len(line.split(" ")) > 1 and line.split(" ")[1] in REGISTER_TABLE:
        reg = line.split(" ")[1]
      if reg != '':
        print(intToBinary(OP_TABLE[op] << 4 | REGISTER_TABLE[reg]), op, reg)
        output_file.write(intToBinary(OP_TABLE[op] << 4 | REGISTER_TABLE[reg]))
      elif op == 'lkup':
        print(intToBinary(OP_TABLE[op] << 4 | int(line.split(" ")[1])), op, line.split(" ")[1])
        output_file.write(intToBinary(OP_TABLE[op] << 4 | int(line.split(" ")[1])))
      elif op == 'bne':
        print(intToBinary(OP_TABLE[op] << 8 | LABEL_TABLE[line.split(" ")[1]]), op, line.split(" ")[1])
        output_file.write(intToBinary(OP_TABLE[op] << 8 | LABEL_TABLE[line.split(" ")[1]]))
      else:
        print(intToBinary(OP_TABLE[op] << 4), op)
        output_file.write(intToBinary(OP_TABLE[op] << 4))
      output_file.write("\n")
