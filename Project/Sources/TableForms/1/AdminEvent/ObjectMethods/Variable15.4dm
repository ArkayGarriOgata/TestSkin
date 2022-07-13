//Script: bFlush()  062596  MLB
//flush buffers on click event
C_LONGINT:C283($ID)
$ID:=New process:C317("uFlushBuffers"; <>lMinMemPart; "Flushing")
If (False:C215)
	uFlushBuffers
End if 
//