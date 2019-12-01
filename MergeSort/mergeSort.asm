.data                           # Defines variable section of an assembly routine.
array: .word 12,15,10,5,7,3,2,1 # Define a variable named array as a word (integer) array.
                                # After your program has run, the integers in this array
                                # should be sorted.
.text                           # Defines the start of the code section for the program .
.globl main
main:
  la $s0, array                 # Moves the address of array into register $t0.
  addi $a0, $s0, 0              # Set argument 1 to the array.
  addi $a1, $zero, 0            # Set argument 2 to (low = 0)
  addi $a2, $zero, 7            # Set argument 3 to (high = 7, last index in array)
  jal mergeSort                 # Call merge sort
  addi $s7, $zero, 28           # setup array byte size 7 * 4 (0 index)
  j printArrayAndExit

# void mergeSort(int arr[], int l, int r) {
mergeSort:
# Setup the stack
addi $sp, $sp, -48
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $s7, 28($sp)
sw $ra, 32($sp)
sw $a0, 36($sp)
sw $a1, 40($sp)
sw $a2, 44($sp)

slt $s0, $a1, $a2 #   if (l < r) {
beq $s0, $zero, exitMergeSort # if l is not less than r return to caller
sub $s1, $a2, $a1 # (r - l)
srl $s2, $s1, 1 # divide result of r - 1 by 2
add $s3, $a1, $s2 # int m = l + (r - 1) / 2

# Sort first and second halves
add $s4, $a2, $zero # store r in $s4 to reload and use for second mergesort
add $a2, $s3, $zero # put m into argument 2 for merge sort call
jal mergeSort # recursively call mergeSort with (arr, l, m);

add $s5, $a1, $zero # store l for later use in merge
addi $a1, $s3, 1 # call mergeSort with m + 1 in argument position 1
add $a2, $s4, $zero # restore r from $s4 into $a2 for mergeSort call
jal mergeSort # recursively call mergeSort with (arr, m + 1, r);

# Merge the resulting arrays,
add $a1, $s5, $zero # restore l from $s2 to $a1 for merge call
add $a2, $s3, $zero # move m into argument position 2 for merge call
add $a3, $s4, $zero # move r into argument position 3 for merge call
jal merge # merge(arr, l, m, r);
j exitMergeSort # end of if statement exitMergeSort and return to caller

# This is a non-standard merge (has poorer runtime), but is in-place.
# void merge(int arr[], int l, int m, int r) {
# l is for left index and r is right index of the
# sub-array of arr to be sorted
merge:
#setup the stack
addi $sp, $sp, -52
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $s7, 28($sp)
sw $ra, 32($sp)
sw $a0, 36($sp)
sw $a1, 40($sp)
sw $a2, 44($sp)
sw $a3, 48($sp)

#Setup i, j
add $s0, $a2, $zero # int i = m;
addi $s1, $a2, 1 # int j = m + 1;

# check outer loop condition of j <= r by checking if j is greater than
outerwhile:
slt $t0, $a3, $s1 # r < j 1 true 0 false
bne $t0, $zero, exitMerge # if r < j we get 1 and we exit otherwise r < j is false and we continue with the while loop

# Setup x and y outside of innerwhile so that they are decremented on each loop but not reset
add $s2, $s0, $zero # int x = i;
add $s3, $s1, $zero # int y = j;

  #inner while loop conditional
  innerwhile:
  #Setup arr indexes for check. Do this in innerwhile so that they are calculated on each jump to innerwhile
  # arr[x]
  sll $t1, $s2, 2 # setup x offset
  add $t1, $a0, $t1 # add x offset to the base array address
  lw $s4, 0($t1) # load value from array address for arr[x]
 
  # arr[y]
  sll $t2, $s3, 2 # setup y offset
  add $t2, $a0, $t2 # add y offset to the base array address
  lw $s5, 0($t2) # load value from array address for arr[y]

  # Removed using and instruction after reviewing 2.13 swap example inner loop on page 136 and 137. 
  # Check each condition seperately and exit where required.
  slt $t4, $s2, $a1 # reg $t4 = 1 if x < l
  bne $t4, $zero, exitInner # if x < l then 1 which will exit. If x >= l then 0 and continue
  slt $t3, $s5, $s4 # invert arr[x] > arr[y] to arr[y] < arr[x] for slt check 
  beq $t3, $zero exitInner # if arr[y] is not less than arr[x] exit
  add $s6, $a1, $zero # store a1
  add $s7, $a2, $zero # store a2
  add $a1, $s2, $zero # x in $a1
  add $a2, $s3, $zero # y in $a2
  jal swap # swap(arr, x, y);
  add $a1, $s6, $zero # restore original $a1
  add $a2, $s7, $zero # restore original $a2
  addi $s2, $s2, -1 # x--;
  addi $s3, $s3, -1 # y--;
  j innerwhile

exitInner:
add $s0, $s1, $zero # i = j;
addi $s1, $s1, 1 # j++;
j outerwhile


# // A utility function to swap two elements
# void swap(int* array, int x , int y) {
swap:
# setup the stack
addi $sp, $sp, -52
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $s7, 28($sp)
sw $ra, 32($sp)
sw $a0, 36($sp)
sw $a1, 40($sp)
sw $a2, 44($sp)
sw $a3, 48($sp)

# load variables
sll $s0, $a1, 2 # temp = x * 4 for word byte offset
add $s0, $a0, $s0 # array + (x * 4)
lw $s1, 0($s0) #int temp = array[x];

sll $s2, $a2, 2 # array y offset
add $s2, $a0, $s2 # array y offset
lw $s3, 0($s2) # array y value

# swap values in array
sw $s3, 0($s0) # store the value of y in position of x from above
sw $s1, 0($s2) # store the temp value in y
j exitSwap


# Exit labels for cleaning up the stack and returning to caller for each functions
exitSwap:
# restor register values and return to caller
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
lw $a0, 36($sp)
lw $a1, 40($sp)
lw $a2, 44($sp)
lw $a3, 48($sp)

addi $sp, $sp, 52
jr $ra

exitMerge:
# restore register values and return to caller
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
lw $a0, 36($sp)
lw $a1, 40($sp)
lw $a2, 44($sp)
lw $a3, 48($sp)

addi $sp, $sp, 52
jr $ra

exitMergeSort: 
# restore register values and return to caller
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
lw $a0, 36($sp)
lw $a1, 40($sp)
lw $a2, 44($sp)

addi $sp, $sp, 48
jr $ra

# creating function to help debug and validate the output
printArrayAndExit:
  addi $t0, $zero, 4 # value type offset 4 for word
  sub $t1, $zero, $t0 #initialize the loop counter
  
  loop:
    add $t1, $t1, $t0 # add the offset to the loop counter
    add $t2, $s0, $t1 # store the offset address
    lw $a0, 0($t2) # load the value at the address
    addi $v0, $zero, 1 # tell mips the type of the value
    syscall # print value
    beq $t1, $s7, exit # if $t1 is equal to the final byte offset stored in $s7 exit
    j loop # jump to the loop
  
  exit:
    li $v0, 10                    # Terminate program run and
    syscall                       # Exit

