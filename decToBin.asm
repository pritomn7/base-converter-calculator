
include 'emu8086.inc'

.ORG    100h


; >>>>>>>>DECIMAL TO BINARY<<<<<<<

data segment
    
    Integer dw 0;
    
    fraction dw 0;
    
    binInt db 16 dup(0)
    idxI db 0
    
    binFrac db 4 dup(0)
    idxB db 0 
    
ends

code segment
start:

call pthis
db 'Enter a decimal Number: ', 0 

;Taking the Integer part of the decimal number
    takeIntPart:
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        xor di, si
        mov integer, dx
        mov fraction, dx
        
        
        
        mov ah, 1
        mov cx, 5
        mov bx, 10 
        
        takeIntDigit:
        
             int 21h;
             
             cmp al, 02Eh;
             je takeFracPart;
             
             cmp al, 0Dh;
             je conversion;
             
             sub al, 30h
             push ax
             mov ax, integer
             mul bx
             mov integer, ax
             pop ax
             push bx
             mov bh, ah
             xor ah, ah
             add ax, integer
             mov integer, ax
             mov ah, bh
             pop bx
             loop takeIntDigit;
             
         int 21h    

;taking the fraction part of the decimal number
    
    takeFracPart:
    
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        
        mov ah, 1
        mov cx, 4
        mov bl, 10 
        
        takeFracDigit:
             
             int 21h;
             
             cmp al, 0Dh;
             je conversion;
             
             sub al, 30h
             push ax
             mov ax, fraction
             mul bx
             mov fraction, ax
             pop ax
             push bx
             mov bh, ah
             xor ah, ah
             add ax, fraction
             mov fraction, ax
             mov ah, bh
             pop bx
             loop takeFracDigit;
             
            
;conversion to binary

    conversion: 
        cmp cx, 4
        jg IntegerConversion
        mov bx, 4
        sub bx, cx
        mov idxB, bx ;setting the legth of the moduler for the fraction part
         
        ;converting ingeter part
        IntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 16
             mov si, 15
             mov bx, 2
             
             s1:
             
               div bx

               add dl, 30h
               mov binInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop s1
           
                
         ;converting the fraction part
         FractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
       
               ;calculating modular
               mov cx, idxB
               cmp cx, 0
               je print
               mov ax, 1
               mov bx, 10
               countModBin:
                    mul bx
                    loop countModBin
               
               
               ;conversion starts
               
               mov cx, 4
               mov bx, ax ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               s2:
                push bx
                mov bx, 2
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                mov binFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop s2 
                
                 
                               
         Print:  
         
         call pthis 
         db 10, 13, 10, 13, 'in binary: ', 0
                
                mov ah, 2
                
                mov cx, 16
                mov di, 0
                strt1:
                    
                    mov dl, binInt[di]
                    int 21h
                    
                    inc di
                    loop strt1
                
                mov dl, 2Eh
                int 21h
                
                mov cx, 4
                mov si, 0
                strt2:
                    
                    mov dl, binFrac[si]
                    int 21h
                    inc si
                    loop strt2
                
                       
                
            
EXIT:
    mov ax, 4c00h ; exit to operating system.
    int 21h
      
ends  

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS

end start ; set entry point and stop the assembler.


                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                          ;mov ah, 2
;                mov dl, 0Ah
;                int 21h
;                mov dl, 0Dh
;                int 21h
;                
;                mov si, idxI
;                mov bx, 16
;                sub bx, si
;                mov cx, bx
;                strt2:
;                    
;                    mov dl, binInt[si]
;                    int 21h
;                    
;                    inc si
;                    loop strt2
;                
;                








