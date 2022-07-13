//%attributes = {"publishedWeb":true}
//  `(p) ReqAfter
//  `• 6/11/97  cs created
//  `based on AfterPO
//
//[Purchase_Orders]OrigOrderAmt:=Round(Sum([Purchase_Orders_Items]ExtPrice);2)
//[Purchase_Orders]ChgdOrderAmt:=[Purchase_Orders]OrigOrderAmt
//  `gAmendPOIs 
//uUpdateTrail (->[Purchase_Orders]ModDate;->[Purchase_Orders]ModWho;->[Purchase_Orders]Count)
//
//If (fDelNewVend)  `if NEW vendor info was modified delete old and maybe create new
//QUERY([Purchase_Order_ReqNewVendors];[Purchase_Order_ReqNewVendors]ID=Old([Purchase_Orders]VendorID))  `find vendor from start of modification
//DELETE SELECTION([Purchase_Order_ReqNewVendors])  `and delte old new vendor record  
//End if 
//
//If ([Purchase_Orders]NewVendor)  `if this is a new vendor save data in temp file
//If ([Purchase_Orders]ReqVendorID#"")
//  `ReqGetNewVendor ([Purchase_Orders]ReqVendorID)
//UNLOAD RECORD([Purchase_Order_ReqNewVendors])
//Else 
//CREATE RECORD([Purchase_Order_ReqNewVendors])
//  `ReqGetNewVendor   `saves data from vars to fields
//SAVE RECORD([Purchase_Order_ReqNewVendors])
//UNLOAD RECORD([Purchase_Order_ReqNewVendors])
//End if 
//End if 
//
//If (Record number([Purchase_Orders])>-3) & ([Purchase_Orders]Status="Req Approved") & (Not(fApproved))  `not new, and we would not be here if the record (or items) were not modified
//[Purchase_Orders]Status:="Requisition"
//End if 
//dDate:=!00/00/00!
//iComm:=0
//tSubGroup:=""
//sDefJobId:=""
//
//  `• 7/14/98 cs angelo wants to be able to track every thing
//[Purchase_Orders]StatusTrack:=[Purchase_Orders]Status+" "+◊zResp+" "+String(4D_Current_date)+Char(13)+[Purchase_Orders]StatusTrack
//REDUCE SELECTION([Vendors];0)
//  `eop