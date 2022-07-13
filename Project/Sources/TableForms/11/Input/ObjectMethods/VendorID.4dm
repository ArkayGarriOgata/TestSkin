// ----------------------------------------------------
// User name (OS): cs
// ----------------------------------------------------
// Object Method: [Purchase_Orders].Input.Field27
// Description:
// • 6/16/97 cs upr 1872
// • 9/4/97 cs display vendor acct number
// • 4/15/98 cs insure that when the vendor ID is changed the new vendor flag clrd
// ----------------------------------------------------

Vndr_OM_Field(OBJECT Get pointer:C1124)

If (False:C215)  //Old code ****REMOVE
	
	If ([Purchase_Orders:11]VendorID:2#"")
		QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders:11]VendorID:2)
		If (Records in selection:C76([Vendors:7])=0)
			uConfirm("No Vendors match the specified ID"; "Try Again"; "Ok")
			[Purchase_Orders:11]VendorID:2:=""
			[Purchase_Orders:11]VendorName:42:=""
			GOTO OBJECT:C206([Purchase_Orders:11]VendorID:2)
		End if 
		
		PoVendorAssign
		
	Else 
		[Purchase_Orders:11]VendorName:42:=""
		[Purchase_Orders:11]AttentionOf:28:=""
	End if 
	
	PO_setVendorButton
	
End if   //Done old code
