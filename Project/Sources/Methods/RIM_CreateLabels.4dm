//%attributes = {}
// -------
// Method: RIM_CreateLabels   ( ) ->
// By: Mel Bohince @ 03/01/18, 17:36:05
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($roll; $numRolls; $copy; $numCopies; $qty)
sMode:="Create"

If (Count parameters:C259=1)
	sCriterion3:=""
	receiptQty:=1
Else 
	sCriterion3:=$1  //String(aRMPONum{aRMPONum}+aRMPOItem{aRMPONum})
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion3)
	If (Records in selection:C76([Purchase_Orders_Items:12])=1)
		tText:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
	End if 
	receiptQty:=$2  //aRMSTKQty{aRMPONum}
End if 

currentPrinter:=Get current printer:C788
ARRAY TEXT:C222(aAvailablePrinters; 0)
PRINTERS LIST:C789(aAvailablePrinters)
$winRef:=Open form window:C675([Raw_Material_Labels:171]; "PrintSettingsDialog")
DIALOG:C40([Raw_Material_Labels:171]; "PrintSettingsDialog")
If (ok=1)
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
	SET PRINT OPTION:C733(Number of copies option:K47:4; 1)  //doesn't coalate correctly so loop below
	SET PRINT OPTION:C733(Orientation option:K47:2; $orientation)
	//SET PRINT OPTION(Double sided option;0)//windows only
	SET CURRENT PRINTER:C787($whichPrinter)
	ARRAY TEXT:C222($trays; 0)
	//Print option values(Paper source option;$trays)//windows only
	//SET PRINT OPTION(Paper source option;1)
	PRINT SETTINGS:C106
	PDF_setUp("rm-barcodes"+".pdf")
	
	$numRolls:=Num:C11(sCriterion4)
	$qty:=iQty
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE EMPTY SET:C140([Raw_Material_Labels:171]; "justCreated")
		For ($roll; 1; $numRolls)
			CREATE RECORD:C68([Raw_Material_Labels:171])
			[Raw_Material_Labels:171]POItemKey:3:=sCriterion3
			[Raw_Material_Labels:171]Raw_Matl_Code:4:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
			[Raw_Material_Labels:171]Qty:8:=$qty
			[Raw_Material_Labels:171]UOM:9:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
			[Raw_Material_Labels:171]RM_Location_fk:13:=""  //$fk
			//see trigger:
			//[Raw_Material_Labels]When_inserted:=TS2iso
			//[Raw_Material_Labels]When_Inventory:=
			//[Raw_Material_Labels]When_touched:=
			SAVE RECORD:C53([Raw_Material_Labels:171])
			ADD TO SET:C119([Raw_Material_Labels:171]; "justCreated")
		End for 
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		
		USE SET:C118("justCreated")
		CLEAR SET:C117("justCreated")
		
	Else 
		
		ARRAY LONGINT:C221($_justCreated; 0)
		
		For ($roll; 1; $numRolls)
			CREATE RECORD:C68([Raw_Material_Labels:171])
			[Raw_Material_Labels:171]POItemKey:3:=[Purchase_Orders_Items:12]POItemKey:1
			[Raw_Material_Labels:171]Raw_Matl_Code:4:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
			[Raw_Material_Labels:171]Qty:8:=$qty
			[Raw_Material_Labels:171]UOM:9:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
			SAVE RECORD:C53([Raw_Material_Labels:171])
			APPEND TO ARRAY:C911($_justCreated; Record number:C243([Raw_Material_Labels:171]))
			
		End for 
		CREATE SELECTION FROM ARRAY:C640([Raw_Material_Labels:171]; $_justCreated)
		
	End if   // END 4D Professional Services : January 2019 
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)
		FIRST RECORD:C50([Raw_Material_Labels:171])
		
	Else 
		
		ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	For ($i; 1; Records in selection:C76([Raw_Material_Labels:171]))
		RELATE ONE:C42([Raw_Material_Labels:171]Raw_Matl_Code:4)
		For ($copy; 1; $numCopies)  // Modified by: Mel Bohince (10/11/18) 
			Print form:C5([Raw_Material_Labels:171]; $form)
		End for 
		NEXT RECORD:C51([Raw_Material_Labels:171])
	End for 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		
		
	Else 
		
		// See line 114
		
		
	End if   // END 4D Professional Services : January 2019 
	UNLOAD RECORD:C212([Raw_Materials:21])
	
	
Else 
	uConfirm("Label records NOT created."; "Ok"; "Cancel")
End if 



