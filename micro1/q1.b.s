;EMRE YAMAC 150210077 PART2

W_Capacity EQU 0x32                        ; W_Capacity = 50
SIZE       EQU 0x03                        ; SIZE = 3

       AREA dp_arr, DATA, READWRITE        ; dp_arr area for read and write operations on dp_array
       ALIGN                               ; memory aligment
dp_array SPACE W_Capacity                  ; allocate memory dp_array with size W_Capacity
dp_end

       AREA knapsackcode, CODE, READONLY   ; new code section
       ALIGN                               ; alignment of __main

weight  DCB 10, 20, 30                     ; weight array
profit  DCB 60, 100, 120                   ; profit array        
        
		ENTRY
__main  FUNCTION                           ; start __main function
        EXPORT __main                      ; make __main global
        LDR R1, =profit                    ; load address of profit array to R1
        LDR R2, =weight                    ; load address of profit weight to R2
        LDR R3, =dp_array                  ; load address of dp_array to R3

        BL knapsack                        ; call knapsack 
        B stop                             ; call stop

knapsack
        PUSH {LR}                          ; save Link Register
        MOVS R4, #1                        ; i = 1 , use R4 as "i" variable

outer_loop
        CMP R4, #SIZE + 1                  ; check i < SIZE+1
        BGE done_knapsack                  ; if i >= SIZE+1 call done_knapsack
        MOVS R5, #W_Capacity               ; load W_Capacity = 50 to R5 , use R4 as "w" variable

inner_loop
        CMP R5, #0                         ; check w >= 0 
        BLT next_i                         ; if w < 0 then call next_i

        SUBS R6, R4, #1                    ; i = i-1 and hold i-1 in R6 
        LDRB R7, [R2, R6]                  ; load weight[i-1]  in R7
        CMP R7, R5                         ; check weight[i-1] <= w 
        BGT decrease_w                     ; if weight[i-1] > w then call decrease_w

        SUBS R6, R5, R7                    ; do w - weight[i-1] and hold this in R6
        LDRB R7, [R3, R6]                  ; load dp[w - weight[i-1]] in R7
        LDRB R6, [R1, R4]                  ; load profit[i-1] in R6
        ADDS R6, R7, R6                    ; do dp[w - weight[i-1]] + profit[i-1] and hold this in R6

        LDRB R0, [R3, R5]                  ; load dp[w] to compare with dp[w - weight[i-1]] + profit[i-1]
        CMP R0, R6                         ; compare dp[w] ,  dp[w - weight[i-1]] + profit[i-1]  ->> think that part is max function
        BGT decrease_w                     ; if dp[w] is greater than dp[w - weight[i-1]] + profit[i-1] , do not update dp[w] call decrease_w
        STRB R6, [R3, R5]                  ; if dp[w] is less than dp[w - weight[i-1]] + profit[i-1] , update dp[w]

decrease_w
        SUBS R5, R5, #1                    ; w = w-1 and hold in R5
        B inner_loop                       ; branch to inner_loop

next_i
        ADDS R4, R4, #1                    ; i = i+1 and hold in R4 
        B outer_loop                       ; branch to outer_loop

done_knapsack
        POP {PC}                           ; pop Program Counter for out from knapsack 

stop 
        B stop                             ; stop loop 
       
	   ALIGN
       ENDFUNC                             ; end of __main function
       END                                 ; end of file
