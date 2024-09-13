lui x10,15
lui x11,10
lui x12,-15
lui x13,-10
lui x14,-10
bltu x11,x10,imm_1
imm_3:
lui x17,3
bgeu x13,x12,imm_4
imm_2:
lui x16,2
bgeu x13,x11,imm_3
imm_1:
lui x15,1
bltu x11,x12,imm_2
imm_4:
lui x18,4