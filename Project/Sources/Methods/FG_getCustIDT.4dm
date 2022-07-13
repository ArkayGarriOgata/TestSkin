//%attributes = {}
//Method:  FG_getCustIDT(tOutlineNum)=>tCustID
//Description:  This method will return a Customer ID for a 
//.  finished good product

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tOutlineNum)
	C_TEXT:C284($0; $tCustID)
	
	$tOutlineNum:=$1
	$tCustID:=CorektBlank
	
End if   //Done initialize

MESSAGES OFF:C175
READ ONLY:C145([Finished_Goods:26])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=$tOutlineNum)

$tCustID:=[Finished_Goods:26]CustID:2

REDUCE SELECTION:C351([Finished_Goods:26]; 0)

$0:=$tCustID