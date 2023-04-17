.data
    string: .space 50
    x: .space 50
    Message1: .asciiz "Nhap xau: "
    Message2: .asciiz "Xau dao nguoc la: "
.text
main:
get_string:
    li $v0, 4
    la $a0, Message1
    syscall

    li $v0, 8
    la $a0, string
    li $a2, 50
    syscall
    
get_length: la $a0, string        # a0 = Address(string[0])
            xor $s0, $zero, $zero # v0 = length = 0
            xor $t0, $zero, $zero # t0 = i = 0
check_char: add $t1, $a0, $t0 # t1 = a0 + t0
                              #= Address(string[0]+i)
            lb $t2, 0($t1)    # t2 = string[i]
            beq $t2,$zero,end_of_str # Is null char?
            addi $s0, $s0, 1 # v0=v0+1->length=length+1
            addi $t0, $t0, 1 # t0=t0+1->i = i + 1
            j check_char
end_of_str:
end_of_get_length:

    la $a0, string
    la $a1, x
strcpy:
    addi $s0,$s0,-1 #s0 = 0
    li $v1,0 # i=0
L1:
    add $t1,$s0,$a1 #t1 = s0 + a1 = i + y[n]
    # = address of y[i]
    lb $t2,0($t1) #t2 = value at t1 = y[i]
    add $t3,$v1,$a0 #t3 = s0 + a0 = i + x[0]
    # = address of x[i]
    sb $t2,0($t3) #x[i]= t2 = y[i]
    beq $t2,$zero,end_of_strcpy #if y[i]==0, exit
    nop
    addi $v1,$v1,1 #i=i+1
    addi $s0,$s0,-1 #s0=s0 - 1
    j L1 #next character
    nop
end_of_strcpy:

print_length:
    li $v0,4
    la $a0,Message2
    syscall

    li $v0,4
    la $a0,x
    syscall