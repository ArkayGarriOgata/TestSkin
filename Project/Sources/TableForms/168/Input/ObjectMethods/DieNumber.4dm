// _______
// Method: [Job_DieBoard_Inv].Input.DieNumber   ( ) ->
// By: Mel Bohince @ 05/21/19, 12:13:28
// Description
// 
// ----------------------------------------------------

If (Length:C16([Job_DieBoard_Inv:168]DieNumber:3)=8)
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_DieBoard_Inv:168]DieNumber:3)
	
	
	[Job_DieBoard_Inv:168]CustomerCode:12:=[Job_Forms:42]cust_id:82
	[Job_DieBoard_Inv:168]Customer:2:=CUST_getName([Job_DieBoard_Inv:168]CustomerCode:12; "elc")
	[Job_DieBoard_Inv:168]UpNumber:5:=[Job_Forms:42]NumberUp:26
	[Job_DieBoard_Inv:168]OutlineNumber:4:=Job_getDieIdentifier([Job_DieBoard_Inv:168]DieNumber:3)  //[Job_Forms]OutlineNumber//
	[Job_DieBoard_Inv:168]DateEntered:6:=4D_Current_date
	[Job_DieBoard_Inv:168]Type:7:=""
	[Job_DieBoard_Inv:168]DieOrientation:15:=""
	[Job_DieBoard_Inv:168]MaxImpressions:11:=100000
	[Job_DieBoard_Inv:168]Impressions:14:=0
	[Job_DieBoard_Inv:168]DateLastUsed:13:=!00-00-00!
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	
	GOTO OBJECT:C206([Job_DieBoard_Inv:168]Type:7)
	
Else   //leave empty slot
	[Job_DieBoard_Inv:168]CustomerCode:12:=""
	[Job_DieBoard_Inv:168]Customer:2:="AVAILABLE"
	[Job_DieBoard_Inv:168]UpNumber:5:=0
	[Job_DieBoard_Inv:168]OutlineNumber:4:=""
	[Job_DieBoard_Inv:168]DateEntered:6:=!00-00-00!
	[Job_DieBoard_Inv:168]Type:7:=""
	[Job_DieBoard_Inv:168]MaxImpressions:11:=0
	[Job_DieBoard_Inv:168]Impressions:14:=0
	[Job_DieBoard_Inv:168]DateLastUsed:13:=!00-00-00!
	[Job_DieBoard_Inv:168]DieOrientation:15:=""
End if 
