//%attributes = {}
//Method:  FGLc_Trans_QueryExistB (tSkidNumber;tProductCode)=>bExists
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bExists)
	C_TEXT:C284($1; $tSkidNumber; $2; $tProductCode)
	
	$tSkidNumber:=$1
	$tProductCode:=$2
	
End if   //Done Initialize

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Skid_number:29=$tSkidNumber; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]ProductCode:1=$tProductCode)

$bExists:=(Records in selection:C76([Finished_Goods_Transactions:33])>0)

$0:=$bExists

