//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): mBohince
// Date: 031397
// ----------------------------------------------------
// Method: uSetUp
// ----------------------------------------------------

C_LONGINT:C283($1; $2)  //uSetUp(on|off;{})
C_LONGINT:C283(fileNum; iTabControl; iTabControlSub; iJMLTabs; iFGtab; iInvoiceTabs; vAskMePID)
C_POINTER:C301(filePtr)
C_BOOLEAN:C305(testRestrictions)
C_BOOLEAN:C305(cancelLineItemInputForm)  //Used by gDisplayPV

testRestrictions:=False:C215
fAdHoc:=False:C215
fAdHocLocal:=True:C214

//gClearFlags 
If ($1=1)  //on
	vAskMePID:=0
	iMode:=<>iMode
	filePtr:=<>filePtr
	zDefFilePtr:=filePtr
	SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
	sFile:=Table name:C256(filePtr)
	fileNum:=Table:C252(filePtr)
	
	FORM SET INPUT:C55(fileptr->; "Input")  //insure 
	FORM SET OUTPUT:C54(fileptr->; "List")  //insure that 'list' is always selected
	CREATE SET:C116(filePtr->; "CurrentSet")
	//
	Case of 
		: (filePtr=(->[Job_Forms_Master_Schedule:67]))
			FORM SET OUTPUT:C54([Job_Forms_Master_Schedule:67]; "List")
			
			C_OBJECT:C1216($oNameColor)
			$oNameColor:=New object:C1471()
			$oNameColor:=Cust_Name_ColorO()
			
		: (filePtr=(->[Customers_Order_Lines:41]))
			cancelLineItemInputForm:=False:C215
			
		: (filePtr=(->[Purchase_Orders_Requisitions:80]))
			<>filePtr:=->[Purchase_Orders:11]  //switch to real table
			filePtr:=<>filePtr
			sFile:="Requisitions"
			fileNum:=Table:C252(filePtr)
			FORM SET INPUT:C55(fileptr->; "Requisitions")  //insure 
			FORM SET OUTPUT:C54(fileptr->; "ReqList")  //insure that 'list' is always selected
	End case 
	
Else   //off
	If (<>plsHold)  //wait until a child process finishes
		<>lastNew:=Record number:C243(filePtr->)
		<>plsHold:=False:C215
	End if 
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		UNLOAD RECORD:C212(filePtr->)
		REDUCE SELECTION:C351(filePtr->; 0)  //•031397  mBohince  
		
		
	Else 
		
		REDUCE SELECTION:C351(filePtr->; 0)  //•031397  mBohince  
		
		
	End if   // END 4D Professional Services : January 2019 
	iMode:=0
	iTabControl:=0
	iTabControlSub:=0
	iJMLTabs:=0
	iFGtab:=0
	iInvoiceTabs:=0
	SET WINDOW TITLE:C213(fNameWindow(filePtr))
End if 

uWinListCleanup