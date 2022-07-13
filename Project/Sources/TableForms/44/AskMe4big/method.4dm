$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground(230; 230; 255; 255; 255; 255)
		
		RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
		If ([Job_Forms_Items:44]Completed:39#!00-00-00!)
			Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Actual:11; -(Red:K11:4+(256*Light grey:K11:13)); True:C214)
		Else 
			Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Actual:11; -(Black:K11:16+(256*White:K11:1)); True:C214)
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Job_Forms_Items:44]; "Job_Forms_Items")
		
	: ($e=On Double Clicked:K2:5)
		
		sAskMeSaveState("save")
		GET HIGHLIGHTED RECORDS:C902([Job_Forms_Items:44]; "Job_Forms_Items")
		USE SET:C118("Job_Forms_Items")
		$id:=New process:C317("JOB_DisplayForm"; <>lMinMemPart; "DisplayForm_"+[Job_Forms_Items:44]JobForm:1; [Job_Forms_Items:44]JobForm:1)
		If (False:C215)
			JOB_DisplayForm
		End if 
		
		sAskMeSaveState("recall")
End case 
