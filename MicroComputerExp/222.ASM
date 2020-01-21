DHT SEGMENT PARA 'STACK'
  DB 255 DUP(?)
DHT ENDS

DATA SEGMENT PARA 'DATA'
BUF DB 0AH,0DH,'Please Input %5D :$'
B_X DB 10
WRONG DB 'Please Input a Number',0DH,0AH,'$'
string DB 'Please Input a String',0DH,0AH,'$'
SUM DB 41
DATA ENDS

CODE SEGMENT PARA 'CODE'
 ASSUME  DS:DATA,SS:DHT,CS:CODE
 
START:
 
      MOV AX,DATA
      MOV DS,AX
      LEA DX,BUF
      MOV AH,9
      INT 21H
      MOV BX,0
      MOV AX,0
      
INPUT:

      MOV AH,1
      INT 21H
      CMP AL,0DH
      JZ BINARY
      CMP AL,'q'
      JZ FINAL
      CMP AL,'Q'
      JZ FINAL
      CMP AL,'\'
      JE COUNT
      CMP AL,'0'
      JB ERROR
      CMP AL,'9'
      JA ERROR
     
      AND AL,0FH
      CBW
      XCHG AX,BX
      MUL B_X
      ADD BX,AX
      JMP INPUT
BINARY:
      MOV AH,2
      MOV DL,0AH
      INT 21H
      MOV CX,16
L1:
      MOV DL,0
      ROL BX,1
      RCL DL,1
      OR DL,30H
      MOV AH,2
      INT 21H
      LOOP L1
      MOV DL,'B'
      MOV AH,2
      INT 21H
      JMP START
COUNT:
	 MOV CL,0
	 LEA DX,string
      MOV AH,9
      INT 21H
L2:
	  MOV AH,1
      INT 21H
      CMP AL,' '
      JE COUNT_END
      CMP AL,'q'
      JZ FINAL
      CMP AL,'Q'
      JZ FINAL
	  CMP AL,'0'
      JB L2
      CMP AL,'9'
      JA L2
      INC CL
      JMP L2
COUNT_END:
	MOV DL,CL
	ADD DL,30H
	MOV AH,2
	INT 21H
	JMP START	
ERROR:
      LEA DX,WRONG
      MOV AH,9
      INT 21H
      MOV CX,16
      JMP INPUT
FINAL:
      MOV AX,4C00H
      INT 21H
  CODE ENDS
  END START
