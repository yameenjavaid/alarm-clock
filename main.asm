INCLUDE Irvine32.inc
INCLUDE GraphWin.inc
INCLUDE Inputmod.inc
	
.code
	main proc
	xor eax, eax
	xor ebx, ebx

	mov  eax,  black +(green + 10)
	call SetTextColor
	
        
        call WELCOMESCR
        mov eax, 5000
        mov eax, 3000
        call delay
	call clrscr
	
  	RETRY:       
        call LOCALTIME
        
        call crlf

	GETDATA hrstr, hr
	
	GETDATA minstr, mnt
	
	CHECK hr,mnt,bh
	
	; if users enter wrong time
	.IF(flg > 0)
		call INVALID
		mov eax, 1500
		call delay
		call clrscr	
		jmp RETRY

	.ENDIF
	
	SNOOZE:
	call clrscr
	call LEFTTIME
	
	WAITING:
		call LOCALTIME
		call LEFTTIME
		mov eax, 300
		call delay

		mov bl, mnt
		mov al, hr
		.IF (sysMin == bl && sysHour == al)
			jmp TIMECHECK
		.ELSE
			jmp WAITING
		.ENDIF
			
	TIMECHECK:
	mov eax, green
	call SetTextColor
	xor ebx, ebx

	mov bl, sysMin
	inc ebx
	
	call clrscr
	call LOCALTIME

	.WHILE (bl > sysMin)
		INVOKE PlaySound, OFFSET file, NULL, SND_FILENAME
		
		call LOCALTIME
	
	.ENDW

	;INVOKE MessageBox, NULL, ADDR PopupText, ADDR PopupTitle, MB_OKCANCEL

	.IF (eax != 1)
		jmp STOP_ALARM

	.ENDIF

	.IF (sysMin > 55)
		mov al, 60
		sub al, mnt
		mov mnt, al
		inc hr
	
	.ELSE
		add mnt, 5

	.ENDIF
	
	jmp SNOOZE

	STOP_ALARM:
	
	call crlf
	exit
    	main endp


end main
