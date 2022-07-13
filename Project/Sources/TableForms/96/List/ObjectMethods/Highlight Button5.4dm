If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	uConfirm("Make F/G Receive Transaction for displayed SSCC?"; "Receive"; "No")
	If (ok=1)
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
		For ($i; 1; Records in selection:C76([WMS_SerializedShippingLabels:96]))
			If ([WMS_SerializedShippingLabels:96]FG_Receipt_Posted:21="")
				WIP_comesBack("Flat"; [WMS_SerializedShippingLabels:96]HumanReadable:5)
			End if 
			NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
		End for 
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
	End if 
	
	uConfirm("Make F/G Ship Transaction for displayed SSCC?"; "Ship"; "No")
	If (ok=1)
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
		For ($i; 1; Records in selection:C76([WMS_SerializedShippingLabels:96]))
			//WIP_comesBack ("Flat";[SerializedShippingLabels]HumanReadable)
			//relieve inv
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[WMS_SerializedShippingLabels:96]Jobit:3; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV-rama-flat")
			$commit:=FGL_InventoryShipped(Record number:C243([Finished_Goods_Locations:35]); [WMS_SerializedShippingLabels:96]Quantity:4)  //*        Adjust the inventory 
			//make transaction
			//FG_ShipSaveBOL   `deleted 12/2/10, check backups
			NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
		End for 
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
	End if 
Else 
	//4d ps :first one we can optiize them Mel us WIP_comesBack
	uConfirm("Make F/G Receive Transaction for displayed SSCC?"; "Receive"; "No")
	If (ok=1)
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
		For ($i; 1; Records in selection:C76([WMS_SerializedShippingLabels:96]))
			If ([WMS_SerializedShippingLabels:96]FG_Receipt_Posted:21="")
				WIP_comesBack("Flat"; [WMS_SerializedShippingLabels:96]HumanReadable:5)
			End if 
			NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
		End for 
	End if 
	
	uConfirm("Make F/G Ship Transaction for displayed SSCC?"; "Ship"; "No")
	If (ok=1)
		
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY LONGINT:C221($_Quantity; 0)
		
		SELECTION TO ARRAY:C260([WMS_SerializedShippingLabels:96]Jobit:3; $_Jobit; [WMS_SerializedShippingLabels:96]Quantity:4; $_Quantity)
		
		For ($i; 1; Size of array:C274($_Quantity); 1)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$_Jobit{$i}; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV-rama-flat")
			$commit:=FGL_InventoryShipped(Record number:C243([Finished_Goods_Locations:35]); $_Quantity{$i})  //*        Adjust the inventory 
		End for 
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
		
	End if 
End if   // END 4D Professional Services : January 2019 First record
