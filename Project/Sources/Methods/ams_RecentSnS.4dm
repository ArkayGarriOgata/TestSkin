//%attributes = {}
// -------
// Method: ams_RecentSnS   ( ) ->
// By: Mel Bohince @ 06/14/16, 12:55:02
// Description
// 
// ----------------------------------------------------

C_DATE:C307($cutOffDate; $1)
C_TEXT:C284($0)

$0:=""
If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateCreated:3>=$cutOffDate)
		CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "recentSnS")
		$0:="recentSnS"
		REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentSnS")
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateCreated:3>=$cutOffDate)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$0:="recentSnS"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentSnS")
End if 