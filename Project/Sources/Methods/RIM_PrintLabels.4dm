//%attributes = {}
// -----------------
// Method: RIM_PrintLabels
// User name (OS): Mel Bohince
// Date and time: 03/14/18, 15:13:52
// ----------------------------------------------------
// Description
// print roll tags
//
// Parameters
// ----------------------------------------------------
// Modified by: MelvinBohince (4/5/22) use selection instead of UserSet, manage the selection from the calling method

If (Records in selection:C76([Raw_Material_Labels:171])>0)  // Modified by: MelvinBohince (4/5/22) 
	
	currentPrinter:=Get current printer:C788
	If (ok=1)
		$resetPrinter:=True:C214
	Else 
		$resetPrinter:=False:C215
	End if 
	
	sMode:="Print"
	ARRAY TEXT:C222(aAvailablePrinters; 0)
	PRINTERS LIST:C789(aAvailablePrinters)
	$winRef:=Open form window:C675([Raw_Material_Labels:171]; "PrintSettingsDialog")
	DIALOG:C40([Raw_Material_Labels:171]; "PrintSettingsDialog")
	If (ok=1)
		dDate:=Current date:C33
		$numCopies:=Num:C11(sCriterion5)
		$whichPrinter:=aAvailablePrinters{aAvailablePrinters}
		
		Case of 
			: (rb1=1)
				$orientation:=2
				$form:="Labels_1up"
			: (rb2=1)
				$orientation:=1
				$form:="Labels_2up"
			Else 
				$orientation:=1
				$form:="Labels_2up"
		End case 
		
		util_PAGE_SETUP(->[Raw_Material_Labels:171]; $form)
		SET PRINT OPTION:C733(Number of copies option:K47:4; $numCopies)
		SET PRINT OPTION:C733(Orientation option:K47:2; $orientation)
		//SET PRINT OPTION(Double sided option;0)//windows only
		SET CURRENT PRINTER:C787($whichPrinter)
		ARRAY TEXT:C222($trays; 0)
		//Print option values(Paper source option;$trays)//windows only
		//SET PRINT OPTION(Paper source option;1)
		PRINT SETTINGS:C106
		PDF_setUp("rm-barcodes"+".pdf")
		
		
		While (Not:C34(End selection:C36([Raw_Material_Labels:171])))
			
			RELATE ONE:C42([Raw_Material_Labels:171]Raw_Matl_Code:4)
			$h:=Print form:C5([Raw_Material_Labels:171]; $form)
			
			NEXT RECORD:C51([Raw_Material_Labels:171])
		End while 
		
		UNLOAD RECORD:C212([Raw_Materials:21])
		
		If ($resetPrinter)
			SET CURRENT PRINTER:C787(currentPrinter)
		End if 
		
	End if   //ok print
	
Else 
	uConfirm("Select which Label ID's you want to print first."; "Ok"; "Cancel")
End if 