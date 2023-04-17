.data
string:   .space   21
msg_rev:  .space   21
Message1: .asciiz "Input string: "
Message2: .asciiz "\nReverse string: "

.text
main:
get_string:  
          li $v0, 4
          la $a0, Message1
          syscall
             
          li $v0, 8
          la $a0, string
          li $a1, 21
          syscall 
             
get_length:  # Tính chiều dài của chuỗi
          la   $a0, string          # a0 = Address(string[0])
          xor  $v0, $zero, $zero    # v0 = length = 0
          xor  $t0, $zero, $zero    # t0 = i = 0
check_char:  
          add  $t1, $a0, $t0        # t1 = a0 + t0 
                                     #    = Address(string[0]+i) 
          lb   $t2, 0($t1)          # t2 = string[i]
          beq  $t2, $zero, end_of_str # Is null char?
          addi $v0, $v0, 1          # v0=v0+1->length=length+1
          addi $t0, $t0, 1          # t0=t0+1->i = i + 1 
          j    check_char
end_of_str:                
end_of_get_length:

check_new_line: 
          addi $t4, $v0, -1       # lấy vị trí vi thứ  i = length - 1 để kiểm tra xem ký tự cuối có phải là ký tự xuón
          add  $s0, $a0, $t4      # địa chỉ của string[0] + i
          lb   $t5, 0($s0)        # lấy giá trị từ địa chỉ (string[0] + i)
          li   $t8, '\n'          # gán giá trị thanh ghi $t8 = '\n'
          bne  $t5, $t8, reverse_string   # kiểm tra xem giá trị string[0] + i có phải là '\n' không
          add  $v0, $v0, -1       # nếu là '\0' ta tính length = length trừ 1 bỏ qua '\n' để đi đảo chuỗi 

reverse_string: 
          la    $a1, msg_rev       # lấy địa chỉ của msg_rev
          addi  $v0, $v0, -1       # length of string
          li    $v1, 0             # v1 = i = 0
rev: 
          addi  $t3, $v0, 1     
          beq   $t3, $zero, end_of_rev  # kiểm tra xem 
          add   $t1, $a0, $v0      #  lấy địa chỉ của string[0]
          lb    $t2,  0($t1)       #  lấy giá trị từ địa chỉ string[0]      
          add   $t3, $a1, $v1      #  lấy địa chỉ msg_rev[0] + i
          sb    $t2, 0($t3)        #  gán giá trị msg_rev[i]
          addi  $v1, $v1,1         #  i=i+1
          addi  $v0, $v0, -1       #  length = length - 1
          j     rev                #  next character
end_of_rev:  
           
output:   li $v0, 4           # in ra  "\nReverse string: "
          la $a0, Message2
          syscall
        
          li $v0, 4           # in ra gia tri cua msg_rev (sau khi reverse từ string)
          la $a0, msg_rev   
          syscall
             
