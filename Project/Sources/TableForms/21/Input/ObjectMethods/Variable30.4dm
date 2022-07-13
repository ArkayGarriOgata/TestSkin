// ----------------------------------------------------
// Object Method: [Raw_Materials].Input.Variable30
// ----------------------------------------------------

[Raw_Materials:21]Status:25:=astat{astat}
If (Length:C16([Raw_Materials:21]Status:25)=0)
	[Raw_Materials:21]Status:25:=Old:C35([Raw_Materials:21]Status:25)
Else 
	If ([Raw_Materials:21]Status:25="Obsolete")  //check for inventory or open po's
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numLoc)
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
		
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numPO)
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=[Raw_Materials:21]Raw_Matl_Code:1; *)
		QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Canceled:44=False:C215; *)
		QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		Case of 
			: ($numLoc>0) & ($numPO>0)
				uConfirm("There are "+String:C10($numLoc)+" bins and "+String:C10($numPO)+" PO items."; "Obsolete"; "PhaseOut")
				If (ok=0)
					[Raw_Materials:21]Status:25:="PhaseOut"
				End if 
			: ($numLoc>0)
				uConfirm("There are "+String:C10($numLoc)+" bins."; "Obsolete"; "PhaseOut")
				If (ok=0)
					[Raw_Materials:21]Status:25:="PhaseOut"
				End if 
			: ($numPO>0)
				uConfirm("There are "+String:C10($numPO)+" PO items."; "Obsolete"; "PhaseOut")
				If (ok=0)
					[Raw_Materials:21]Status:25:="PhaseOut"
				End if 
		End case 
	End if 
End if 

$hit:=Find in array:C230(astat; [Raw_Materials:21]Status:25)
astat:=$hit

If ([Raw_Materials:21]Status:25="Obsolete") | ([Raw_Materials:21]Status:25="PhaseOut")
	SetObjectProperties(""; ->[Raw_Materials:21]Successor:34; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties("succ@"; -><>NULL; True:C214; ""; True:C214; Black:K11:16; White:K11:1)  // Modified by: Mark Zinke (5/13/13)
	GOTO OBJECT:C206([Raw_Materials:21]Successor:34)
Else 
	SetObjectProperties(""; ->[Raw_Materials:21]Successor:34; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties("succ@"; -><>NULL; True:C214; ""; True:C214; Grey:K11:15; Light grey:K11:13)  // Modified by: Mark Zinke (5/13/13)
End if 