.data
    result: .asciiz "The number of common characters is "
    str1: .asciiz "aaabcccd"
    str2: .asciiz "abcdaxy"
    str_copy: .space 100

.text
main:
    la $a0, str1               # Load str1 address
    la $a1, str2               # Load str2 address
    jal commonCharacterCount   # Call commonCharacterCount 
    nop
    move $a2, $v0              # Save the result to a2

    li $v0, 56                 # Print result on screen
    la $a0, result             # print: "The number of common characters is "
    move  $a1, $a2
    syscall                 
    
    li $v0, 10               # Exit 
    syscall                 

# Function to count common characters
#----------------------------------------------------------
# @brief      
# @param[in]  
#             
# @param[in]  
# @return $v0   
#-----------------------------------------------------------
commonCharacterCount:
    move $t9, $ra            # Save address return
    jal  strcpy              # copy str2 into str_copy
    nop
    move $ra, $t9            # load address return

    li $t0, 0                # count = 0
    move $s0, $a0            # s0 point to head of str1
    li $t1, 0                # i = 0
outerLoop:
    lb   $t2, 0($s0)         # Load str1[i] into t2
    beqz $t2, exitOuterLoop  # If s1[i] is null, exit outer loop
    
    add  $s1, $a2, $zero     # s1 point to head of str_copy
    li   $t3, 0              # j = 0
innerLoop:
    lb   $t4, 0($s1)         # Load str_copy[j] into t4
    beqz $t4, exitInnerLoop  # If str_copy[j] is null, exit inner loop
    beq $t2, $t4, foundMatch # If str1[i] == str_copy[j], go to foundMatch

    addi $t3, $t3, 1         # j++
    add $s1, $a2, $t3        # $s0 point to str_copy[j+1]
    j innerLoop              # continue to innerLoop

foundMatch:
    addi $t0, $t0, 1         # count++ 
    li  $t7, ' '             # visited
    sb $t7, 0($s1)           # Set s2[j] to space character (' ')
                             # Exit inner loop
exitInnerLoop:
    addi $t1, $t1, 1         # i++
    add  $s0, $a0, $t1       # $s0 point to next A[i]: A[i+1]
    j    outerLoop           # continue to outerLoop

exitOuterLoop:
    move $v0, $t0            # Return count
    jr   $ra                 # Return to the main


strcpy: 
      li  $s0, 0                  # s0 = i = 0
      la  $a1, str2               # a1 is address of str2
      la  $a2, str_copy           # a2 is address of str_copy
L1:
      add $t1, $a1, $s0           # t1 = str2[0] + i
                                  #    = address of str2[i]
      lb  $t2,0($t1)              # t2 = value at t1 = str2[i]
      add $t3, $a2, $s0           # t3 = str_copy[0] + i 
                                  #    = address of str_copy[i]
      sb  $t2,0($t3)              # str_copy[i] = t2 = str2[i]
      beq $t2,$zero,end_of_strcpy # if str2[i] == 0, exit
      addi $s0,$s0,1              # i = i+1
      j   L1                      # next character
      nop
end_of_strcpy:
      jr    $ra