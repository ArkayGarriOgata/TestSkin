//%attributes = {}
// ----------------------------------------------------
// Method: FG_getCaseCount   ( custid;product code {;shipping qty}) ->
// By: Mel Bohince @ 04/22/16, 09:13:27
// Description
// get the case count from the pak spec, 
// combines the old steps of using qryFinishedGood, then PK_getCaseCount, or
// PK_getCaseCount(FG_getOutline(CPN))  
// ----------------------------------------------------

$i:=qryFinishedGood($1; $2)
If ($i>0)
	$caseCnt:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
	
Else 
	$caseCnt:=0
End if 

If (Count parameters:C259>2)  //shipping quantity supplied
	If ($caseCnt>0)
		$numberOfCases:=Int:C8($3/$caseCnt)
		$evenLot:=$numberOfCases*$caseCnt
		If ($3#$evenLot)
			$0:=$3*-1
		Else 
			$0:=$3
		End if 
		
	Else   //unspecified case count
		$0:=0
	End if 
	
Else   //2 params, just send the case count
	$0:=$caseCnt
End if 