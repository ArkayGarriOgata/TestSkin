// ----------------------------------------------------
// Form Method: [Finished_Goods_Locations].SimpleInventory
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4) | (Form event code:C388=On Selection Change:K2:29)
		
		If (InvListBox<=Size of array:C274(InvListBox))
			OBJECT SET ENABLED:C1123(bUpdate; True:C214)
			If (Position:C15("808292"; aPallet{InvListBox})>0)
				zwStatusMsg("Selected"; BarCode_HumanReadableSSCC(aPallet{InvListBox}))
				
			Else 
				zwStatusMsg("Selected"; aPallet{InvListBox})
			End if 
			
			Case of 
				: (Position:C15("FG:AV-"; aBin{InvListBox})>0)  //marked as in transit
					SetObjectProperties(""; ->bUpdate; True:C214; "Receive")
					OBJECT SET ENABLED:C1123(bUpdate; True:C214)
					
					
				: (aState{InvListBox}="Gaylord") | (aState{InvListBox}="Sleeve") | (aState{InvListBox}="Case")
					If (Position:C15("FG:AV="; aBin{InvListBox})>0)
						SetObjectProperties(""; ->bUpdate; True:C214; "Convert")
						OBJECT SET ENABLED:C1123(bUpdate; True:C214)
					Else 
						OBJECT SET ENABLED:C1123(bUpdate; False:C215)
					End if 
					
				: (aState{InvListBox}="Pallet")
					SetObjectProperties("bUpdate"; -><>NULL; True:C214; "Ship")
					OBJECT SET ENABLED:C1123(bUpdate; False:C215)
					
				Else 
					SetObjectProperties(""; ->bUpdate; True:C214; "Adjust")
					OBJECT SET ENABLED:C1123(bUpdate; False:C215)
			End case 
			
			
		Else 
			OBJECT SET ENABLED:C1123(bUpdate; False:C215)
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(bUpdate; False:C215)
		
	: (Form event code:C388=On Outside Call:K2:11)
		$hit:=Find in array:C230(aCPN; <>rama_cpn)
		If ($hit>-1) & ($hit<=LISTBOX Get number of rows:C915(InvListBox))
			LISTBOX SELECT ROW:C912(InvListBox; $hit; lk replace selection:K53:1)
			OBJECT SET SCROLL POSITION:C906(InvListBox; $hit)
			
		Else 
			LISTBOX SELECT ROW:C912(InvListBox; 0; lk replace selection:K53:1)
		End if 
		
End case 