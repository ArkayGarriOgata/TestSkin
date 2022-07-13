//%attributes = {}
// -------
// Method: Job_New_R_n_D   ( ) ->
// Description
// set up a job for obsorbing r&d cost for a year
//use in patch code file:
// ----------
// User name (OS): Mel Bohince
// Date and time: 11/03/11, 09:39:05
// ----------------------------------------------------
// Modified by: Mel Bohince (9/2/14) add sequence 10 records
// Modified by: Mel Bohince (2/13/15) remove r&d replace with caseliners and misc
// Modified by: Mel Bohince (5/13/16) add cust id to jobform
// Modified by: Mel Bohince (6/14/16) purge uses version date
// Modified by: Garri Ogata (9/2/21) Changed [Job_Forms_Items]Qty_Want from 9999999 to 0

C_LONGINT:C283(jobno; $1)
If (Count parameters:C259=1)
	jobno:=$1
Else 
	jobno:=Num:C11(Request:C163("enter the year:"; String:C10(Year of:C25(Current date:C33))))
End if 

If (jobno>=2016) & (jobno<=2101)
	CREATE RECORD:C68([Jobs:15])
	[Jobs:15]JobNo:1:=jobno
	[Jobs:15]CustID:2:="00001"
	[Jobs:15]CustomerName:5:=CUST_getName([Jobs:15]CustID:2)
	[Jobs:15]Line:3:="Case Liners and Misc"
	[Jobs:15]ProjectNumber:18:="03535"
	[Jobs:15]Status:4:="wip"
	SAVE RECORD:C53([Jobs:15])
	
	///////////////////////////////////
	
	CREATE RECORD:C68([Job_Forms:42])
	[Job_Forms:42]JobNo:2:=[Jobs:15]JobNo:1
	[Job_Forms:42]cust_id:82:="00001"
	[Job_Forms:42]FormNumber:3:=1
	[Job_Forms:42]JobFormID:5:=String:C10([Jobs:15]JobNo:1; "00000")+"."+String:C10([Job_Forms:42]FormNumber:3; "00")
	[Job_Forms:42]JobType:33:="7 Liners"
	[Job_Forms:42]ProjectNumber:56:=[Jobs:15]ProjectNumber:18
	[Job_Forms:42]ProcessSpec:46:="Case Liner"
	[Job_Forms:42]CustomerLine:62:="Case Liner"
	[Job_Forms:42]VersionDate:58:=Date:C102("01/02/"+String:C10(jobno))  // Modified by: Mel Bohince (6/14/16) purge uses version date
	SAVE RECORD:C53([Job_Forms:42])
	
	CREATE RECORD:C68([Job_Forms_Machines:43])
	[Job_Forms_Machines:43]JobForm:1:=[Job_Forms:42]JobFormID:5
	[Job_Forms_Machines:43]Sequence:5:=10
	[Job_Forms_Machines:43]CostCenterID:4:="428"
	SAVE RECORD:C53([Job_Forms_Machines:43])
	
	///////////////////////////////////
	
	CREATE RECORD:C68([Job_Forms:42])
	[Job_Forms:42]JobNo:2:=[Jobs:15]JobNo:1
	[Job_Forms:42]cust_id:82:="00001"
	[Job_Forms:42]FormNumber:3:=2
	[Job_Forms:42]JobFormID:5:=String:C10([Jobs:15]JobNo:1; "00000")+"."+String:C10([Job_Forms:42]FormNumber:3; "00")
	[Job_Forms:42]JobType:33:="8 Misc"
	[Job_Forms:42]ProjectNumber:56:=[Jobs:15]ProjectNumber:18
	[Job_Forms:42]ProcessSpec:46:="Misc"
	[Job_Forms:42]CustomerLine:62:="Misc"
	SAVE RECORD:C53([Job_Forms:42])
	
	CREATE RECORD:C68([Job_Forms_Machines:43])
	[Job_Forms_Machines:43]JobForm:1:=[Job_Forms:42]JobFormID:5
	[Job_Forms_Machines:43]Sequence:5:=10
	[Job_Forms_Machines:43]CostCenterID:4:="428"
	SAVE RECORD:C53([Job_Forms_Machines:43])
	
	// Modified by: Mel Bohince (9/20/17) 
	If (False:C215)
		$gluers:=<>GLUERS
	End if 
	
	READ WRITE:C146([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3="Prevent.Maint.")
	APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39:=Current date:C33)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
	READ ONLY:C145([Cost_Centers:27])
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]Description:3="Gluer@")
	SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $aGluers)
	REDUCE SELECTION:C351([Cost_Centers:27]; 0)
	SORT ARRAY:C229($aGluers; >)
	
	For ($i; 1; Size of array:C274($aGluers))
		CREATE RECORD:C68([Job_Forms_Items:44])
		[Job_Forms_Items:44]JobForm:1:=[Job_Forms:42]JobFormID:5
		[Job_Forms_Items:44]ItemNumber:7:=$i
		[Job_Forms_Items:44]Jobit:4:=JMI_makeJobIt([Job_Forms_Items:44]JobForm:1; [Job_Forms_Items:44]ItemNumber:7)
		[Job_Forms_Items:44]Gluer:47:=$aGluers{$i}
		[Job_Forms_Items:44]ProductCode:3:="Prevent.Maint."
		[Job_Forms_Items:44]Qty_Actual:11:=0
		[Job_Forms_Items:44]ModDate:29:=Current date:C33
		[Job_Forms_Items:44]ModWho:30:=<>zResp
		[Job_Forms_Items:44]PlnnrWho:34:="ams"
		[Job_Forms_Items:44]PlnnrDate:35:=[Job_Forms_Items:44]ModDate:29
		[Job_Forms_Items:44]OrderItem:2:="PV"
		[Job_Forms_Items:44]CustId:15:="00001"
		[Job_Forms_Items:44]MAD:37:=Add to date:C393(Current date:C33; 0; 0; 5)
		[Job_Forms_Items:44]GlueRate:52:=8
		//[Job_Forms_Items]Qty_Want:=9999999
		[Job_Forms_Items:44]Qty_Want:24:=0
		SAVE RECORD:C53([Job_Forms_Items:44])
	End for 
	
	///////////////////////////////////
	
	REDUCE SELECTION:C351([Jobs:15]; 0)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
End if 