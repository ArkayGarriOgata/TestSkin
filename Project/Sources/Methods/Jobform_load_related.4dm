//%attributes = {"publishedWeb":true}
//(P) Jobform_load_related
//upr 1339 12/9/94
// Modified by: Mel Bohince (4/17/14) move sorts to pages tab script
// Modified by: Mel Bohince (1/14/20) add Closing date from JML

C_TEXT:C284($1)

If (Count parameters:C259>0)  //else use current jobform record
	If ([Job_Forms:42]JobFormID:5#$1)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
	End if 
End if 

zwStatusMsg("Load Related"; "project")
MESSAGES OFF:C175
QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Job_Forms:42]ProjectNumber:56)

zwStatusMsg("Load Related"; "relate many")
RELATE MANY:C262([Job_Forms:42]JobFormID:5)

zwStatusMsg("Load Related"; "sort jFI")
ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >; [Job_Forms_Items:44]SubFormNumber:32; >)
COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "Jobits")

// Modified by: Mel Bohince (1/14/20) add Closing date from JML
C_DATE:C307(dDate)
C_OBJECT:C1216($entSel)
$entSel:=ds:C1482.Job_Forms_Master_Schedule.query("JobForm = :1"; [Job_Forms:42]JobFormID:5)
If ($entSel.length>0)
	dDate:=$entSel.first().GateWayDeadLine
Else 
	dDate:=!00-00-00!
End if 



//ORDER BY([Job_Forms_Machines];[Job_Forms_Machines]Sequence;>)
//COPY NAMED SELECTION([Job_Forms_Machines];"machines")

//zwStatusMsg ("Load Related";"sort JFM")
//ORDER BY([Job_Forms_Materials];[Job_Forms_Materials]Sequence;>)
//COPY NAMED SELECTION([Job_Forms_Materials];"Related")
//MakeArrayJFMaterials ("Get")  // Added by: Mark Zinke (10/2/13) 

//zwStatusMsg ("Load Related";"sort MT")
//ORDER BY([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]Sequence;>;[Job_Forms_Machine_Tickets]CostCenterID;>;[Job_Forms_Machine_Tickets]DateEntered;>)
//COPY NAMED SELECTION([Job_Forms_Machine_Tickets];"machTicks")

//zwStatusMsg ("Load Related";"rmx")
//QUERY SELECTION([Raw_Materials_Transactions];[Raw_Materials_Transactions]Xfer_Type="Issue")
//ORDER BY([Raw_Materials_Transactions];[Raw_Materials_Transactions]Commodity_Key;>;[Raw_Materials_Transactions]XferDate;>)
//COPY NAMED SELECTION([Raw_Materials_Transactions];"rmXfers")

//zwStatusMsg ("Load Related";"ms")
//COPY NAMED SELECTION([Job_Forms_Master_Schedule];"Master_Schedule")

zwStatusMsg("Load Related"; "fini")