//%attributes = {}
//Method:  Qury_BuildT(cQueryOrderBy)=>tQueryOrderBy
//Description: This method will build a query statement

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cQueryOrderBy)
	C_TEXT:C284($0; $tQueryOrderBy)
	
	C_COLLECTION:C1488($cQuery; $cQueryOrderBy)
	C_COLLECTION:C1488($cOrderBy)
	
	C_OBJECT:C1216($oParameter)
	
	C_LONGINT:C283($nQuery)
	C_BOOLEAN:C305($bAddOrderBy)
	
	C_TEXT:C284($tOrderBy; $tParameter; $tQuery)
	
	$cQueryOrderBy:=$1
	
	$tOrderBy:=CorektBlank
	$tParameter:=CorektBlank
	$tQuery:=CorektBlank
	
	$nQuery:=0
	$bAddOrderBy:=True:C214
	
End if   //Done initialize

$cQuery:=$cQueryOrderBy.extract("Query")

For each ($tParameter; $cQuery)  //Query
	
	$nQuery:=$nQuery+1
	$tQuery:=$tQuery+$tParameter+" = :"+String:C10($nQuery)+CorektSpace+"&"+CorektSpace
	
End for each   //Done query

If ($nQuery>0)
	$tQuery:=Substring:C12($tQuery; 1; Length:C16($tQuery)-3)
End if 

$cOrderBy:=$cQueryOrderBy.extract("OrderBy")

For each ($tParameter; $cOrderBy)  //Order by
	
	If ($bAddOrderBy)  //Add
		
		$tOrderBy:=" order by "
		$bAddOrderBy:=False:C215
		
	End if   //Done add
	
	$tOrderBy:=$tOrderBy+$tParameter+CorektComma
	
End for each   //Done order by

If (Not:C34($bAddOrderBy))  //Remove comma
	$tOrderBy:=Substring:C12($tOrderBy; 1; Length:C16($tOrderBy)-1)
End if   //Done remove comma

$tQueryOrderBy:=$tQuery+$tOrderBy

$0:=$tQueryOrderBy