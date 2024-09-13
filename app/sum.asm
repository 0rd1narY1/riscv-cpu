main:
	li a0,0x64
	addi a2,x0,1
	add a3,x0,x0
loop:
	add a3,a3,a2
	beq a2,a0,finish
	addi a2,a2,1
	jal x0,loop
finish:
	sw a3,8(x0)
end:
	jal x0,end
