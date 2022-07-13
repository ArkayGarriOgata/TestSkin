
<>JOBIT:=Request:C163("Which Job item?"; "00000.00.00")  //[JobMakesItem]Jobit
If (Length:C16(<>JOBIT)=11) & (ok=1) & (<>JOBIT#"00000.00.00")
	JMI_CertOfAnal
End if 