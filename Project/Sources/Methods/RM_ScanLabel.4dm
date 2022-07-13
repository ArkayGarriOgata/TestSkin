//%attributes = {}
// -------
// Method: RM_ScanLabel   ( ) ->
// By: Mel Bohince @ 02/15/17, 14:55:32
// Description
// print barcoded labels for inventory
// ----------------------------------------------------

SET MENU BAR:C67(<>DefaultMenu)

If (Count parameters:C259=0)
	Repeat 
		sPOI:=Substring:C12(Request:C163("Enter a Purchase Order Item number to print:"; "123456789"); 1; 9)
	Until ((Length:C16(sPOI)=9) | (ok=0))
	
Else 
	sPOI:=$1
	ok:=1
End if 


If (ok=1)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sPOI)
	$numPOI:=Records in selection:C76([Purchase_Orders_Items:12])
	
	If ($numPOI=1)
		sPOIcode39:="*"+sPOI+"*"
		sRMcode:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
		//$desc:=Substring([Purchase_Orders_Items]RM_Description;1;40)  //• 5/22/98 cs changed from [PO_ITEMS]RM_Description  
		sUOM:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
		
		QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
		sVendor:=[Vendors:7]Name:2
		REDUCE SELECTION:C351([Vendors:7]; 0)
		
	Else   //check for semi-finished bin
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=sPOI)  //something like A02017.01
		$numPOI:=Records in selection:C76([Raw_Materials_Locations:25])
		sPOIcode39:="*"+[Raw_Materials_Locations:25]POItemKey:19+"*"
		sRMcode:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
		If (Substring:C12(sPOI; 1; 1)="A")
			sVendor:="Arkay"
		Else 
			sVendor:=""
		End if 
		
		If ([Raw_Materials_Locations:25]ActCost:18=0)
			sVendor:=sVendor+" 'NOT VALUED'"
		End if 
		
	End if 
	
	If ($numPOI>0)
		
		$count:=2
		$count:=Num:C11(Request:C163("Enter the number of labels you need (even number):"; String:C10($count)))
		If ($count>0) & (ok=1)
			util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "InventoryLabels")
			PRINT SETTINGS:C106
			PDF_setUp("rm-barcodes"+".pdf")
			If (($count%2)>0)
				$count:=$count+1
			End if 
			For ($row; 1; ($count/2))
				Print form:C5([Purchase_Orders_Items:12]; "InventoryLabels")
			End for 
			PAGE BREAK:C6
			
		Else 
			BEEP:C151
		End if 
		
	Else 
		uConfirm(sPOI+" was not found")
	End if 
	
End if 
