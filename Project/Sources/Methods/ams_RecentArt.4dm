//%attributes = {"publishedWeb":true}
//PM: ams_RecentArt() -> 
//@author mlb - 7/1/02  11:34

C_DATE:C307($cutOffDate; $1)
C_TEXT:C284($0)

$0:=""
If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Finished_Goods_Specifications:98])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DateArtReceived:63>=$cutOffDate)
		CREATE SET:C116([Finished_Goods_Specifications:98]; "recentArt")
		$0:="recentArt"
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentArt")
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DateArtReceived:63>=$cutOffDate)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$0:="recentArt"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentArt")
End if 