//%attributes = {}
//Method:  FGLc_GetTotalOnHandN(tCustId;tProductCode)=>nTotalOnHand
//Description:  This method will get TotalOnHand

If (True:C214)  //Initialize 
	
	C_LONGINT:C283($0; $nTotalOnHand)
	C_TEXT:C284($1; $tCustId; $2; $tProductCode)
	
	$tCustId:=$1
	$tProductCode:=$2
	
End if   //Done Initialize

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$tCustId; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=$tProductCode)

$nTotalOnHand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)

$0:=$nTotalOnHand