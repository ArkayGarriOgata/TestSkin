//%attributes = {"publishedWeb":true}
//(p) ReqModRec
//because I need an entry into POs which looks like an entry into a
//requisition system
//• 6/5/97 cs created
//$1 - string (optional) - flag, do NOT use 'Modifiy Record' if one in selection
// Modified by: Mel Bohince (2/23/15) chg sort order per brian
// Modified by: Mel Bohince (4/8/15) Sabine likes the old sort, so test user's group

fAdHoc:=False:C215  //flag for entry screens, 3/24/95
uSetUp(1; 1)
FORM SET INPUT:C55([Purchase_Orders:11]; <>sReqName)
FORM SET OUTPUT:C54([Purchase_Orders:11]; "ReqList")
sFile:=<>sReqName
gClearFlags

fMod:=True:C214
iMode:=2
READ WRITE:C146(filePtr->)

windowTitle:=" Modifying records"
$winRef:=OpenFormWindow(filePtr; "Requisitions"; ->windowTitle)

If (<>PassThrough)
	USE SET:C118("◊PassThroughSet")
	NumRecs1:=Records in selection:C76(filePtr->)
	CLEAR SET:C117("◊PassThroughSet")
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	CREATE SET:C116(filePtr->; "CurrentSet")
	<>PassThrough:=False:C215
	//
	
	If (User in group:C338(Current user:C182; "RoleManagementTeam"))  // Modified by: Mel Bohince (4/8/15) Sabine likes the old sort
		// Modified by: Mel Bohince (2/23/15) chg sort order per brian, recent at the top
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PODate:4; <; [Purchase_Orders:11]VendorName:42; >; [Purchase_Orders:11]ReqNo:5; >)
	Else   //original way
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]VendorName:42; >; [Purchase_Orders:11]ReqNo:5; >)
	End if 
	
	zwStatusMsg("REQUISITIONS"; "Sorted by Vendor then Req Nº, use AdHoc Sort to change.")
	OK:=1
Else 
	NumRecs1:=fSelectBy(Get last table number:C254+1)
End if 

If (OK=1)  //perform search
	Repeat 
		CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
		$Title:=fNameWindow(FilePtr)
		$Title:=Replace string:C233($Title; "Purchase_Order"; <>sReqName)
		If (Count parameters:C259=1)
			SET WINDOW TITLE:C213($Title+"   with Status = "+$1)
		Else 
			SET WINDOW TITLE:C213($Title+" Modifying records")
		End if 
		If (NumRecs1=1) & (Count parameters:C259=0)  //call requires listing, not one record
			MODIFY RECORD:C57(filePtr->; *)
			bDone:=1
		Else 
			bModMany:=True:C214
			MODIFY SELECTION:C204(filePtr->; *)
			bModMany:=False:C215
		End if 
	Until (bdone=1)
End if   //ok search

CLOSE WINDOW:C154
uSetUp(0; 0)
uClearSelection(->[Purchase_Orders_Items:12])
uWinListCleanup