//%attributes = {"publishedWeb":true}
//(p) PiFounInvTmplt
//prints templates for hand writing inventory found during PI counts. 
//called from PiFrzInventory

C_LONGINT:C283($LinePerPage)

$LinePerPage:=29
uYesNoCancel("Print FG Found Inventory Form,  or"+Char:C90(13)+"Print RM Found Inventory Form,  or"+Char:C90(13)+"Cancel"; "FG"; "RM"; "Cancel")

If (bCancel=0)  //user did not cancel
	$Pages:=Request:C163("Print How many pages?"; "5")
	If (OK=1)
		If (Num:C11($Pages)>0)
			lPage:=Num:C11($Pages)
			If (bAccept=1)  //first dialog above, user selected FG
				t2:="Finished Goods: Found Inventory Reporting Sheet"
				ALL RECORDS:C47([Finished_Goods_Transactions:33])
				REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; (lPage*$LinePerPage))
				FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "FGPiTemplate")
				util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "FgPITemplate")
				PRINT SELECTION:C60([Finished_Goods_Transactions:33])
				FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
			Else 
				t2:="Raw Materials: Found Inventory Reporting Sheet"
				ALL RECORDS:C47([Raw_Materials_Transactions:23])
				REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; (lPage*$LinePerPage))
				FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "RMPiTemplate")
				util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "RMPITemplate")
				PRINT SELECTION:C60([Raw_Materials_Transactions:23])
				FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")
			End if 
		End if 
	End if 
End if 