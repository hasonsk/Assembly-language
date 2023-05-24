.data
    A: .word -1, 150, 190, 170, -1, -1, 160, 180, 155, 170
    Aend: .word                                  # mark end of A
    space: .asciiz ", "
    Result: .asciiz "sortByHeight(a) = ["
    end_Res: .asciiz "]."

.text
.globl main
main:
    la  $a0, A            # Load the address of array A into $a0
    la  $a1, Aend         # Load the address of array A into $a1
    
    jal sortByHeight      # Jump and link to the SeclectionSort function
    nop
    
    jal PRINT_ARRAY       # Jump and link to the PrintArray function
    nop
    
    li $v0, 10            # Exit program
    syscall

# sortByHeight function
#----------------------------------------------------------
# @brief      rearrange the people by their heights in a non-descending order without moving the trees
# @param[in]  
#             
# @param[in]  
# @return $v0   
#-----------------------------------------------------------
# pointer indexMin: $s0
# address of A[i]: $s1
# address of A[j]: $s2


sortByHeight:
    add  $s0, $a0, $zero      # pointer indexMin
    add  $s1, $a0, $zero      # address of A[i]
    add  $s2, $a0, $zero      # address of A[j]

loop_outer:
    beq  $s1, $a1, done       # check A[i] == Aend if true jummp to label done
    lw   $t0, 0($s1)          # Load value of A[i] into $t0
    
    bltz $t0, continue_outer  # If A[i] < 0, skip to the next iteration
    add  $s0, $s1, $zero      # Set indexMin to address of i
    addi $s2, $s1, 4          # A[j] = A[i+1]

loop_inner:
    beq  $s2, $a1, end_inner  # check A[j] == Aend, if true jump to end_inner
    lw   $t3, 0($s2)          # Load value of A[j] into $t3
    bltz $t3, continue_inner  # If value of A[j] < 0, skip to the next iteration
    lw   $t7, 0($s0)          # value of indexMin
    slt  $t4, $t3, $t7        # Compare value A[j] < indexMin
    beqz $t4, continue_inner  # If A[j] >= indexMin, skip to the next iteration
    move $s0, $s2             # else indexMin = A[j]
continue_inner:
    addi $s2, $s2, 4          # point to A[j+1]
    j   loop_inner       
end_inner:  
    beq $s1, $s0, continue_outer # if A[i] == indexMin, jump to continue_outer, else swap(A[i], indexMin)

swap:   lw $t8, 0($s1)        # $t8 = value at A[i] 
        lw $t9, 0($s0)        # $t9 = value at indexMin
        sw $t8, 0($s0)        # save $t8 into indexMin
        sw $t9, 0($s1)        # save $t9 into A[i]
    
continue_outer:
    addi $s1, $s1, 4          # Increment the address to A[i+1]
    j    loop_outer
done:                         # travesal all elements
    jr   $ra                  # Return to the calling function


#----------------------------------------------------------
# @brief      print out the sorted order
# @param[in]  array A
# @param[in]  end of A: Aend
# @return     
#-----------------------------------------------------------
# PrintArray function
PRINT_ARRAY:
    move $s0, $a0                 # $s0: point to head of array A
    move $s1, $a1                 # $s1: point to Aend

    li   $v0, 4                   #  printing a string
    la   $a0, Result               
    syscall                       
loop_print:
    beq  $s0, $s1, end_loop_print # Continue the loop if A[i] !- Aend
    lw   $t0, 0($s0)              # Load A[i] into $t0
    
    li   $v0, 1                   # Print A[i]
    move $a0, $t0            
    syscall                 

    addi $s0, $s0, 4              # point to A[i+1]
    beq  $s0, $s1, end_loop_print # check A[i] is Aend, if not true continue loop

    li   $v0, 4                   # Print a space
    la   $a0, space               
    syscall                        
    j     loop_print

end_loop_print:
    li   $v0, 4                   # Print a end_Res
    la   $a0, end_Res               
    syscall                     
    jr    $ra                     # Return to the calling function


