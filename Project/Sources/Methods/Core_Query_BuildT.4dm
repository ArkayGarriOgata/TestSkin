//%attributes = {}
//Method:  Core_Query_BuildT(cQueryOrderBy)=>tQueryOrderBy
//Description: This method will build a query statement
//Example:

//.   C_COLLECTION($cQuery)

//.   $tEqual:="="
//.   $tGreater:=">"
//.   $cQuery:=New collection()
//.   $cQuery.push(New object("Query";"FirstName";"Equality";$tEqual;"Value";"J@";"Conjunction";"&"))
//.   $cQuery.push(New object("Query";"LastName";"Equality";$tGreater;"Value";"J@"))
//.   $cQuery.push(New object("OrderBy";"LastName"))

//.   $tQuery:=Core_Query_BuildT ($cQuery)
//.   ds.Table.query($tQuery)

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cQueryOrderBy)
	C_TEXT:C284($0; $tQueryOrderBy)
	
	C_OBJECT:C1216($oQueryOrderByLine)
	
	C_BOOLEAN:C305($bAddOrderBy)
	
	C_TEXT:C284($tOrderBy; $tQuery)
	C_TEXT:C284($tDate)
	
	$cQueryOrderBy:=$1
	
	$bAddOrderBy:=True:C214
	$tOrderBy:=CorektBlank
	
	$tQuery:=CorektBlank
	$tDate:=CorektBlank
	
End if   //Done initialize

For each ($oQueryOrderByLine; $cQueryOrderBy)  //Query order by line
	
	If (OB Is defined:C1231($oQueryOrderByLine; "Query"))  //Query
		
		$tQuery:=$tQuery+OB Get:C1224($oQueryOrderByLine; "Query")
		
	End if   //Done query
	
	If (OB Is defined:C1231($oQueryOrderByLine; "Equality"))  //Equality
		
		$tQuery:=$tQuery+OB Get:C1224($oQueryOrderByLine; "Equality")
		
	End if   //Done equality
	
	If (OB Is defined:C1231($oQueryOrderByLine; "Value"))  //Value
		
		$nValueType:=OB Get type:C1230($oQueryOrderByLine; "Value")
		
		Case of   //Value type
			: (($nValueType=Is text:K8:3) | ($nValueType=Is alpha field:K8:1))
				
				If (OB Get:C1224($oQueryOrderByLine; "Value")="MyVar")
					
					$tValue:=(Get pointer:C304("MyVar"))->
					
					$tQuery:=$tQuery+CorektSingleQuote+$tValue+CorektSingleQuote
					
				Else 
					
					$tQuery:=$tQuery+CorektSingleQuote+OB Get:C1224($oQueryOrderByLine; "Value")+CorektSingleQuote
					
				End if 
				
			: (($nValueType=Is real:K8:4) | ($nValueType=Is longint:K8:6) | ($nValueType=_o_Is float:K8:26))
				
				$tQuery:=$tQuery+String:C10(OB Get:C1224($oQueryOrderByLine; "Value"))
				
			: ($nValueType=Is date:K8:7)
				
				$tDate:=String:C10(OB Get:C1224($oQueryOrderByLine; "Value"); ISO date GMT:K1:10)
				$tDate:=Substring:C12($tDate; 1; Position:C15("T"; $tDate)-1)
				
				$tQuery:=$tQuery+$tDate
				
		End case   //Done value type
		
	End if   //Done value
	
	If (OB Is defined:C1231($oQueryOrderByLine; "Conjunction"))  //Conjunction
		
		$tQuery:=$tQuery+CorektSpace+OB Get:C1224($oQueryOrderByLine; "Conjunction")+CorektSpace
		
	End if   //Done conjunction
	
	If (OB Is defined:C1231($oQueryOrderByLine; "OrderBy"))  //Order by
		
		If ($bAddOrderBy)  //Add order by
			
			$tOrderBy:=CorektSpace+"order by"+CorektSpace
			$bAddOrderBy:=False:C215
			
		End if   //Done add order by
		
		$tOrderBy:=$tOrderBy+OB Get:C1224($oQueryOrderByLine; "OrderBy")+CorektComma+CorektSpace
		
	End if   //Done order by
	
End for each   //Done query order by line

If (Not:C34($bAddOrderBy))  //Remove comma space
	$tOrderBy:=Substring:C12($tOrderBy; 1; Length:C16($tOrderBy)-2)
End if   //Done remove comma space

$tQueryOrderBy:=$tQuery+$tOrderBy

$0:=$tQueryOrderBy