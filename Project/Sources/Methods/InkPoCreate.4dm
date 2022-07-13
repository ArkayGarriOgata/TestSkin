//%attributes = {"publishedWeb":true}
//(p) InkPoCreate
//create the header record for an Ink PO
//aasumes Jobform & material job records in memory
//• 6/1/98 cs created
//• 6/8/98 cs forgot to set ordered flag
//•051799  mlb  bad required date if need date is null
//06/28/06 rewrite to exclude form objects

//normal beforePO stuff
CREATE RECORD:C68([Purchase_Orders:11])
[Purchase_Orders:11]PONo:1:=PO_setPONumber
[Purchase_Orders:11]ReqNo:5:=Req_setReqNumber  //assign Requisition number too
[Purchase_Orders:11]LastChgOrdNo:18:="00"
[Purchase_Orders:11]Status:15:="Requisition"  //• 6/16/97 cs upr 1872 replaced 'open' -> 'Requisition' - forces posting to budge
[Purchase_Orders:11]StatusBy:16:=<>zResp
[Purchase_Orders:11]ModWho:32:=<>zResp
[Purchase_Orders:11]Buyer:11:=<>zResp
[Purchase_Orders:11]ReqBy:6:=<>zResp
[Purchase_Orders:11]StatusDate:17:=4D_Current_date
[Purchase_Orders:11]PODate:4:=4D_Current_date
[Purchase_Orders:11]ModDate:31:=4D_Current_date
If (User in group:C338(Current user:C182; "Roanoke"))
	PO_SetAddress("Roanoke")
	[Purchase_Orders:11]CompanyID:43:="2"  //•1/31/97 mod for company default
Else 
	PO_SetAddress("Hauppauge")
	[Purchase_Orders:11]CompanyID:43:="1"  //•1/31/97 mod for company default
End if 

//PoVendorAssign
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
$VendorId:=[zz_control:1]InkVendorID:39
REDUCE SELECTION:C351([zz_control:1]; 0)

READ ONLY:C145([Vendors:7])
QUERY:C277([Vendors:7]; [Vendors:7]ID:1=$VendorId)
If (Records in selection:C76([Vendors:7])=1)
	[Purchase_Orders:11]VendorID:2:=$VendorId
	[Purchase_Orders:11]AttentionOf:28:=[Vendors:7]DefaultAttn:17
	[Purchase_Orders:11]Terms:9:=[Vendors:7]Std_Terms:13
	[Purchase_Orders:11]ShipVia:10:=[Vendors:7]ShipVia:26
	[Purchase_Orders:11]FOB:8:=[Vendors:7]FOB:27
	[Purchase_Orders:11]VendorName:42:=[Vendors:7]Name:2
	[Purchase_Orders:11]NewVendor:45:=False:C215  //• 4/15/98 cs 
Else 
	[Purchase_Orders:11]VendorID:2:="N/F"
	[Purchase_Orders:11]VendorName:42:="vendor "+$VendorId+" not found"
End if 

//job info
If ([Job_Forms:42]NeedDate:1#!00-00-00!)  //•051799  mlb  creates a bad date otherwise
	[Purchase_Orders:11]Required:27:=[Job_Forms:42]NeedDate:1-3  //give a 3 day leaway\ 
Else 
	[Purchase_Orders:11]Required:27:=!00-00-00!
End if 

//make an ink po
[Purchase_Orders:11]Dept:7:="9999"
[Purchase_Orders:11]DefaultJobId:3:=[Job_Forms:42]JobFormID:5
[Purchase_Orders:11]INX_autoPO:48:=True:C214
[Purchase_Orders:11]Comments:21:="PO created by Planning system."
[Purchase_Orders:11]Status:15:="Approved"
[Purchase_Orders:11]ApprovedBy:26:=[zz_control:1]Auto_Ink_Percent:41
[Purchase_Orders:11]Ordered:47:=True:C214  //• 6/8/98 cs forgot to set this
[Purchase_Orders:11]PurchaseApprv:44:=True:C214
SAVE RECORD:C53([Purchase_Orders:11])

$0:=[Purchase_Orders:11]PONo:1