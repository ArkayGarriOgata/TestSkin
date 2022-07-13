//  `(s) sName [purchaseorder]reqListReport
//If (Form event=On Display Detail )
//If ([Purchase_Orders]VendorName="")
//QUERY(;=[Purchase_Orders]ReqVendorID)
//Self->:=
//Else 
//Self->:=[Purchase_Orders]VendorName
//End if 
//End if 
