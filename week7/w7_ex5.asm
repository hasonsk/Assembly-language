# Laboratory Exercise 7, Home Assignment elements 5
.data
    Message_max: .asciiz "Gia tri lon nhat la: "
    index: .asciiz ", tai vi tri: $s"
    Message_min: .asciiz "\nGia tri nho nhat la: "
.text
main:
    li $s0, 3      # s0 = 3
    li $s1, 1      # s1 = 1
    li $s2, 10     # s2 = 10
    li $s3, 7      # s3 = 7
    li $s4, -4     # s4 = -4
    li $s5, -5     # s5 = -5
    li $s6, 20     # s6 = 20
    li $s7, 23     # s7 = 23
push:
    sw     $fp, -4($sp)	# save frame pointer (1)
    addi   $fp, $sp, 0 	# new frame pointer point to the top (2)
    addi   $sp, $sp, -32
    sw     $s7, 28($sp)       # Save s7 on the stack
    sw     $s6, 24($sp)       # Save s6 on the stack
    sw     $s5, 20($sp)       # Save s5 on the stack
    sw     $s4, 16($sp)       # Save s4 on the stack
    sw     $s3, 12($sp)       # Save s3 on the stack
    sw     $s2, 8($sp)        # Save s2 on the stack
    sw     $s1, 4($sp)        # Save s1 on the stack
    sw     $s0, 0($sp)        # Save s0 on the stack
    # call procedure FIND_MIN_MAX 
    jal    FIND_MIN_MAX        
    nop
    addi   $sp, $sp, 0         # get return stack from FIND_MIN_MAX
    # Pop the return address and the largest and smallest values and their indexes from the stack
    lw     $s2, 0($sp)         # get index of max
    lw     $s3, 4($sp)         # get value of max
    lw     $s4, 8($sp)         # get index of min
    lw     $s5, 12($sp)        # get value of min
    addi   $sp, $sp, 16        # adjust stack pointer 
print:
    li     $v0, 4   
    la     $a0, Message_max
    syscall
    li     $v0, 1
    move   $a0, $s3
    syscall
    li     $v0, 4
    la     $a0, index
    syscall
    li     $v0, 1
    move   $a0, $s2
    syscall
    li     $v0, 4
    la     $a0, Message_min
    syscall
    li     $v0, 1
    move   $a0, $s5
    syscall
    li     $v0, 4
    la     $a0, index
    syscall
    li     $v0, 1
    move   $a0, $s4
    syscall
exit:
    li     $v0, 10     # exit
    syscall  
#----------------------------------------------------------------------
# Procedure FIND_MIN_MAX: find the largest, smallest and their positions in a list of 8 elements
# param[in]:  $sp value of the array of 8 elements
# return   $sp+0:  index of the largest element
#          $sp+4:  value of the largest element
#          $sp+8:  index of the smallest element
#          $sp+12: value of the smallest element
#----------------------------------------------------------------------
FIND_MIN_MAX:
    # Initialize largest and smallest to the first element of the list
    addi $s2, $zero, 0       # Initialize index of max to 0
    addi $s3, $zero, -9999   # Initialize largest to -9999
    addi $s4, $zero, 0       # Initialize index of min to 0
    addi $s5, $zero, 9999    # Initialize smallest to 9999
    addi $t1, $zero, 0       # current index
loop:
    lw   $t2, 0($sp)       # get value from stack'top to t2
check_max:
    slt  $t3, $s3, $t2      # t3 = (s1 < t2)
    beq  $t3, $0, check_min  # If s1 >= t2, jump to check_min
    move $s2, $t1           # Set s2 to index of max
    move $s3, $t2           # Set s3 to max
    j    next
check_min:
    slt  $t3, $t2, $s4     # t3 = (t2 < s4)
    beq  $t3, $zero, next  # If t2 >= s4, jump to next
    move $s4, $t1          # Set s4 to the index of the min
    move $s5, $t2          # Set s5 to min
next:
    addi $sp, $sp, 4       # adjust the stack pointer
    addi $t1, $t1, 1       # Increment index
    bne  $sp, $fp, loop    # If stack is not empty, go to loop
    # else return
return:
    # Return the results
    sw    $fp, -4($sp)        # save frame pointer 
    addi  $fp, $sp, 0 	       # new frame pointer point to the top 
    addi  $sp, $sp, -16       # adjust stack pointer 
    sw    $s5, 12($sp)        # push value of min to stack
    sw    $s4, 8($sp)         # push index of min to stack
    sw    $s3, 4($sp)         # push value of max to stack
    sw    $s2, 0($sp)         # save index of max to stack
    jr    $ra