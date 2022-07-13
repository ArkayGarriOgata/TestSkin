//%attributes = {"executedOnServer":true}
// Method: fg_setClosingDeadline () -> 
// ----------------------------------------------------
// by: mel: 11/18/04, 13:49:06
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
//correct bug last release 03-28-2019
// Modified by: Mel Bohince (5/5/21) set execute on server property

C_LONGINT:C283($i)
READ WRITE:C146([Finished_Goods:26])
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OriginalOrRepeat:71="Original")
While (Not:C34(End selection:C36([Finished_Goods:26])))
	//If (Not(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) query selection
	
	//$i:=JML_findJobByFG ([Finished_Goods]ProductCode)
	//QUERY SELECTION([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]GateWayDeadLine#!00-00-00!)
	
	//Else 
	
	
	//zwStatusMsg ("Relating";" Searching "+Table name(->[Job_Forms_Master_Schedule])+" file. Please Wait...")
	
	QUERY BY FORMULA:C48([Job_Forms_Master_Schedule:67]; \
		([Job_Forms_Items:44]JobForm:1="@")\
		 & ([Job_Forms_Items:44]ProductCode:3=[Finished_Goods:26]ProductCode:1)\
		 & ([Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Items:44]JobForm:1)\
		 & ([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)\
		 & ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42#!00-00-00!)\
		)
	
	
	//zwStatusMsg ("";"")
	
	//End if   // END 4D Professional Services : January 2019 
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42; >)
		[Finished_Goods:26]DateClosing:92:=[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
		
	Else 
		[Finished_Goods:26]DateClosing:92:=!00-00-00!
	End if 
	SAVE RECORD:C53([Finished_Goods:26])
	NEXT RECORD:C51([Finished_Goods:26])
End while 
REDUCE SELECTION:C351([Finished_Goods:26]; 0)