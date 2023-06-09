.eqv KEY_CODE 0xFFFF0004 	# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 	# =1 if has a new keycode ?	
				# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C	# ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 	# =1 if the display has already to do
				# Auto clear after sw

.data
TEXT: .word 10000

.text
li $k0, KEY_CODE
li $k1, KEY_READY
li $s0, DISPLAY_CODE
li $s1, DISPLAY_READY

la $t3, TEXT # Current address of the last letter in a 4-letter sequence (exit)
addi $t3, $t3, 12

loop: nop

WaitForKey: 
	lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
	nop
	beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
	nop
#-----------------------------------------------------
ReadKey: 
	lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
	nop
#-----------------------------------------------------
StoreKey:
	addi $t3, $t3, 4
	sw $t0, 0($t3)
#-----------------------------------------------------
WaitForDis: 
	lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
	nop
	beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling
	nop
#-----------------------------------------------------
Encrypt: 
	addi $t0, $t0, 1 # change input key
#-----------------------------------------------------
ShowKey: 
	sw $t0, 0($s0) # show key
	nop
#-----------------------------------------------------

Check_for_exit:
	lw $t4, -12($t3) # Load the first character in the 4 character sequences
	bne $t4, 101, loop # check for letter e
	nop
	lw $t4, -8($t3)
	bne $t4, 120, loop # check for letter x
	nop
	lw $t4, -4($t3)
	bne $t4, 105, loop # check for letter i
	nop
	lw $t4, 0($t3)
	bne $t4, 116, loop # check for letter t
	nop
end_check:
end:
        li $v0, 10
        syscall

