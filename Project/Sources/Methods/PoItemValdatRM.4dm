//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: PoItemValdatRM
// ----------------------------------------------------

Case of 
	: ([Purchase_Orders_Items:12]Raw_Matl_Code:15#"")  //a material was selected/entered, validate
		If (Find in array:C230(aCommCode; String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+"@")<0)  //comm not allowed
			
			$Text:="The department code and item catagory do not agree."+Char:C90(13)
			$Text:=$Text+"                     You may..."+Char:C90(13)
			$Text:=$Text+"• Keep Item, and change the department code,      or"+Char:C90(13)
			$Text:=$Text+"• Keep Department code and clear the item,      or"+Char:C90(13)
			$Text:=$Text+"• Override the restrictions, and keep your entered department code"+" with this material"
			uYesNoCancel($Text; "Keep Dept"; "Keep Item"; "Override")
			
			Case of 
				: (bNo=1)  //user wants to Keep item (clear Dept)
					[Purchase_Orders_Items:12]DepartmentID:46:=""
					GOTO OBJECT:C206([Purchase_Orders_Items:12]DepartmentID:46)
				: (bCancel=1)
					//do nothing
				Else   //user wants to Clear item (keep Dept)
					
					If (Size of array:C274(aCommCode)>1)
						[Purchase_Orders_Items:12]CommodityCode:16:=0
						[Purchase_Orders_Items:12]Commodity_Key:26:="00"
					Else 
						[Purchase_Orders_Items:12]CommodityCode:16:=Num:C11(Substring:C12(aCommCode{1}; 1; 2))
						[Purchase_Orders_Items:12]Commodity_Key:26:=RMG_makeCommKey(->aCommCode{1}; "")
					End if 
					uClearSelection(->[Raw_Materials:21])
					sPOIClearRM("*")  //asterisk - do not clear deptcode
					[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""
					
					If (Find in array:C230(aExpCode; [Purchase_Orders_Items:12]ExpenseCode:47)<0) & ([Purchase_Orders_Items:12]ExpenseCode:47#"")
						[Purchase_Orders_Items:12]ExpenseCode:47:=""
					End if 
			End case 
		End if 
		
	: ([Purchase_Orders_Items:12]SubGroup:13#"")  //a subgroup has been entered, validate
		If (Find in array:C230(aExpCode; [Purchase_Orders_Items:12]ExpenseCode:47)<0) & ([Purchase_Orders_Items:12]ExpenseCode:47#"")
			[Purchase_Orders_Items:12]ExpenseCode:47:=""
		End if 
End case 