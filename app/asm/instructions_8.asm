lui x10,15
lui x11,10
lui x12,-15
lui x13,-10
lui x14,-10
beq x13,x14,imm_1
imm_3:
lui x17,100
bge x11,x13,imm_4
imm_2:
lui x16,100
blt x12,x13,imm_3
imm_1:
lui x15,100
bne x10,x11,imm_2
imm_4:
lui x18,100