.data
    str_copy: .space 100
    fre:      .space 104
    str1:     .asciiz "aabcdef"
    str2:     .asciiz "acfaghe"
    # ----------------- IN RA MAN HINH ------------------------- #
    Msg1:     .asciiz "commonCharacterCount(s1, s2) = "
    Msg2:     .asciiz ". String have " 
    Msg3:     .asciiz " common charater"
    dash:     .asciiz " - "
    and_msg:  .asciiz " and "
.text
main:
    la $a0, str1               # Load str1 address
    la $a1, str2               # Load str2 address
    jal commonCharacterCount   # goi chuong trinh commonCharacterCount
    nop
    
    move $a2, $v0              # luu ket qua tra ve vao a2           
    la  $s0, fre
    li  $t0, 0       # i = 0
    li  $s1, 1       # const = 1
print:
    li $v0, 4                 # In ket qua len man hinh
    la $a0, Msg1             # "The number of common characters is "
    syscall      
    
    li  $v0, 1
    move $a0, $a2
    syscall
    # Msg2
    li $v0, 4                 # In ket qua len man hinh
    la $a0, Msg2              # ". String have " 
    syscall    
    
    li  $v0, 1
    move $a0, $a2
    syscall
    
    # Msg3
    li $v0, 4                 # In ket qua len man hinh
    la $a0, Msg3              # " common charater"
    syscall  
    
    slt $t8, $s1, $a2
    beqz $t8, label
    li  $v0, 11
    li  $a0, 's'
    syscall
    
label:
    li  $v0, 4               # in " - "
    la  $a0, dash
    syscall
loop:
    beq $t0, 26, end_loop
    sll $t1, $t0, 2   # 4i
    add $t2, $s0, $t1 # fre[i]
    lw  $t3, 0($t2)
    beqz $t3, continue_loop
    li  $v0, 1              # in fre[i]
    move $a0, $t3
    syscall
    
    li  $v0, 11             # in ' '
    li  $a0, ' '
    syscall
    
    li  $v0, 11
    li  $a0, '\"'           # in '\"'
    syscall
    
    add $t4, $t0, 'a'   
    li  $v0, 11             # in ky tu
    move $a0, $t4
    syscall
    
    li  $v0, 11
    li  $a0, '\"'           # in '\"'
    syscall
    
    beq $t0, $s4, end_loop
    beq $t3, $s1, print_and
    # in s
    li  $v0, 11
    li  $a0, 's'
    syscall
print_and:
    # in " and "
    li  $v0, 4
    la  $a0, and_msg
    syscall
continue_loop:
    addi $t0, $t0, 1
    j    loop
end_loop:
    # in dot
    li  $v0, 11
    li  $a0, '.'
    syscall
    
    li  $v0, 10                 # ket thuc chuong trinh
    syscall                 

#-----------------------------------------------------------------
# Procedure commonCharacterCount
# @brief     find the maximum-sum prefix in a list of integers
# @param[in] a0 dia chi cua xau str1
# @param[in] a1 dia chi cua xau str2
# @return    $v0 Thanh ghi chua ma loi
# @note      xau str2 duoc copy sang str_copy tranh mat noi dung   
#-----------------------------------------------------------------
commonCharacterCount:
    move $t9, $ra            # luu dia chi tro ve ham main
    jal  strcpy              # Sao chep chuoi str2 vao str_copy
    nop
    move $ra, $t9            # khoi phuc dia chi tra ve
    
    move $a2, $v0            # a2 tro den dau cua xau str_copy
    li   $t0, 0                # count = 0
    move $s0, $a0            # s0 tro vao dau chuoi str1
    la   $s3, fre              # dia chi cua mang tan so
    li   $s4, 0              # max luu ky tu chung co ascii lon nhat
    li $t1, 0                # i = 0
outerLoop:# for(i = 0; str1[i] != 0; i++)
    lb   $t2, 0($s0)         # luu str1[i] vao t2
    beqz $t2, exitOuterLoop  
    
    add  $s1, $a2, $zero     # s1 tro vao dau chuoi str_copy
    li   $t3, 0              # j = 0
innerLoop:# for(j = 0; str_copy[j] != 0; j++)
    lb   $t4, 0($s1)         # Luu str_copy[j] vao t4
    beqz $t4, exitInnerLoop  # neu str_copy[j[ == 0, thoat innerLoop
    beq $t2, $t4, foundMatch # neu str[i] == str_copy[j], nhay den foundMatch

    addi $t3, $t3, 1         # j++
    add $s1, $a2, $t3        
    j innerLoop             # tiep tuc innerLoop

foundMatch:
    addi $t0, $t0, 1         # count++ 
    sub $t5, $t4, 'a'        # 
    slt $t8, $t5, $s4
    bnez $t8, next
    move $s4, $t5
next:
    sll $t5, $t5, 2          # 
    add $t5, $s3, $t5        # dia chi cua fre[str_cpy[j]-'a']
    lw  $t6, 0($t5)
    addi $t6, $t6, 1
    sw   $t6, 0($t5)          
    li  $t7, ' '             
    sb $t7, 0($s1)           # danh dau da qua
                             # Exit inner loop
exitInnerLoop:
    addi $t1, $t1, 1         # i++
    add  $s0, $a0, $t1       
    j    outerLoop           # tiep tuc outerLoop

exitOuterLoop:
    move $v0, $t0            # Return count
    jr   $ra                 # Return to the main



#-----------------------------------------------------------------
# Procedure strcpy
# @brief      Sao chep chuoi str2 vao chuoi str_copy
# @param[in]  a1: Địa chỉ của chuỗi str2
# @param[in]  a2: Địa chỉ của chuỗi str_copy
# @param[out] v0: chuoi sao chep tu str2
#-----------------------------------------------------------------
strcpy: 
      li  $s0, 0                  # khoi tao s0 = i = 0
      la  $a1, str2               # a1: dia chi cua chuoi str2
      la  $a2, str_copy           # a2: dia chi cua chuoi str_copy
L1:
      add $t1, $a1, $s0           # t1 = str2[0] + i
                                  #    = dia chi cua str2[i]
      lb  $t2,0($t1)              # t2: gia tri tai dia chi str2[i]
      add $t3, $a2, $s0           # t3 = str_copy[0] + i 
                                  #    = dia chi cua str_copy[i]
      sb  $t2,0($t3)              # str_copy[i] = t2 = str2[i]
      beq $t2,$zero,end_of_strcpy # if str2[i] == 0, exit
      addi $s0,$s0,1              # i = i+1
      j   L1                      # next character
      nop
end_of_strcpy:
      move  $v0, $a2
      jr    $ra
