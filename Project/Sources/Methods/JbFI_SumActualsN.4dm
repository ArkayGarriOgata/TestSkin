//%attributes = {}
//Method: JbFI_SumActualsN(tJobit)=>nQtyActuals
//Description:  This method sums the [Job_Forms_Items]Qty_Actual

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tJobIt)
	C_LONGINT:C283($0; $nQtyActuals)
	
	C_TEXT:C284($tQuery)
	
	$tJobIt:=$1
	$nQtyActuals:=0
	
	$tQuery:=CorektBlank
	
End if   //Done initialize

If ($tJobIt#CorektBlank)  //JobIt
	
	$tQuery:="Jobit = "+CorektSingleQuote+$tJobIt+CorektSingleQuote
	
	$nQtyActuals:=Core_Query_SumV($tQuery; ->[Job_Forms_Items:44]Qty_Actual:11)
	
End if   //Done jobIt

$0:=$nQtyActuals