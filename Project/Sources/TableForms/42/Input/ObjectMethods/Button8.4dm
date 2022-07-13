If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	USE SET:C118("clickedIncluded")
	
	<>JOBIT:=[Job_Forms_Items:44]Jobit:4  //Request("Which Job item?";[JobMakesItem]Jobit)  `[JobMakesItem]Jobit
	If (Length:C16(<>JOBIT)=11)  // &(ok=1)
		JMI_CertOfAnal
	End if 
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 