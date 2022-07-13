//%attributes = {"publishedWeb":true}
//(p) ReqRevRec
//`• 6/10/97 cs  upr 1872 based on DoRevRecord
// Modified by: Mel Bohince (6/30/16) chg sort field

C_TEXT:C284($1)

fAdHoc:=False:C215  //flag for entry screens, 3/24/95

uSetUp(1; 1)
FORM SET INPUT:C55([Purchase_Orders:11]; <>sReqName)
FORM SET OUTPUT:C54([Purchase_Orders:11]; "ReqList")
gClearFlags
sFile:=<>sReqName
CREATE SET:C116(filePtr->; "CurrentSet")
fRev:=True:C214
READ ONLY:C145(filePtr->)
windowTitle:=" Reviewing records"
$winRef:=OpenFormWindow(filePtr; "Requisitions"; ->windowTitle)
gR_ReadRelated(->[Purchase_Orders_Items:12]; ->[Purchase_Orders_Chg_Orders:13])

If (<>PassThrough)
	USE SET:C118("◊PassThroughSet")
	NumRecs1:=Records in selection:C76(filePtr->)
	CLEAR SET:C117("◊PassThroughSet")
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	CREATE SET:C116(filePtr->; "CurrentSet")
	<>PassThrough:=False:C215
	ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1; <)  // Modified by: Mel Bohince (6/30/16) 
	zwStatusMsg("REQUISITIONS"; "Sorted PO Date, use AdHoc Sort to change.")
Else 
	NumRecs1:=fSelectBy(Get last table number:C254+1)  //generic search equal or range on any four fields  
End if 

If (OK=1)  //perform search
	Repeat 
		iMode:=3  //review
		CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
		$Title:=fNameWindow(FilePtr)
		$Title:=Replace string:C233($Title; "Purchase_Order"; <>sReqName)
		If (Count parameters:C259=1)
			SET WINDOW TITLE:C213($Title+" Reviewing records, reqBy = "+$1)
		Else 
			SET WINDOW TITLE:C213($Title+" Reviewing records")
		End if 
		bModMany:=True:C214
		DISPLAY SELECTION:C59(filePtr->; *)
		bModMany:=False:C215
	Until (bdone=1)
End if 

CLOSE WINDOW:C154
uSetUp(0; 0)
uWinListCleanup
uClearSelection(->[Purchase_Orders_Items:12])
uClearSelection(->[Purchase_Orders:11])