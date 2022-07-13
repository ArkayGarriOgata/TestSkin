//%attributes = {"publishedWeb":true}
//gPSpecDel: Deletion of file [PROCESS_SPEC]

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProcessSpec:33=[Process_Specs:18]ID:1)
If (Records in selection:C76([Finished_Goods:26])=0)
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2=[Process_Specs:18]ID:1)
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23=[Process_Specs:18]ID:1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProcessSpec:46=[Process_Specs:18]ID:1)
	
	If (Records in selection:C76([Estimates_PSpecs:57])+Records in selection:C76([Estimates_DifferentialsForms:47])+Records in selection:C76([Job_Forms:42])=0)
		
		If ([Process_Specs:18]Status:2#"New")
			CONFIRM:C162("This Process Spec is Currently at Status: '"+[Process_Specs:18]Status:2+"'."+<>sCr+"Delete?")
		Else 
			OK:=1
		End if 
		
		If (OK=1)
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1)
			gDelSelection(->[Process_Specs_Materials:56])
			QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1=[Process_Specs:18]ID:1)
			gDelSelection(->[Process_Specs_Machines:28])
			gDeleteRecord(->[Process_Specs:18])
		End if 
	Else 
		ALERT:C41("This Process Spec is Currently in Use by an Estimate"+<>sCr+"You May NOT Delete it.")
	End if 
Else 
	BEEP:C151
	ALERT:C41("This process spec is used by a Finished Goods record, no deletion occured.")
End if 