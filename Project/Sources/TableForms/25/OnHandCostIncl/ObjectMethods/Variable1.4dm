//•080996  MLB  HTK
//get the last receipt date 
//•960814
USE SET:C118("receipts")

// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Raw_Materials_Locations:25]POItemKey:19)

// ******* Verified  - 4D PS - January 2019 (end) *********

ARRAY DATE:C224($aDate; 0)
If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate)
	SORT ARRAY:C229($aDate; <)
	dDate:=$aDate{1}
Else 
	dDate:=!00-00-00!
End if 
//