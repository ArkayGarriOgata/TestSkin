//%attributes = {"publishedWeb":true}
//(p) PoVendorAssign
//assign PO fields from Vendor

C_TEXT:C284($1; $vendID)

If (Count parameters:C259=0)  //then reload the vendor, otherwise just build the address
	$vendID:=[Vendors:7]ID:1
	[Purchase_Orders:11]VendorID:2:=$vendID
	[Purchase_Orders:11]AttentionOf:28:=[Vendors:7]DefaultAttn:17
	[Purchase_Orders:11]Terms:9:=[Vendors:7]Std_Terms:13
	[Purchase_Orders:11]ShipVia:10:=[Vendors:7]ShipVia:26
	[Purchase_Orders:11]FOB:8:=[Vendors:7]FOB:27
	util_ComboBoxSetup(->aTerm; [Purchase_Orders:11]Terms:9)
	util_ComboBoxSetup(->afob; [Purchase_Orders:11]FOB:8)
	util_ComboBoxSetup(->aShipvia; [Purchase_Orders:11]ShipVia:10)
	
	[Purchase_Orders:11]VendorName:42:=[Vendors:7]Name:2
	[Purchase_Orders:11]NewVendor:45:=False:C215  //• 4/15/98 cs 
	
	[Purchase_Orders:11]ChainOfCustody:58:=[Vendors:7]COC_FSC_SFI:38  // Modified by: Mel Bohince (1/29/20) pull in COC
	
	If (Old:C35([Purchase_Orders:11]VendorID:2)#[Purchase_Orders:11]VendorID:2) & (Records in selection:C76([Purchase_Orders_Items:12])>0)
		SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]VendorID:39; $aNewVendId)
		For ($i; 1; Size of array:C274($aNewVendId))
			$aNewVendId{$i}:=$vendID
		End for 
		ARRAY TO SELECTION:C261($aNewVendId; [Purchase_Orders_Items:12]VendorID:39)
	End if 
	//
	UNLOAD RECORD:C212([Vendors:7])  //• 9/4/97 cs make vendor read only
	READ ONLY:C145([Vendors:7])  //this displays the act num with out locking the record
	LOAD RECORD:C52([Vendors:7])
End if 

textAddress:="Att: "+[Purchase_Orders:11]AttentionOf:28+Char:C90(13)
textAddress:=textAddress+[Vendors:7]Name:2+Char:C90(13)
textAddress:=textAddress+[Vendors:7]Address1:4+Char:C90(13)
textAddress:=textAddress+[Vendors:7]Address2:5+Char:C90(13)
textAddress:=textAddress+[Vendors:7]City:7+", "+[Vendors:7]State:8+"  "
textAddress:=textAddress+[Vendors:7]Zip:9+"  "+(Num:C11([Vendors:7]Country:10#"USA")*[Vendors:7]Country:10)
textAddress:=txt_VerticalConcatenate(textAddress)
//SET TEXT TO CLIPBOARD(textAddress)

If (<>FAX_USER) & (Length:C16([Vendors:7]Fax:12)>9)
	OBJECT SET ENABLED:C1123(bFax; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bFax; False:C215)
End if 