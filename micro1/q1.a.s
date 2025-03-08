;EMRE YAMAC 150210077 PART1

W_Capacity EQU 0x32                        ; W_Capacity = 50
SIZE       EQU 0x03                        ; SIZE = 3
       
       AREA knapsackcode, CODE, READONLY   ; new code section
       ALIGN                               ; alignment of __main
        
weight  DCB 10, 20, 30                      ; weight array
profit  DCB 60, 100, 120                    ; profit array
    
        ENTRY
__main  FUNCTION                            ; start __main function
        EXPORT __main                       ; make __main global

        MOVS R4, #W_Capacity               ; load W_Capacity = 50 to R4
        MOVS R5, #SIZE                     ; load SIZE = 50 to R5
        LDR R1, =profit                    ; load address of profit array to R1
        LDR R2, =weight                    ; load address of weight array to R2

        BL knapsack                        ; call knapsack
        B stop                             ; call stop

knapsack                         
        PUSH {R3-R7 , LR}                  ; save registers from R3 to R7 and link register

        CMP R4, #0                         ; compare capacity is zero
        BEQ return_0                       ; if capacity is zero call return_0

        CMP R5, #0                         ; compare size is zero
        BEQ return_0                       ; if size is zero call return_0

        
        SUBS R6, R5, #1                    ; n = n-1 "n = SIZE" and load n to R6
        LDRB R3, [R2, R6]                  ; load weight[n-1] to R3

        CMP R3, R4                         ; compare weight[n-1] > w   "w = W_Capacity"
        BGT skip                           ; if weight[n-1] is greater than w then call skip 

        
        PUSH {R4, R5}                      ; save w and n
        SUBS R5, R5, #1		               ; n = n-1 and load n-1 to R5
        BL knapsack                        ; call knapsack to  "return knapsack(w , n-1)"
        MOVS R7, R0                        ; R0 is the result of "knapsack(w , n-1)" and save onto R7 temporarily
        SUBS R4, R4, R3	                   ; load w - weight[n-1] and load to R4
		BL	knapsack                       ; call knapsack to "(W-weight[n-1], n-1)"
        LDRB R6, [R1, R5]                  ; load profit[n-1] to R6
        ADDS R0, R0, R6                    ; R0 holds the result of knapsack (W-weight[n-1], n-1) and do profit[n-1] + (W-weight[n-1], n-1), load the result to R0
        CMP R0,R7                          ; R0 holds profit[n-1] + (W-weight[n-1], n-1), R7 holds knapsack(w , n-1), and compare them ->> think that part is max function
		BGT continue                       ; if R0 is greater than R7 then call continue
		MOVS R0, R7                        ; load R7 to R0 if R7 is greater than R0
        B continue                         ; call continue

continue
        POP {R4, R5}                       ; reset w and n
        POP {R3-R7, PC}                    ; reset registers from R3 to R7 and reset Program Counter

skip
        SUBS R5, R5, #1                    ; n = n-1 and load n-1 to R5
        BL knapsack                        ; call knapsack
        POP {R3-R7, PC}   		           ; reset registers from R3 to R7 and reset Program Counter

return_0
        MOVS R0, #0                        ; load 0 to R0 for base case "return 0"
        POP {R3-R7, PC}                    ; reset registers from R3 to R7 and reset Program Counter

stop 	
		B stop                             ; loop for stoping 

        ALIGN
        ENDFUNC                            ; end of function __main

        END                                ; end of file
