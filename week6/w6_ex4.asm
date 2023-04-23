.data
A: .word 9, 7, 6, 5, 4, 3, 2, 1, 0
Aend: .word 

.text
main:   la $a0, A           # $a0 = Address(A[0])
        la $a1, Aend        # $a1 = Address(A[n-1]) + 4 //dieu kien dung vong lap
        j sort              # sort
after_sort:  li $v0, 10     # exit
             syscall
end_main:


# INSERTION SORT
sort:   beq $a0, $a1, done       # single element list is sorted
        j   travasal                  # call the travasal procedure
done:   j     after_sort

travasal:    addi $v0, $a0, 4    # init pointer to second element
             addi $t0, $v0, 0         # init previous pointer to $v0
loop:   beq  $v0, $a1, after_sort  # if next=last, return
        lw   $v1, 0($v0)         # init value to $v1
        addi $t0, $v0, -4        # advance to next element
        lw   $t1, 0($t0)         # load previous element into $t1
        sgt  $t2, $t1, $v1       # (pre)>(cur) ?
        bne  $t2, $zero, progress    # if (pre)<(cur), progress
        addi $v0, $v0, 4         # next element 
        addi $t0, $t0, 4         # 
        j    loop                # change completed; now repeat

progress:       addi  $t5, $v1, 0   # value of current ($v1)
                addi  $t3, $v0, 0   # phan tu tinh tien 
repeat:         sw   $t1, 0($t3)    # begin move back
                add  $t3, $t3, -4   # the next element move back
                beq  $t0, $a0, end    # check ($t0 == $a0) tránh trường hợp duyệt quá mảng
                add  $t0, $t0, -4   
                lw   $t1, 0($t0)
                slt  $t2, $t1, $t5            # (pre)<(cur) ? 
                beq  $t2, $zero, repeat       # if (pre)<(cur), repeat
end:            sw   $t5, 0($t3)
                add  $v0, $v0, 4 
                j    loop
end_loop: