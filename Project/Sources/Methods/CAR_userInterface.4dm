//%attributes = {"publishedWeb":true}
//PM: CAR_userInterface() -> 
//@author mlb - 7/19/01  11:18
//DJC - 05-05-05
//DJC - 5-16-05
// • mel (6/13/05, 17:17:10) fixed pass thru condition via ebag
// Modified by: Mel Bohince (3/31/21) moved the readonly's from the form method to here, added a couple

READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers:16])
READ ONLY:C145([QA_Corrective_ActionsLocations:107])
READ ONLY:C145([Cost_Centers:27])  // Modified by: Mel Bohince (3/31/21) 
READ ONLY:C145([Finished_Goods_Classifications:45])  // Modified by: Mel Bohince (3/31/21) 
READ ONLY:C145([Salesmen:32])  // Modified by: Mel Bohince (3/31/21)

vAskMePID:=0
fAdHoc:=False:C215  //flag for entry screens, 3/24/95
uSetUp(1; 1)
gClearFlags
C_LONGINT:C283(iJMLTabs)
iJMLTabs:=0

fMod:=True:C214
If (<>iMode=3)
	iMode:=3
	READ ONLY:C145(FilePtr->)
Else 
	iMode:=2
	READ WRITE:C146(filePtr->)
End if 

FORM SET INPUT:C55([QA_Corrective_Actions:105]; "Input")
FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "List")

If (<>PassThrough)  //upr 155 2/2/95
	<>PassThrough:=False:C215
	USE SET:C118("◊PassThroughSet")
	NumRecs1:=Records in selection:C76(filePtr->)
	CLEAR SET:C117("◊PassThroughSet")
	//CREATE SET(filePtr->;"◊LastSelection"+String(fileNum))
	//ORDER BY([CorrectiveAction];[CorrectiveAction]RequestNumber;>)
	OK:=1
	lastTab:=7
	b3:=1
	CAR_setView(1; ->[QA_Corrective_Actions:105]FGKey:8)  //Tab 1 RGA is gone need code below to replicate
	//QUERY([CorrectiveAction];[CorrectiveAction]RGA#"")
	//ORDER BY([CorrectiveAction];[CorrectiveAction]FGKey;<)
	
Else   //DJC - 05-05-05
	//as per Angela Simmons default will be USERS CARs
	
	//If (User in group(Current user;"RoleQA"))
	//QUERY([CorrectiveAction];[CorrectiveAction]RGA#"")
	//QUERY([CorrectiveAction];[CorrectiveAction]CAwho="")
	//CAR_setView (3;->[CorrectiveAction]RequestNumber)  `changed 1st parm from 2 to 3
	//Else   `default is users recs that are OPEN
	QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]Author:3=<>zResp; *)
	QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]ApprovalQAMgr:21="")
	
	CAR_setView(1; ->[QA_Corrective_Actions:105]DateCreated:2)
	//ALL RECORDS([CorrectiveAction])
	//CAR_setView (6;->[CorrectiveAction]RequestNumber)
	//End if 
End if 
windowTitle:=fNameWindow(filePtr)+" Modifying records"
$winRef:=OpenFormWindow(->[QA_Corrective_Actions:105]; "Input"; ->windowTitle; windowTitle)
//NewWindow (640;560;2;8;fNameWindow (filePtr)+" Modifying records";"wCloseWinBox")  `DJC - chg 2nd parm frm 530 to 560 5-16-05 

bdone:=0

Repeat 
	MODIFY SELECTION:C204(filePtr->; *)
	bModMany:=False:C215  //may also be set by Done button  
Until (bdone=1)

CLOSE WINDOW:C154
uSetUp(0; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)  //•031397  mBohince  
REDUCE SELECTION:C351([QA_Corrective_Actions:105]; 0)
REDUCE SELECTION:C351([QA_Corrective_ActionsLocations:107]; 0)
REDUCE SELECTION:C351([QA_Corrective_ActionsReason:106]; 0)