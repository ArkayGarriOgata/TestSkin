//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 02/09/06, 16:18:53
// ----------------------------------------------------
// Method: RM_getCommodityKey
// Description
// return current comkey for a r/m code
// ----------------------------------------------------

C_TEXT:C284($1; $0)
C_TEXT:C284($2)

$0:="??-??????"

SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$1)
If (Records in selection:C76([Raw_Materials:21])>0)
	$0:=[Raw_Materials:21]Commodity_Key:2
	If (Count parameters:C259=1)
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
	End if 
End if 
SET QUERY LIMIT:C395(0)