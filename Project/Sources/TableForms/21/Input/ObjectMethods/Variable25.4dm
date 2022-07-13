//(s) aCommCode 

If (iMode<3)
	If (Length:C16(aCommCode{0})=1)
		aCommCode{0}:="0"+aCommCode{0}
	End if 
	[Raw_Materials:21]CommodityCode:26:=Num:C11(Substring:C12(util_ComboBoxAction(->aCommCode); 1; 2))
	util_ComboBoxSetup(->aCommCode; String:C10([Raw_Materials:21]CommodityCode:26; "00"))
	sRMflexFields([Raw_Materials:21]CommodityCode:26)
	RMG_buildSubgroupList([Raw_Materials:21]CommodityCode:26; ->aSubGroup)
	
	If (Length:C16([Raw_Materials:21]SubGroup:31)>0) & ([Raw_Materials:21]CommodityCode:26>0)
		[Raw_Materials:21]Commodity_Key:2:=RMG_getCommodityKey([Raw_Materials:21]CommodityCode:26; [Raw_Materials:21]SubGroup:31)
		If (RMG_is_CommodityKey_Valid([Raw_Materials:21]Commodity_Key:2))
			[Raw_Materials:21]DepartmentID:28:=RMG_getDepartmentCode([Raw_Materials:21]Commodity_Key:2; "keep")
			[Raw_Materials:21]Obsolete_ExpCode:29:=[Raw_Materials_Groups:22]GL_Expense_Code:25  //RMG_getExpenseCode ([Raw_Materials]Commodity_Key)
			[Raw_Materials:21]ActCost:45:=[Raw_Materials_Groups:22]Std_Cost:4  //RMG_getStdCost ([Raw_Materials]Commodity_Key)
			[Raw_Materials:21]IssueUOM:10:=[Raw_Materials_Groups:22]UOM:8
			[Raw_Materials:21]ReceiptUOM:9:=[Raw_Materials:21]IssueUOM:10
			REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
			util_ComboBoxSetup(->aUOM1; [Raw_Materials:21]ReceiptUOM:9)
			util_ComboBoxSetup(->aUOM2; [Raw_Materials:21]IssueUOM:10)
		Else 
			[Raw_Materials:21]Commodity_Key:2:=Old:C35([Raw_Materials:21]Commodity_Key:2)
		End if 
	End if 
	
	GOTO OBJECT:C206(aSubgroup)
End if 