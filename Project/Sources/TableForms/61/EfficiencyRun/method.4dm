//(lop) EfficencyRun
Case of 
	: (Form event code:C388=On Header:K2:17)
		If (Level:C101=1)
			t2b:=aDesc{Selected record number:C246([Job_Forms_Machine_Tickets:61])}
		End if 
	: (Form event code:C388=On Display Detail:K2:22)
		rReal6:=[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
		rReal1:=rReal6-[Job_Forms_Machine_Tickets:61]Run_Act:7
		rReal7:=arNum1{Selected record number:C246([Job_Forms_Machine_Tickets:61])}
		rReal2:=rReal7*rReal1
		rReal5:=([Job_Forms_Machine_Tickets:61]Run_AdjStd:15/[Job_Forms_Machine_Tickets:61]Run_Act:7)*100
		xText:=aText{Selected record number:C246([Job_Forms_Machine_Tickets:61])}
End case 
//