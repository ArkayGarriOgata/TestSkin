Case of 
	: (Form event code:C388=On Load:K2:1)
		wWindowTitle("Push"; "Job_Forms_Materials for "+[Job_Forms_Materials:55]JobForm:1+" Seq: "+String:C10([Job_Forms_Materials:55]Sequence:3; "000"))
		
		sSetMatlEstFlex("Job")
		
	: (Form event code:C388=On Validate:K2:3)
		[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
		[Job_Forms_Materials:55]ModWho:11:=<>zResp
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("Pop")
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
//