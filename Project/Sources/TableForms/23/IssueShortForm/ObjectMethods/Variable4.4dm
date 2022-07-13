//(s) scriterion1 [control]
//• 6/22/98 cs take into concideration possiblilty of multiple rMs found
//•2/02/00  mlb  UPR 2075 don't restrict the RM code
READ ONLY:C145([Raw_Materials:21])
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion1)

Case of 
	: (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		uConfirm("Warning: "+sCriterion1+" is not a valid Raw Material."; "Try Again"; "FG Component")
		If (ok=1)
			sCriterion1:=""
			sCriterion2:=""
			GOTO OBJECT:C206(sCriterion1)
		Else 
			<>USE_SUBCOMPONENT:=True:C214
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=sCriterion1)
			If (Records in selection:C76([Finished_Goods:26])=1)
				sCriterion2:="33-SubComponentFG"  // this will be a switch for the action following this dialog
				
			Else 
				ALERT:C41("Warning: "+sCriterion1+" is not a valid Subcomponent.")
				sCriterion1:=""
				sCriterion2:=""
				GOTO OBJECT:C206(sCriterion1)
			End if 
		End if 
		
	: (Records in selection:C76([Raw_Materials:21])>0)
		If (RMG_is_CommodityKey_Valid([Raw_Materials:21]Commodity_Key:2))
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Raw_Materials:21]Commodity_Key:2)
			If ([Raw_Materials_Groups:22]ReceiptType:13=3)
				BEEP:C151
				ALERT:C41("Warning: "+sCriterion1+" is an Expense item and should not be entered here.")
				sCriterion2:=[Raw_Materials:21]Commodity_Key:2
			Else 
				sCriterion2:=[Raw_Materials:21]Commodity_Key:2
			End if 
			sComp:="2"
			RMG_getDepartmentAndExpenseCode([Raw_Materials:21]Commodity_Key:2; ->DeptCode; ->sExpCode)
		Else 
			BEEP:C151
			ALERT:C41("Invalid Commodity Code on R/M record.")
			DeptCode:=""
			sExpCode:=""
			sCriterion2:=""
		End if 
		
End case 
//