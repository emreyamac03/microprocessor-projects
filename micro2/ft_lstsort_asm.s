; Function: ft_lstsort_asm
; Parameters:
;   R0 - Pointer to the list (address of t_list *)
;   R1 - Pointer to comparison function (address of int (*f_comp)(int, int))
        AREA    Sorting_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  ft_lstsort_asm

ft_lstsort_asm FUNCTION 

	   PUSH {R4-R7, LR}
	   MOVS R4, R0  	    ; head add
 	   LDR  R0, [R4] 		; head
	   LDR  R3, =0x2000100C ; temporary memory adress to save head adress
	   STR  R4, [R3]        ; save head adress into 0x2000100C
	   MOVS R2,  #1  		; swapped 1	   
loop_start
	   CMP  R2, #0  		; cmp swapped
	   BEQ  endsort
	   MOVS R2, #0  		; swapped = 0
	   MOVS R4, #0 			; prev = null
	   MOVS R5, R0 			; current = head
in_loop	
	   LDR  R7, [R5, #4]    ; next = current.next
	   CMP  R7, #0          ; compare is next null
	   BEQ  end_in_loop
	   LDR  R6, [R5] 		; current.data
       LDR  R3, [R7]		; next.data
	   PUSH {R0-R3}  		; save registers after calling comp function
	   PUSH {R5}     		; save current for after usage in func
	   MOVS R5, R1   		; save r1 into r5
	   MOVS R0, R3   		; r0 =  next.data
	   MOVS R1, R6   		; r1 =  current.data
	   BLX  R5       		; branch to comp function		
	   POP {R5}      		; restore r5
	   CMP  R0, #0   		; compare result
       BEQ  no_swap  		; if a > b no swap
	   POP {R0-R3}   		; restore registers
	   MOVS R2,  #1  		; swapped = 1 
	   CMP  R4, #0   		; compare prev == null
	   BEQ head_swap 		; if prev = null go head_swap  
	   STR R7, [R4, #4] 	; prev.next = next
	   
swap_cont	
	   PUSH {R6}
	   LDR  R6,  [R7, #4] 	; next.next
	   STR  R6 , [R5, #4] 	; current.next =  next.next
	   STR  R5 , [R7, #4] 	; next.next = current
	   MOVS R4 , R7 		; prev = next
	   POP  {R6}
	   
	   B  in_loop
	   
head_swap
       MOVS R0, R7  		; load next 
	   PUSH {R3,R4}         ; save register after usage in func
	   LDR R3, =0x2000100C  ; head adress was stored in that adress and get this again for head swap usage
	   LDR R4, [R3]         ; load head
	   STR R0, [R4]         ; store head
	   POP {R3, R4} 
	   B swap_cont
	    
no_swap
       POP {R0-R3}
       MOVS R4, R5  		; prev = current
	   MOVS R5, R7 		    ; current = current next
	   B in_loop
	   
end_in_loop
	   B loop_start     
	   
endsort
	   POP{R4-R7, PC}       ; restore registers 
	   ENDFUNC
	   
	   
	   