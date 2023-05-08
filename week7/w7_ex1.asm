#Laboratory Exercise 7 Home Assignment 1
.data 
    mInput:  .asciiz   "Nhap mot so nguyen: "
    Message: .asciiz   "Ket qua la:  "

.text
main:
    li  $v0, 4          # Print the request to enter the number from stdin
    la  $a0, mInput     
    syscall
    li   $v0, 5         # Read the value from stdin and store it in $v0
    syscall 
    move  $a0, $v0      # assign value from $v0 to $a0
    jal   abs           # jump and link to abs procedure
    nop
    add   $s0, $zero, $v0  # s0 stores the return result of abs function
    
    li    $v0, 56      # Print the program results to the screen
    la    $a0, Message
    move  $a1, $s0     # the interger to be printed is result
    syscall 

    li  $v0, 10        # terminate  
    syscall 
endmain:
#--------------------------------------------------------------------
# function abs  
# param[in]    $a1     the interger need to be gained the absolute value        
# return       $v0     absolute value
#--------------------------------------------------------------------
abs:
    sub  $v0, $zero, $a0   # put -(a0) in v0; in case (a0)<0
    bltz $a0, done         # if (a0)<0 then donenop
    add  $v0, $a0, $zero   # else put (a0) in v0
done:
    jr $ra
