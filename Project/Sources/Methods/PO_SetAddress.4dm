//%attributes = {}
// Method: PO_SetAddress () -> 
// ----------------------------------------------------
// by: mel: 03/31/05, 10:23:22
// ----------------------------------------------------

C_TEXT:C284($1)

If (Substring:C12($1; 1; 12)#"SupplyChain-")  //get from the address table
	READ ONLY:C145([Addresses:30])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Addresses:30]; [Addresses:30]ArkayPOAddress:26=$1)
	SET QUERY LIMIT:C395(0)
	
	If (Records in selection:C76([Addresses:30])>0)
		[Purchase_Orders:11]ShipTo1:34:=[Addresses:30]Name:2
		[Purchase_Orders:11]ShipTo2:35:=[Addresses:30]Address1:3
		[Purchase_Orders:11]ShipTo3:36:=[Addresses:30]City:6+", "+[Addresses:30]State:7+"  "+[Addresses:30]Zip:8
		[Purchase_Orders:11]ShipTo4:37:=[Addresses:30]Phone:10+" "+[Addresses:30]AttentionOf:14
		[Purchase_Orders:11]ShipTo5:38:="Fax: "+[Addresses:30]Fax:11
		
	Else   //use default
		ALL RECORDS:C47([z_administrators:2])
		[Purchase_Orders:11]ShipTo1:34:=[z_administrators:2]DefaultShipTo1:5
		[Purchase_Orders:11]ShipTo2:35:=[z_administrators:2]DefaultShipTo2:6
		[Purchase_Orders:11]ShipTo3:36:=[z_administrators:2]DefaultShipTo3:7
		[Purchase_Orders:11]ShipTo4:37:=[z_administrators:2]DefaultShipTo4:8
		[Purchase_Orders:11]ShipTo5:38:=[z_administrators:2]DefaultShipTo5:9
		REDUCE SELECTION:C351([z_administrators:2]; 0)
	End if 
	
	REDUCE SELECTION:C351([Addresses:30]; 0)
	
Else   //get the address from the refereced po
	//get the po
	$po:=Substring:C12($1; 13; 7)
	<>vendorId:=""  //get the vendorid
	$pid:=New process:C317("PO_getPOvendorId"; <>lMinMemPart; "PO_getPOvendorId"; $po)
	If (False:C215)
		PO_getPOvendorId
	End if 
	While (Length:C16(<>vendorId)#5)
		DELAY PROCESS:C323(Current process:C322; 10)
	End while 
	If (Records in selection:C76([Vendors:7])>0)
		PUSH RECORD:C176([Vendors:7])
		$popVendor:=True:C214
	Else 
		$popVendor:=False:C215
	End if 
	//get the address
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Vendors:7]; [Vendors:7]ID:1=<>vendorId)
	SET QUERY LIMIT:C395(0)
	If (Records in selection:C76([Vendors:7])>0)
		[Purchase_Orders:11]ShipTo1:34:=[Vendors:7]Name:2
		[Purchase_Orders:11]ShipTo2:35:=[Vendors:7]Address1:4+" "+[Vendors:7]Address2:5
		[Purchase_Orders:11]ShipTo3:36:=[Vendors:7]City:7+", "+[Vendors:7]State:8+"  "+[Vendors:7]Zip:9
		[Purchase_Orders:11]ShipTo4:37:=[Vendors:7]Phone:11+" "+[Vendors:7]DefaultAttn:17
		[Purchase_Orders:11]ShipTo5:38:="Fax: "+[Vendors:7]Fax:12
		REDUCE SELECTION:C351([Vendors:7]; 0)
		[Purchase_Orders:11]ShipInstruct:20:="Send copy of Packing Slip to Arkay, Send product to "+[Purchase_Orders:11]ShipTo1:34+" for use on PO# "+[Purchase_Orders:11]SupplyChainPO:55+"  "+[Purchase_Orders:11]ShipInstruct:20
		
	Else 
		[Purchase_Orders:11]ShipTo1:34:="VENDOR ID"
		[Purchase_Orders:11]ShipTo2:35:=<>vendorId
		[Purchase_Orders:11]ShipTo3:36:="WAS NOT FOUND"
		[Purchase_Orders:11]ShipTo4:37:=""
		[Purchase_Orders:11]ShipTo5:38:=""
		[Purchase_Orders:11]ShipInstruct:20:=""
	End if 
	
	If ($popVendor)
		POP RECORD:C177([Vendors:7])
		ONE RECORD SELECT:C189([Vendors:7])
	End if 
End if 

textShipToAddress:=[Purchase_Orders:11]ShipTo1:34+Char:C90(13)
textShipToAddress:=textShipToAddress+[Purchase_Orders:11]ShipTo2:35+Char:C90(13)
textShipToAddress:=textShipToAddress+[Purchase_Orders:11]ShipTo3:36+Char:C90(13)
textShipToAddress:=textShipToAddress+[Purchase_Orders:11]ShipTo4:37+Char:C90(13)
textShipToAddress:=textShipToAddress+[Purchase_Orders:11]ShipTo5:38
textShipToAddress:=txt_VerticalConcatenate(textShipToAddress)