
MY_STACK	SEGMENT	PARA 'STACK' 
			DB		100 DUP(?)
MY_STACK	ENDS
;
MY_DATA 	SEGMENT	PARA 'DATA'
IO_9054base_address DB 4 DUP(0)						;PCI��9054оƬI/O����ַ�ݴ�ռ�
IO_base_address     DB 4 DUP(0)						;PCI��I/O����ַ�ݴ�ռ�
pcicardnotfind		DB 0DH,0AH,'pci card not find or address/interrupt error !!!',0DH,0AH,'$'
GOOD				DB 0DH,0AH,'The Program is Executing !',0DH,0AH,'$'
LA			DB		?
LB			DB 		?
A    	DW		0000H    		
B    	DW		0001H
C    	DW		0002H
control 	DW		0003H

DELAY_SET	EQU	 	01FFH	
MES2		DB '	PCI CONFIG READ ERROR!		$'
MY_DATA 	ENDs

MY_CODE 	SEGMENT PARA 'CODE'

MY_PROC		PROC	FAR		
			ASSUME 	CS:MY_CODE,	DS:MY_DATA,	SS:MY_STACK
			
START:	
.386	;386ģʽ����
			MOV		AX,MY_DATA
			MOV		DS,AX
			MOV		ES,AX
			MOV		AX,MY_STACK
			MOV		SS,AX
			CALL	FINDPCI					;�Զ�����PCI����Դ��IO�ڻ�ַ
			MOV		CX,word ptr IO_base_address	
;			MOV		CX,0E800H				;ֱ�Ӽ���(E800:����PCI��IO�ڻ�ַ)
        	
			ADD		A,CX				;PCI��IO��ַ+ƫ��
        	ADD		B,CX
        	ADD		C,CX
        	ADD		control,CX
       		
       		
       		
       		
       		
      		MOV 	DX,control         
       		MOV 	AL,81H
       		OUT 	DX,AL
       		
	     	MOV 	DX,A			
	    	MOV 	AL,7FH
       		OUT 	DX,AL
       		MOV 	LA,AL

       		MOV 	DX,B			
       		MOV 	AL,0FEH
       		OUT 	DX,AL
       		MOV 	LB,AL
       		CALL	DELAY
       		CALL	DELAY
       		CALL	DELAY
       		CALL	DELAY		
       		CALL	DELAY
       		CALL	DELAY
       		
A1:    		MOV 	AL,LA				
       		ROR 	AL,1
       		MOV 	LA,AL
       		MOV 	DX,A
       		OUT 	DX,AL
       		MOV 	AL,LB
       		ROL 	AL,1
       		MOV 	LB,AL
       		MOV 	DX,B			
       		OUT 	DX,AL
       		CALL	DELAY
       		CALL	DELAY
       		CALL	DELAY
       		CALL	DELAY		
       		CALL	DELAY
       		CALL	DELAY					
       		CALL 	BREAK
       		MOV 	DX,C
       		IN		AL,DX
       		AND		AL,01H
       		JNZ		A2	
       		JMP 	A1
       		
A2:    		MOV 	AL,LA				
       		ROL 	AL,1
       		MOV 	LA,AL
       		MOV 	DX,A
       		OUT 	DX,AL
       		MOV 	AL,LB
       		ROR 	AL,1
       		MOV 	LB,AL
       		MOV 	DX,B			
       		OUT 	DX,AL
       		CALL	DELAY
       		CALL	DELAY
       		CALL	DELAY
       		CALL	DELAY		
       		CALL	DELAY
       		CALL	DELAY					
       		CALL 	BREAK	
       		MOV 	DX,C
       		IN		AL,DX
       		AND		AL,01H
       		JZ		A1		
       		JMP 	A2
MY_PROC		ENDp				
;
;*****************************************************************************
;		/* ��ʱ�ӳ��� */
;*****************************************************************************
;
DELAY 		PROC  	NEAR					;��ʱ����
			PUSHF
			PUSH	DX
			PUSH	CX
			MOV 	DX,DELAY_SET
D1: 	   	MOV 	CX,-1
D2:    		DEC 	CX
       		JNZ 	D2
       		DEC		DX
       		JNZ		D1
       		POP		CX
       		POP		DX
       		POPF
       		RET
DELAY  		ENDp
;
;*****************************************************************************
;		/* ��������˳��ӳ��� */
;*****************************************************************************			
;
BREAK 		PROC  	NEAR 
      		MOV 	AH,06H
       		MOV 	DL,0FFH
       		INT 	21H
       		JE  	RETURN
       		MOV 	AX,4C00H
       		INT 	21H
RETURN:		RET
BREAK 		ENDP
;
;*****************************************************************************
;		/* �ҿ��ӳ��� */
;*****************************************************************************			
;
IO_port_addre		EQU 0CF8H					;32λ���õ�ַ�˿�
IO_port_data		EQU	0CFCH					;32λ�������ݶ˿�
IO_PLX_ID			EQU	200810B5H				;PCI���豸������ID
BADR0				=	10H						;����ַ�Ĵ���0
BADR1				=	14H						;����ַ�Ĵ���1
BADR2				=	18H						;����ַ�Ĵ���2
BADR3				=	1CH						;����ַ�Ĵ���3

FINDPCI 	PROC	NEAR						;����PCI����Դ����ʾ
			PUSHAD
			PUSHFD
			MOV		EBX,080000000H
FINDPCI_next:
			ADD		EBX,100H
			CMP 	EBX,081000000H
			JNZ 	findpci_continue
			MOV 	DX,offset pcicardnotfind	;��ʾδ�ҵ�PCI����ʾ��Ϣ
			MOV 	AH,09H
			INT 	21H
			MOV 	AH,4CH
			INT 	21H							;�˳�
findpci_continue:
			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			OUT 	DX,EAX						;д��ַ��
			MOV 	DX,IO_port_data
			IN  	EAX,DX						;�����ݿ�
			CMP 	EAX,IO_PLX_ID
			JNZ 	findpci_next				;����Ƿ���PCI��

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
       		ADD 	EAX,BADR1
			OUT 	DX,EAX									;д��ַ��
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;�����ݿ�
			MOV 	dword ptr IO_9054base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;����Ƿ�Ϊi/o��ַ��Ϣ
       		MOV 	EAX,dword ptr IO_9054base_address
			AND 	EAX,0fffffffeh
        	MOV 	dword ptr IO_9054base_address,EAX		;ȥ��i/oָʾλ������

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			ADD 	EAX,BADR2
			OUT 	DX,EAX									;д��ַ��
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;�����ݿ�
			MOV 	dword ptr IO_base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;����Ƿ�Ϊi/o��ַ��Ϣ
			MOV 	EAX,dword ptr IO_base_address
			AND 	EAX,0fffffffeh
			MOV 	dword ptr IO_base_address,EAX			;ȥ��i/oָʾλ������
			MOV 	DX,offset good							;��ʾ��ʼִ�г�����Ϣ
			MOV 	AH,09H
			INT 	21H
			POPfd
			POPad
			RET
findPCI		ENDP

MY_CODE 	ENDS
			
     		END START
