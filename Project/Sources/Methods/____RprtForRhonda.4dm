//%attributes = {}
//(p) rRptRmReciepts
//1/3/97 - cs - upr 0235 & Mellisa - added break for commodity & division
//1/7/97 - cs - Melissa request - add ability to print this report
//  without sort/break on company & commodity
//•031699  MLB  UPR tag report option
//•032599  MLB  UPR 2020
dDateBegin:=4D_Current_date
dDateEnd:=dDateBegin
If (Count parameters:C259=0)
	t2:="RECEIVING REPORT"
	t2b:="BY COMMODITY, LOCATION, RECEIVING Nº & PO Nº"
	$xferType:="Receipt"
	Open window:C153(2; 40; 638; 478; 8; t2)
	DIALOG:C40([zz_control:1]; "DateAndOptions2")
Else 
	t2:="R/M TAG REPORT"
	t2b:="BY TAG  Nº"
	$xferType:="ADJUST"
	rbRcvOnly:=1
	Open window:C153(2; 40; 638; 478; 8; t2)
	DIALOG:C40([zz_control:1]; "DateRange2")
End if 

If (OK=1)
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2=$xferType)
	
	If (bSearch=1)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23])
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
	End if 
	
	ARRAY TEXT:C222($atVendorName; 0)
	ARRAY TEXT:C222($atVendorCountry; 0)
	ARRAY TEXT:C222($atDescription; 0)
	ARRAY TEXT:C222($atPOQty; 0)
	ARRAY TEXT:C222($atUOM; 0)
	ARRAY TEXT:C222($atActCost; 0)
	ARRAY TEXT:C222($atActExtCost; 0)
	
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		
		For ($nRawMtrlTrns; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
			
			GOTO SELECTED RECORD:C245([Raw_Materials_Transactions:23]; $nRawMtrlTrns)
			
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4)
			
			QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
			
			If (Records in selection:C76([Vendors:7])>=1)
				
				APPEND TO ARRAY:C911($atVendorName; [Vendors:7]Name:2)
				
				If ([Vendors:7]Country:10=CorektBlank)
					
					APPEND TO ARRAY:C911($atVendorCountry; "USA")
					
				Else 
					
					APPEND TO ARRAY:C911($atVendorCountry; [Vendors:7]Country:10)
					
				End if 
				
				APPEND TO ARRAY:C911($atDescription; String:C10([Raw_Materials_Transactions:23]Raw_Matl_Code:1))
				APPEND TO ARRAY:C911($atPOQty; String:C10([Raw_Materials_Transactions:23]POQty:8))
				APPEND TO ARRAY:C911($atUOM; [Purchase_Orders_Items:12]UM_Ship:5)
				APPEND TO ARRAY:C911($atActCost; String:C10([Raw_Materials_Transactions:23]ActCost:9))
				APPEND TO ARRAY:C911($atActExtCost; String:C10([Raw_Materials_Transactions:23]ActExtCost:10))
				
			End if 
			
		End for 
		
	Else 
		ALERT:C41("No "+$xferType+"(s) were found.")
	End if 
	CLOSE WINDOW:C154
End if 

MULTI SORT ARRAY:C718($atVendorName; >; \
$atVendorCountry; >; \
$atDescription; >; \
$atPOQty; \
$atUOM; \
$atActCost; \
$atActExtCost)

INSERT IN ARRAY:C227($atVendorName; 0; 1)
INSERT IN ARRAY:C227($atVendorCountry; 0; 1)
INSERT IN ARRAY:C227($atDescription; 0; 1)

INSERT IN ARRAY:C227($atPOQty; 0; 1)
INSERT IN ARRAY:C227($atUOM; 0; 1)
INSERT IN ARRAY:C227($atActCost; 0; 1)
INSERT IN ARRAY:C227($atActExtCost; 0; 1)

$atVendorName{1}:="Name"
$atVendorCountry{1}:="Country"
$atDescription{1}:="Description"
$atPOQty{1}:="Qty"
$atUOM{1}:="UOM"
$atActCost{1}:="Cost"
$atActExtCost{1}:="Ext. Cost"

ARRAY POINTER:C280($apColumn; 0)
APPEND TO ARRAY:C911($apColumn; ->$atVendorName)
APPEND TO ARRAY:C911($apColumn; ->$atVendorCountry)
APPEND TO ARRAY:C911($apColumn; ->$atDescription)
APPEND TO ARRAY:C911($apColumn; ->$atPOQty)
APPEND TO ARRAY:C911($apColumn; ->$atUOM)
APPEND TO ARRAY:C911($apColumn; ->$atActCost)
APPEND TO ARRAY:C911($apColumn; ->$atActExtCost)

Core_Array_ToDocument(->$apColumn)
