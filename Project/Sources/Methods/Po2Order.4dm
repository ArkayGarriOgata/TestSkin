//%attributes = {"publishedWeb":true}
//(p) Po2Order 
//• 7/25/97 cs created.

C_BOOLEAN:C305(fApproving; fOrdering)

FilePtr:=->[Purchase_Orders:11]
FileNum:=Table:C252(FilePtr)
fOrdering:=True:C214
FilePtr:=->[Purchase_Orders:11]
zDefFilePtr:=->[Purchase_Orders:11]  //• cs 9/9/97 added so that adhoc menus function
FileNum:=Table:C252(FilePtr)
sFile:=Table name:C256(FilePtr)  //•082499  mlb  
fAdHoc:=False:C215  //•082499  mlb  
gClearFlags

If (qryPo2Order>0)  //if there are POs to Approve
	fApproving:=False:C215
	fOrdering:=True:C214
	fChoose:=False:C215
	sPOAction:="Mod"
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(FileNum))
	windowTitle:=fNameWindow(filePtr)+" Ordering Purchase Orders"
	$winRef:=OpenFormWindow(->[Purchase_Orders:11]; "Input"; ->windowTitle)
	//
	//$winRef:=Open form window([Purchase_Orders];"Input")
	//SET WINDOW TITLE(fNameWindow (filePtr)+" Ordering Purchase Orders")
	CREATE SET:C116(filePtr->; "CurrentSet")
	fMod:=True:C214
	iMode:=2
	SET MENU BAR:C67(<>DefaultMenu)
	FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")
	MODIFY SELECTION:C204([Purchase_Orders:11]; *)
	CLOSE WINDOW:C154($winRef)
	
Else 
	uConfirm("There are no Requisitions or POs currently requiring approval."; "OK"; "Help")
End if 
uClearSelection(->[Purchase_Orders:11])