//(S) List'bPrint

$Continue:=True:C214
zwStatusMsg("FINDING POs"; "Only those in status = Approved but not printed")

CUT NAMED SELECTION:C334([Purchase_Orders:11]; "beforePrint")

If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	USE SET:C118("UserSet")  //use POs user selected to process
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
	QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]INX_autoPO:48=False:C215; *)
	QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]Printed:49="")
	
	
Else 
	
	
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]INX_autoPO:48=False:C215; *)
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Printed:49="")
	
	
End if   // END 4D Professional Services : January 2019 
$numPO:=Records in selection:C76([Purchase_Orders:11])

Case of 
	: ($numPO=0)
		BEEP:C151
		uConfirm("All Approved Purchase Orders have been marked as Printed."; "OK"; "Help")
		USE NAMED SELECTION:C332("beforePrint")
		
	Else 
		SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Approving Purchase Orders (NEED TO PRINT)")
		CLEAR NAMED SELECTION:C333("beforePrint")
		CREATE SET:C116([Purchase_Orders:11]; "UserSet")
		HIGHLIGHT RECORDS:C656  //([PURCHASE_ORDER])
		zwStatusMsg("UNPRINTING POs"; "Highlighted Purchase Orders have NOT been printed.")
		BEEP:C151
		fNameWindow(filePtr)
		
End case 