//%attributes = {"publishedWeb":true}
//PM: ams_RecentRMxfers() -> 
//@author mlb - 7/3/02  12:13

C_DATE:C307($cutOffDate; $1)
C_TEXT:C284($0)

$0:=""

If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Raw_Materials_Transactions:23])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=$cutOffDate; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
		CREATE SET:C116([Raw_Materials_Transactions:23]; "recentXfers")
		$0:="recentXfers"
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentXfers")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=$cutOffDate; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$0:="recentXfers"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentXfers")
End if 