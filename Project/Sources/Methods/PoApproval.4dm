//%attributes = {"publishedWeb":true}
//(p) PoApproval 
//• 5/30/97 cs created.
//• cs 9/9/97
//•082499  mlb  

C_BOOLEAN:C305(fApproving; fOrdering)

FilePtr:=->[Purchase_Orders:11]
zDefFilePtr:=->[Purchase_Orders:11]  //• cs 9/9/97 added so that adhoc menus function
FileNum:=Table:C252(FilePtr)
sFile:=Table name:C256(FilePtr)  //•082499  mlb  
fAdHoc:=False:C215  //•082499  mlb
fOrdering:=False:C215

gClearFlags
SET MENU BAR:C67(<>DefaultMenu)

If (POLocate4Apprv>0)  //if there are POs to Approve
	fApproving:=True:C214
	fChoose:=False:C215
	sPOAction:="Mod"
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(FileNum))
	windowTitle:=fNameWindow(filePtr)+" Approving Purchase Orders"
	$winRef:=OpenFormWindow(->[Purchase_Orders:11]; "Input"; ->windowTitle)
	CREATE SET:C116(filePtr->; "CurrentSet")
	fMod:=True:C214
	iMode:=2
	FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")
	MODIFY SELECTION:C204([Purchase_Orders:11]; *)
	CLOSE WINDOW:C154($winRef)
	fApproving:=False:C215
Else 
	BEEP:C151
	uConfirm("There are no Requisitions or POs currently requiring approval."; "OK"; "Help")
End if 
uClearSelection(->[Purchase_Orders:11])