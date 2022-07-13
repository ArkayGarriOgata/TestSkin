<>USE_SUBCOMPONENT:=True:C214
$fg_code:=Request:C163("What is the FG subcomponent code:"; ""; "OK"; "Cancel")  //
If (OK=1)
	READ ONLY:C145([Finished_Goods:26])
	$numFG:=qryFinishedGood("#CPN"; $fg_code)
	If ($numFG=1)
		CREATE RECORD:C68([Estimates_Materials:29])
		[Estimates_Materials:29]EstimateNo:5:=[Estimates:17]EstimateNo:1
		[Estimates_Materials:29]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
		[Estimates_Materials:29]Commodity_Key:6:="33-SubComponentFG"
		[Estimates_Materials:29]Raw_Matl_Code:4:=$fg_code
		[Estimates_Materials:29]RMName:10:=[Finished_Goods:26]CartonDesc:3
		[Estimates_Materials:29]EstimateType:7:="Prod"
		[Estimates_Materials:29]UOM:8:="EACH"
		[Estimates_Materials:29]Real1:14:=1
		[Estimates_Materials:29]Real2:15:=0
		SAVE RECORD:C53([Estimates_Materials:29])
		
		UNLOAD RECORD:C212([Finished_Goods:26])
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
		[Estimates:17]JobType:29:="3 ASSEMBLY"  // Modified by: Mel Bohince (3/6/17) 
		[Estimates_DifferentialsForms:47]JobType:9:="3 ASSEMBLY"
	End if 
End if 