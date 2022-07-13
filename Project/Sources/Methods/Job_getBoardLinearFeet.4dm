//%attributes = {}
// -------
// Method: Job_getBoardLinearFeet   (jobform ) ->
// By: Mel Bohince @ 11/09/17, 14:39:48
// Description
// return the linear feet budgeted
// ----------------------------------------------------
C_TEXT:C284($1)

READ ONLY:C145([Job_Forms_Materials:55])

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="01@")
If (Records in selection:C76([Job_Forms_Materials:55])>0)
	If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
		//t7:=[Job_Forms_Materials]Raw_Matl_Code
		If (Position:C15("LF"; [Job_Forms_Materials:55]UOM:5)#0)
			$0:=[Job_Forms_Materials:55]Planned_Qty:6
		Else 
			$0:=2
		End if 
	Else 
		$0:=1
	End if 
Else 
	$0:=0
End if 

UNLOAD RECORD:C212([Job_Forms_Materials:55])