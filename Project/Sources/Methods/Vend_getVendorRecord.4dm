//%attributes = {"publishedWeb":true}
//PM: Vend_getVendorRecord() -> 
//@author mlb - 7/10/02  15:39

C_TEXT:C284($1; $po; $poitem; $vend)
C_LONGINT:C283($findBy)
$findBy:=Length:C16($1)
C_TEXT:C284($0)
$0:=""
$qryVend:=False:C215
$qryPOitem:=False:C215
$qryPO:=False:C215

Case of 
	: ($findBy=5)  //vendor's id
		If ([Vendors:7]ID:1#$1)
			$qryVend:=True:C214
			CUT NAMED SELECTION:C334([Vendors:7]; "holdVendor")
			QUERY:C277([Vendors:7]; [Vendors:7]ID:1=$1)
		End if 
		
	: ($findBy=9)  //PO item
		If ([Purchase_Orders_Items:12]POItemKey:1#$1)
			$qryPOitem:=True:C214
			CUT NAMED SELECTION:C334([Purchase_Orders_Items:12]; "holdPOitem")
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$1)
		End if 
		
		If ([Vendors:7]ID:1#[Purchase_Orders_Items:12]VendorID:39)
			$qryVend:=True:C214
			CUT NAMED SELECTION:C334([Vendors:7]; "holdVendor")
			RELATE ONE:C42([Purchase_Orders_Items:12]VendorID:39)
		End if 
		
		
	: ($findBy=7)  //PO
		If ([Purchase_Orders:11]PONo:1#$1)
			$qryPO:=True:C214
			CUT NAMED SELECTION:C334([Purchase_Orders:11]; "holdPO")
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$1)
		End if 
		
		If ([Vendors:7]ID:1#[Purchase_Orders:11]VendorID:2)
			$qryVend:=True:C214
			CUT NAMED SELECTION:C334([Vendors:7]; "holdVendor")
			RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
		End if 
End case 

//If ($qryVend)
//USE NAMED SELECTION("holdVendor")
//End if 

If ($qryPOitem)
	USE NAMED SELECTION:C332("holdPOitem")
End if 

If ($qryPO)
	USE NAMED SELECTION:C332("holdPO")
End if 

If (Records in selection:C76([Vendors:7])=1)
	$0:=[Vendors:7]ID:1
End if 