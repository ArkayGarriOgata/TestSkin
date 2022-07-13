//%attributes = {}
// -------
// Method: Job_getBoardWidth   ( ) ->
// By: Mel Bohince @ 11/09/17, 14:46:22
// Description
// rm width
// ----------------------------------------------------
C_TEXT:C284($1)
C_REAL:C285($0)

READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Raw_Materials:21])

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="01@")
If (Records in selection:C76([Job_Forms_Materials:55])>0)
	If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
		If (Records in selection:C76([Raw_Materials:21])>0)
			$0:=[Raw_Materials:21]Flex2:20
		Else 
			$0:=2
		End if 
	Else 
		$0:=1
	End if 
Else 
	$0:=0
End if 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Job_Forms_Materials:55])
	UNLOAD RECORD:C212([Raw_Materials:21])
	
Else 
	
	// you have read only mode
	
End if   // END 4D Professional Services : January 2019 
