//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/24/12, 12:04:00
// ----------------------------------------------------
// Method: Rama_restore_inventory
// ----------------------------------------------------

Repeat 
	$serial_num:=Request:C163("SSCC serial number and check digit:"; "0"; "Restore"; "Done")
	
	If (OK=1)
		If (Length:C16($serial_num)<20)
			$iSerial:=Num:C11($serial_num)
			$sscc:="000"+"0808292"+String:C10($iSerial; "0000000000")
		Else   //whole thing scanned in
			$sscc:=$serial_num
		End if 
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=$sscc)
		If (Records in selection:C76([Finished_Goods_Locations:35])=0)
			QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$sscc)
			
			If (Records in selection:C76([WMS_SerializedShippingLabels:96])>0)  //its one of ours
				sCriterion1:=[WMS_SerializedShippingLabels:96]CPN:2
				$cust_name:=[WMS_SerializedShippingLabels:96]Customer:24
				sCriterion2:="00199"
				sCriterion4:="FG:AV=RamaWhse"
				sCriterion5:=Substring:C12([WMS_SerializedShippingLabels:96]Jobit:3; 1; 8)
				i1:=Num:C11(Substring:C12([WMS_SerializedShippingLabels:96]Jobit:3; 10; 2))
				sCriter10:=$sscc
				FG_makeLocation
				[Finished_Goods_Locations:35]AdjBy:14:=<>zResp
				[Finished_Goods_Locations:35]AdjQty:12:=[WMS_SerializedShippingLabels:96]Quantity:4
				[Finished_Goods_Locations:35]QtyOH:9:=[WMS_SerializedShippingLabels:96]Quantity:4
				SAVE RECORD:C53([Finished_Goods_Locations:35])
				
			Else 
				uConfirm($sscc+" could not be identified."; "Try Again"; "Help")
			End if 
			
		Else   //already exists
			If ([Finished_Goods_Locations:35]Location:2="FG:AV=Rama@")  //at their site
				$qty:=Num:C11(Request:C163("Quantity?"; String:C10([Finished_Goods_Locations:35]QtyOH:9); "Set"; "Cancel"))
				If (ok=1) & ($qty>=0)
					[Finished_Goods_Locations:35]AdjBy:14:=<>zResp
					[Finished_Goods_Locations:35]AdjQty:12:=$qty
					[Finished_Goods_Locations:35]QtyOH:9:=$qty
					SAVE RECORD:C53([Finished_Goods_Locations:35])
				End if 
				
			Else 
				uConfirm($sscc+" exists in another warehouse.")
			End if 
		End if   //found in inventory
		
	End if   //ok
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	
Until (OK=0)