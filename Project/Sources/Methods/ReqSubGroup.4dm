//%attributes = {"publishedWeb":true}
//(p) ReqSubGroup 
//called from [po_Items]ReqItems
//handles subgroup changes
//• 9/4/97 cs changed from Upper & stripping spaces to cap&strip

If (Find in array:C230(aSubGroup; [Purchase_Orders_Items:12]SubGroup:13)>0)
	If ([Purchase_Orders_Items:12]SubGroup:13#"")
		txt_CapNstrip(->[Purchase_Orders_Items:12]SubGroup:13)  //• 9/4/97 cs     
		$ComKey:=String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+"-"+[Purchase_Orders_Items:12]SubGroup:13
		
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$ComKey)
		If (Records in selection:C76([Raw_Materials_Groups:22])>0)
			//If (Length([PO_Items]ExpenseCode)=0)
			[Purchase_Orders_Items:12]ExpenseCode:47:=[Raw_Materials_Groups:22]GL_Expense_Code:25
			aExpCode:=Find in array:C230(aExpCode; [Purchase_Orders_Items:12]ExpenseCode:47+"@")
			//End if 
			
			If (Length:C16([Purchase_Orders_Items:12]DepartmentID:46)=0)
				[Purchase_Orders_Items:12]DepartmentID:46:=[Raw_Materials_Groups:22]DepartmentID:22
			End if 
			
		Else   //Commodity key is not valid
			BEEP:C151
			ALERT:C41("The Commodity key entered '"+$ComKey+"' is Not Valid.")
			[Purchase_Orders_Items:12]SubGroup:13:=Old:C35([Purchase_Orders_Items:12]SubGroup:13)
		End if 
		
		sSetPurchaseUM([Purchase_Orders_Items:12]CommodityCode:16)
		GOTO OBJECT:C206([Purchase_Orders_Items:12]RM_Description:7)
	End if 
	
Else 
	[Purchase_Orders_Items:12]SubGroup:13:=""
	ALERT:C41("The Subgroup Entered is invalid in Commodity "+String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+Char:C90(13)+"Please select from Pop up list.")
	GOTO OBJECT:C206([Purchase_Orders_Items:12]SubGroup:13)
End if 
[Purchase_Orders_Items:12]Commodity_Key:26:=RMG_makeCommKey(->[Purchase_Orders_Items:12]CommodityCode:16; [Purchase_Orders_Items:12]SubGroup:13)