//%attributes = {}
// Method: trigger_RM_Bins () -> 
// ----------------------------------------------------
// by: mel: 07/19/05, 15:42:51
// ----------------------------------------------------
// Description:
// Populate new Warehouse field so Onhand reports don't give bin details
// so FG bin location may be used for corrugate
// add supplychain manager 01/10/06 mlb
// 4/12/06 mlb add second parameter to SupplyChain_BinManager ("at-a-vendor?";[RM_BINS]POItemKey)
// ----------------------------------------------------
// Modified by: Mel Bohince (11/15/21) remove the [Raw_Material_Labels] updates

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1) | (Trigger event:C369=On Saving Existing Record Event:K3:2)
		Case of 
			: ([Raw_Materials_Locations:25]Location:2="FG:V@")
				[Raw_Materials_Locations:25]Warehouse:29:="Vista"
			: ([Raw_Materials_Locations:25]Location:2="Vista@")
				[Raw_Materials_Locations:25]Warehouse:29:="Vista"
			: ([Raw_Materials_Locations:25]Location:2="FG:R@")
				[Raw_Materials_Locations:25]Warehouse:29:="Roanoke"
			: ([Raw_Materials_Locations:25]Location:2="haup@")
				[Raw_Materials_Locations:25]Warehouse:29:="Hauppauge"
			: ([Raw_Materials_Locations:25]Location:2="roan@")
				[Raw_Materials_Locations:25]Warehouse:29:="Roanoke"
			: (SupplyChain_BinManager("at-a-vendor?"; [Raw_Materials_Locations:25]POItemKey:19)="YES")  //
				[Raw_Materials_Locations:25]Warehouse:29:="Supplier"
			Else 
				[Raw_Materials_Locations:25]Warehouse:29:=[Raw_Materials_Locations:25]Location:2
		End case 
		
	: (Trigger event:C369=On Deleting Record Event:K3:3)  // Modified by: Mel Bohince (4/11/19) 
		//READ WRITE([Raw_Material_Labels])  // Modified by: Mel Bohince (11/15/21) remove the [Raw_Material_Labels] updates
		//RELATE MANY([Raw_Material_Labels]pk_id)
		//APPLY TO SELECTION([Raw_Material_Labels];[Raw_Material_Labels]Qty:=0)
		//APPLY TO SELECTION([Raw_Material_Labels];[Raw_Material_Labels]RM_Location_fk:="")
		
End case 