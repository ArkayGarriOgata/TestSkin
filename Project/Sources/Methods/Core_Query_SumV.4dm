//%attributes = {}
//Method:  Core_Query_SumV(tQuery;pFieldToSum)=>vSum
//Description:  This method will execute query based on the table in pFieldToSum and then Sum pFieldToSum

//Note:  $rSum:=Core_Query_SumV("Attribute = 1234";->[Table]Price) and
//       $nSum:=Core_Query_SumV("Attribute = 1234";->[Table]Quantity)
//              works compiled type casting is automagically done with variant

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tQuery)
	C_POINTER:C301($2; $pFieldToSum)
	C_VARIANT:C1683($0; $vSum)
	
	C_OBJECT:C1216($esTableSum)
	
	C_TEXT:C284($tFieldToSum; $tTableName)
	
	$tQuery:=$1
	$pFieldToSum:=$2
	$vSum:=0
	
	$tTableName:=Table name:C256(Table:C252($pFieldToSum))
	
	$tFieldToSum:=Field name:C257($pFieldToSum)
	
	$esTableSum:=New object:C1471()
	
End if   //Done initialize

$esTableSum:=ds:C1482[$tTableName].query($tQuery)

If ($esTableSum.length>0)  //Sum
	
	$vSum:=$esTableSum.sum($tFieldToSum)
	
End if   //Done sum

$0:=$vSum