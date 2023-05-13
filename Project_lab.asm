# Laboratory Exercise 7, Home Assignment 4
.data
        msg1: .asciiz   "Nhap vao xau thu nhat: "
        msg2: .asciiz   "Nhap vao xau thu hai: "
        str1: .space    50
        str2: .space    50
        msgLength: .asciiz    "Do dai cua xau la: "
        Message: .asciiz "So phan tu chung cua hai xau la: "
.text
main: 
input:
 li $v0, 54
 la $a0, msg1
 la $a1, str1
 la $a2, 100
 syscall 
 li $v0, 54
 la $a0, msg2
 la $a1, str2
 la $a2, 100
 syscall 
 
 
        la    $s0, str1
        move  $t9, $s0
        jal   LENGTH
        nop 
        
        la    $s1, str2
        move  $t9, $s1
        jal   LENGTH
        nop
        
        li    $a0, 5   # length of str1
        li    $a1, 5   # length of str2
        jal     WARP
		print:  add $a1, $v0, $zero # $a0 = result from N!
		li      $v0, 56
		la      $a0, Message
		syscall
quit: 
        li $v0, 10 					# terminate
	syscall
endmain:

#----------------------------------------------------------------------
# Procedure LENGTH: assign value and call FACT
#----------------------------------------------------------------------
LENGTH:
get_length: # la   $a0, string          # a0 = Address(string[0])
             xor  $v0, $zero, $zero    # v0 = length = 0
             xor  $t0, $zero, $zero    # t0 = i = 0
check_char:  add  $t1, $t9, $t0        # t1 = a0 + t0 
                                       #    = Address(string[0]+i) 
             lb   $t2, 0($t1)          # t2 = string[i]
             beq  $t2, $zero, end_of_str # Is null char?
             addi $v0, $v0, 1          # v0=v0+1->length=length+1
             addi $t0, $t0, 1          # t0=t0+1->i = i + 1
             j    check_char
end_of_str:                
            move $t0, $v0         
end_of_get_length:

print_length:# TODO
             addi   $t0, $t0, -1     # length = length -1
             li    $v0, 56           # in ra man hình 
             la    $a0, msgLength     
             move  $a1, $t0
             syscall            # execute
             jr    $ra



#----------------------------------------------------------------------
# Procedure WARP: assign value and call FACT
#----------------------------------------------------------------------
WARP:   
	sw    $fp, -4($sp) 		# save frame pointer (1)
	addi  $fp, $sp, 0 		# new frame pointer point to the top (2)
	addi  $sp, $sp, -8 		# adjust stack pointer (3)
	sw    $ra, 0($sp)    	# save return address (4)
	li    $a0, 5 	    	# load test input 
	li    $a1, 5
	jal   LCS          	# call fact procedure
	nop
	lw    $ra, 0($sp) 		# restore return address (5)
	addi  $sp, $fp, 0 	    # return stack pointer (6)
	lw    $fp, -4($sp) 		# return frame pointer (7)
	jr    $ra
wrap_end:
#----------------------------------------------------------------------
# Procedure FACT: compute N!
# param[in] $a0 integer N
# return 	$v0 the largest value
#----------------------------------------------------------------------
LCS: 
	sw    $fp, -4($sp)          # save frame pointer
	addi  $fp, $sp, 0 	        # new frame pointer point to stack’s top
	addi  $sp, $sp, -16         # allocate space for $fp,$ra,$a0 in	stack
	sw    $ra, 8($sp)           # save return address
	sw    $a0, 4($sp)           # save $a0 register
	sw    $a1, 0($sp)           # save $a1 register
	
	slti  $t0, $a0, 1           # if input argument N < 2
	bne   $t0, $zero, fail       # if it is false ((a0 = N) >=2)
	slti  $t1, $a1, 1           # if input argument N < 2
	beq   $t1, $zero, check      # if it is false ((a0 = N) >=2)
	nop
fail:	li    $v0, 0 				# return the result N!=1
	j     done
	nop
	
check:
    add    $t2, $a0, $s0
    lb     $s2, -1($t2)
    
    add    $t3, $a1, $s1
    lb     $s3, -1($t3)
    
    bne    $s2, $s3, else
    addi   $a0, $a0, -1
    addi   $a1, $a1, -1
    jal    LCS
    addi   $v0, $v0, 1
    j      done
    
else:
        addi   $a0, $a0, -1
        jal    LCS
        nop
        add    $t8,  $zero, $v0
        addi   $a0, $a0, 1
        addi   $a1, $a1, -1
        jal    LCS
        nop
        add    $t9, $zero, $v0
        slt    $t7, $t8, $t9
        beq    $t7, $zero, rev
        move   $v0, $t9
        j      done
rev:
        move   $v0, $t8
        j      done
done: 
	lw     $ra,8($sp) 			 # restore return address
	lw     $a0,4($sp) 			 # restore a0
	lw     $a1,0($sp)
	addi   $sp,$fp,0 			 # restore stack pointer
	lw     $fp,-4($sp) 			 # restore frame pointer
	jr     $ra     				 # jump to calling
lcs_end:


