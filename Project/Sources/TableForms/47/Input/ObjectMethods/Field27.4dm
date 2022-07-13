//allow different p-spec on forms within a diff

// Modified by: Mel Bohince (8/30/21) switch to util_PickOne_UI; but I don't think the field that this is attached to is enterable

If ([Estimates_DifferentialsForms:47]ProcessSpec:23#"")
	//validate that p-spec
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23; *)
	QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)
	Case of 
		: (Records in selection:C76([Process_Specs:18])=0)
			BEEP:C151
			ALERT:C41([Estimates_DifferentialsForms:47]ProcessSpec:23+" has not been defined for this customer.")
			[Estimates_DifferentialsForms:47]ProcessSpec:23:=Old:C35([Estimates_DifferentialsForms:47]ProcessSpec:23)
			
		: (Records in selection:C76([Process_Specs:18])>1)
			C_OBJECT:C1216($thePick)  // Modified by: Mel Bohince (8/30/21) 
			$thePick:=util_PickOne_UI(ds:C1482.Process_Specs.query("ID = :1 and Cust_ID = :2"; [Estimates_DifferentialsForms:47]ProcessSpec:23; [Estimates:17]Cust_ID:2); "ID")
			
			If ($thePick.success)
				[Estimates_DifferentialsForms:47]ProcessSpec:23:=$thePick.value
				
			Else   //see util_PickOne_UI for possibilities
				BEEP:C151
				BEEP:C151
				BEEP:C151
				[Estimates_DifferentialsForms:47]ProcessSpec:23:=Old:C35([Estimates_DifferentialsForms:47]ProcessSpec:23)
			End if 
			//Open window(20;50;240;270;1;"")
			//DIALOG([Process_Specs];"PickOne")
			//CLOSE WINDOW
			//If (ok=1)
			//[Estimates_Carton_Specs]ProcessSpec:=asText{asText}
			//QUERY([Process_Specs];[Process_Specs]ID=[Estimates_DifferentialsForms]ProcessSpec)
			//Else 
			//[Estimates_DifferentialsForms]ProcessSpec:=Old([Estimates_DifferentialsForms]ProcessSpec)
			//End if 
			//[Estimates_DifferentialsForms]ProcessSpec:=[Process_Specs]ID
			
			
		Else 
			[Estimates_DifferentialsForms:47]ProcessSpec:23:=[Process_Specs:18]ID:1
	End case 
	
	If ([Estimates_DifferentialsForms:47]ProcessSpec:23#Old:C35([Estimates_DifferentialsForms:47]ProcessSpec:23))  //copy over the machines and materials to this form
		sUpDatePspecLin
	End if 
	
Else   //cant be null
	[Estimates_DifferentialsForms:47]ProcessSpec:23:=Old:C35([Estimates_DifferentialsForms:47]ProcessSpec:23)
End if 
//