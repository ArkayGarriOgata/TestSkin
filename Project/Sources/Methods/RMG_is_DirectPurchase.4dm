//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/27/06, 17:32:07
// ----------------------------------------------------
// Method: RMG_is_DirectPurchase
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305($0)
C_POINTER:C301($2)

If (Count parameters:C259>=2)
	$2->:=-1
End if 

$0:=False:C215

If (Count parameters:C259>=1)
	READ ONLY:C145([Raw_Materials_Groups:22])
End if 

SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$1)
If (Records in selection:C76([Raw_Materials_Groups:22])>0)
	$0:=([Raw_Materials_Groups:22]ReceiptType:13=2)
	If (Count parameters:C259>=2)
		$2->:=[Raw_Materials_Groups:22]ReceiptType:13
	End if 
	REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	
End if 

SET QUERY LIMIT:C395(0)