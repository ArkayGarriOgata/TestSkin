//%attributes = {}
// -------
// Method: Job_is_Wrap   ( ) ->
// By: Mel Bohince @ 03/21/18, 08:32:54
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1; $0)

READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Raw_Materials:21])

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="01@")
If (Records in selection:C76([Job_Forms_Materials:55])>0)
	If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
		If (Records in selection:C76([Raw_Materials:21])>0)
			If (([Raw_Materials:21]Flex1:19>=80) & ([Raw_Materials:21]Flex1:19<=100))
				$0:="Wrap"
			Else 
				$0:="No"
			End if 
		Else 
			$0:="N/F"
		End if 
	Else 
		$0:="N/S"
	End if 
Else 
	$0:="N/B"
End if 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Job_Forms_Materials:55])
	UNLOAD RECORD:C212([Raw_Materials:21])
	
Else 
	
	//you have read only mode
	
End if   // END 4D Professional Services : January 2019 
