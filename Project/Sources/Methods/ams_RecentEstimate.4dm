//%attributes = {"publishedWeb":true}
//PM: ams_RecentEstimate() -> 
//@author mlb - 7/1/02  10:32

C_DATE:C307($cutOffDate; $1)
C_TEXT:C284($0)

$0:=""

If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Estimates:17])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Estimates:17]; [Estimates:17]DateOriginated:19>=$cutOffDate)
		CREATE SET:C116([Estimates:17]; "recentEstimate")
		$0:="recentEstimate"
		REDUCE SELECTION:C351([Estimates:17]; 0)
		
	Else 
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentEstimate")
		QUERY:C277([Estimates:17]; [Estimates:17]DateOriginated:19>=$cutOffDate)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		$0:="recentEstimate"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentEstimate")
End if 