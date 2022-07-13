//%attributes = {}
// ----------------------------------------------------
// User name (OS): PJK
// Date and time: 18/08/25, 
// ----------------------------------------------------
// Method: Job_Die_BoardInv
// ----------------------------------------------------

// Modified by: Mel Bohince (5/16/19) retain last label printer name in <>lastPickedPrinterName

C_LONGINT:C283($winRef; fileNum)
C_POINTER:C301(filePtr)
C_TEXT:C284($1; sFile)
C_OBJECT:C1216(<>lastPickedPrinter)
C_OBJECT:C1216(<>resetToPrinter)


If (Count parameters:C259=0)
	$xlPID:=Process number:C372("Die Board Inventory")
	If ($xlPID=0)
		$xlPID:=uSpawnProcess("Job_Die_BoardInv"; <>lMidMemPart; "Die Board Inventory"; False:C215; False:C215; "init")
		If (False:C215)
			Job_Die_BoardInv
		End if 
		
	Else 
		SHOW PROCESS:C325($xlPID)
		BRING TO FRONT:C326($xlPID)
		POST OUTSIDE CALL:C329($xlPID)
	End if 
	
Else 
	fileNum:=Table:C252(->[Job_DieBoard_Inv:168])
	filePtr:=Table:C252(fileNum)
	sFile:=Table name:C256(filePtr)
	printMenuSupported:=True:C214
	SET MENU BAR:C67(<>DefaultMenu)
	
	ARRAY INTEGER:C220($aFieldNums; 0)  //•090195  MLB      
	COPY ARRAY:C226(<>aSlctFF{Table:C252(filePtr)}; $aFieldNums)  //aSlctField  
	
	ARRAY POINTER:C280(aSlctField; 0)
	ARRAY POINTER:C280(aSlctField; 6)  // for backward compatiblity
	ARRAY TEXT:C222(aSelectBy; 0)
	ARRAY TEXT:C222(aSelectBy; 13)
	
	windowTitle:=" Die Board Inventory"
	OK:=1
	$winRef:=OpenFormWindow(filePtr; "DieBoardInventory"; ->windowTitle)
	DIALOG:C40(filePtr->; "DieBoardInventory")
	CLOSE WINDOW:C154($winRef)
	
End if 