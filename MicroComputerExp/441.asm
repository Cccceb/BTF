
MY_STACK	SEGMENT	PARA 'STACK' 
			DB		100 DUP(?)
MY_STACK	ENDS
;
MY_DATA 	SEGMENT	PARA 'DATA'
IO_9054base_address DB 4 DUP(0)						;PCI卡9054芯片I/O基地址暂存空间
IO_base_address     DB 4 DUP(0)						;PCI卡I/O基地址暂存空间
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
.386	;386模式编译
			MOV		AX,MY_DATA
			MOV		DS,AX
			MOV		ES,AX
			MOV		AX,MY_STACK
			MOV		SS,AX
			CALL	FINDPCI					;自动查找PCI卡资源及IO口基址
			MOV		CX,word ptr IO_base_address	
;			MOV		CX,0E800H				;直接加入(E800:本机PCI卡IO口基址)
        	
			ADD		A,CX				;PCI卡IO基址+偏移
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
;		/* 延时子程序 */
;*****************************************************************************
;
DELAY 		PROC  	NEAR					;延时程序
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
;		/* 按任意键退出子程序 */
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
;		/* 找卡子程序 */
;*****************************************************************************			
;
IO_port_addre		EQU 0CF8H					;32位配置地址端口
IO_port_data		EQU	0CFCH					;32位配置数据端口
IO_PLX_ID			EQU	200810B5H				;PCI卡设备及厂商ID
BADR0				=	10H						;基地址寄存器0
BADR1				=	14H						;基地址寄存器1
BADR2				=	18H						;基地址寄存器2
BADR3				=	1CH						;基地址寄存器3

FINDPCI 	PROC	NEAR						;查找PCI卡资源并显示
			PUSHAD
			PUSHFD
			MOV		EBX,080000000H
FINDPCI_next:
			ADD		EBX,100H
			CMP 	EBX,081000000H
			JNZ 	findpci_continue
			MOV 	DX,offset pcicardnotfind	;显示未找到PCI卡提示信息
			MOV 	AH,09H
			INT 	21H
			MOV 	AH,4CH
			INT 	21H							;退出
findpci_continue:
			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			OUT 	DX,EAX						;写地址口
			MOV 	DX,IO_port_data
			IN  	EAX,DX						;读数据口
			CMP 	EAX,IO_PLX_ID
			JNZ 	findpci_next				;检查是否发现PCI卡

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
       		ADD 	EAX,BADR1
			OUT 	DX,EAX									;写地址口
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;读数据口
			MOV 	dword ptr IO_9054base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;检查是否为i/o基址信息
       		MOV 	EAX,dword ptr IO_9054base_address
			AND 	EAX,0fffffffeh
        	MOV 	dword ptr IO_9054base_address,EAX		;去除i/o指示位并保存

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			ADD 	EAX,BADR2
			OUT 	DX,EAX									;写地址口
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;读数据口
			MOV 	dword ptr IO_base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;检查是否为i/o基址信息
			MOV 	EAX,dword ptr IO_base_address
			AND 	EAX,0fffffffeh
			MOV 	dword ptr IO_base_address,EAX			;去除i/o指示位并保存
			MOV 	DX,offset good							;显示开始执行程序信息
			MOV 	AH,09H
			INT 	21H
			POPfd
			POPad
			RET
findPCI		ENDP

MY_CODE 	ENDS
			
     		END START
