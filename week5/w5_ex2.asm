.data
sum_msg: .asciiz "The sum of "
and_msg: .asciiz " and "
is_msg: .ascii " is "
result_msg: .ascii "\0"

.text
main:
    # gán giá trị cho $s0 và $s1
    li $s0, 25  # s0 = 25
    li $s1, 45  # s1 = 45
    
    # cộng $1 và $s2 và gán vào thanh ghi t0
    add $t0, $s0, $s1   # t0 = s0 + s1
    
    # in ra nội dung của sum_msg "The sum of "
    li $v0, 4     # print string
    la $a0, sum_msg  
    syscall
    
    # in ra giá trị của $s0
    li $v0, 1
    move $a0, $s0
    syscall
    
    # in ra: " and "
    li $v0, 4     # print string
    la $a0, and_msg
    syscall
    
    # in ra giá trị của $s1
    li $v0, 1
    move $a0, $s1
    syscall
    
    # in ra " is "
    li $v0, 4     # print string
    la $a0, is_msg
    syscall
    
    # in ra kết quả phép cộng $t0
    li $v0, 1
    move $a0, $t0
    syscall
    
    # print '\0' kết thúc chuỗi
    li $v0, 4    # print string
    la $a0, result_msg
    syscall
    
    # exit the program
    li $v0, 10
    syscall
