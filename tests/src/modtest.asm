	org	32687
	call	$0daf		; clear screen
	ld	bc, 10		; push 10 to calc stack
	call	$2d2b
	ld	bc, 3		; push 3 to calc stack
	call	$2d2b
	call	$36a0           ; call mod subroutine
	call	$2da2		; pop calc stack to BC
	call	$1a1b		; print BC
	call	$2da2		; pop calc stack to BC
	call	$1a1b		; print BC
	ret
