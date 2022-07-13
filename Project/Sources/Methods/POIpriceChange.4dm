//%attributes = {"publishedWeb":true}
//PM:  POIpriceChangeoikey;newUnitprice;expCode)  5/06/99  MLB
//server method to change bins and existing xfers to a new price
//moved out of after phase of POI
//•061499  mlb  get back to first recrd

C_TEXT:C284($1; $poiKey)
C_REAL:C285($2; $newUnitPrice)
C_TEXT:C284($expenseCode; $3)  //•061499  mlb 

$poiKey:=$1
$newUnitPrice:=uNANCheck($2)
$expenseCode:=$3

If ($newUnitPrice#0) | (True:C214)
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=$poiKey)  //• 4/7/98 cs added check for total price change too (above)
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]ActCost:18:=($newUnitPrice+[Raw_Materials_Locations:25]SuppliedMatlUnitCost:30))
		$locked:=Records in set:C195("LockedSet")
		If ($locked>0)
			EMAIL_Sender("LockedSet"; ""; $poiKey+" [RM_BINS] locked, act cost could not be set to "+String:C10($newUnitPrice))
		End if 
	End if 
	
	READ WRITE:C146([Raw_Materials_Transactions:23])
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$poiKey)
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		APPLY TO SELECTION:C70([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]ActCost:9:=$newUnitPrice)
		$locked:=Records in set:C195("LockedSet")
		If ($locked>0)
			EMAIL_Sender("LockedSet"; ""; $poiKey+" [RM_XFER] locked, act cost could not be set to "+String:C10($newUnitPrice))
		End if 
		FIRST RECORD:C50([Raw_Materials_Transactions:23])  //•061499  mlb  
		APPLY TO SELECTION:C70([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94(($newUnitPrice*[Raw_Materials_Transactions:23]Qty:6); 2))
		$locked:=Records in set:C195("LockedSet")
		If ($locked>0)
			EMAIL_Sender("LockedSet"; ""; $poiKey+" [RM_XFER] locked, extend cost could not be set")
		End if 
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]ExpenseCode:26#$3)
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			APPLY TO SELECTION:C70([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]ExpenseCode:26:=$3)
		End if 
	End if 
End if 