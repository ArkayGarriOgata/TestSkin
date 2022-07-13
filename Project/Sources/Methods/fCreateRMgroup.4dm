//%attributes = {"publishedWeb":true}
//fCreateRMgroup 11/4/94
//upr 1300
//return false if no comm key is found or created.
//11/7/94
//Upr 0235 - Cs 12/3/96
//modified processing and storage of charge code
//• 4/2/97 cs if user canceled dlog there were problems
//• 7/16/97 still some problems if canceled
//• 8/5/97 cs added second parameter - Commodity key to create
//  called from RM cleanup pallet - trying to consolidate subgroups
//• 10/27/97 cs fixed runtime error line 88

C_BOOLEAN:C305($0)
C_LONGINT:C283($1)
C_TEXT:C284($comKey)

$0:=False:C215

Case of 
	: (Count parameters:C259=1)  //called for a RM
		$comKey:=String:C10([Raw_Materials:21]CommodityCode:26; "00-")+[Raw_Materials:21]SubGroup:31
	: (Count parameters:C259=2)
		$ComKey:=$2
	Else 
		$comKey:=String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00-")+[Purchase_Orders_Items:12]SubGroup:13
End case 

If ((Substring:C12($comKey; 4)#"") & (Num:C11(Substring:C12($comKey; 1; 2))#0))
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$comKey)
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		$0:=True:C214
		
	Else 
		BEEP:C151
		$comKey:=""
		$0:=False:C215
	End if   //found the rm group
	
Else   //too soon to try
	$comKey:=""
	$0:=False:C215
End if 

If ($comKey#"")  //• 4/2/97 cs if user canceled dlog, below code got run with empty records
	If (Count parameters:C259=1)  //call from rm
		[Raw_Materials:21]Commodity_Key:2:=$comKey
		[Raw_Materials:21]CompanyID:27:=[Raw_Materials_Groups:22]CompanyID:21
		[Raw_Materials:21]DepartmentID:28:=[Raw_Materials_Groups:22]DepartmentID:22
		If (<>FlexwareActive) | (<>AcctVantageActive)
			[Raw_Materials:21]Obsolete_ExpCode:29:=[Raw_Materials_Groups:22]GL_Expense_Code:25
			If (False:C215)
				[Raw_Materials:21]Obsolete_ExpCode:29:=RMG_getExpenseCode($comKey)
			End if 
		Else 
			[Raw_Materials:21]Obsolete_ExpCode:29:=[Raw_Materials_Groups:22]GL_Expense_Code:25  //[RM_GROUP]ExpenseCode
		End if 
		[Raw_Materials:21]IssueUOM:10:=[Raw_Materials_Groups:22]UOM:8
		
	Else   //call from poi
		[Purchase_Orders_Items:12]Commodity_Key:26:=$comKey
		If ([Purchase_Orders_Items:12]CompanyID:45="")
			[Purchase_Orders_Items:12]CompanyID:45:=[Raw_Materials_Groups:22]CompanyID:21
		End if 
		If ([Purchase_Orders_Items:12]DepartmentID:46="") | ([Purchase_Orders_Items:12]DepartmentID:46="0000") | ([Purchase_Orders_Items:12]DepartmentID:46=" All")
			[Purchase_Orders_Items:12]DepartmentID:46:=[Raw_Materials_Groups:22]DepartmentID:22
		End if 
		// If ([PO_Items]ExpenseCode="")`• mlb - 5/9/02  15:21
		If (<>FlexwareActive) | (<>AcctVantageActive)
			[Purchase_Orders_Items:12]ExpenseCode:47:=[Raw_Materials_Groups:22]GL_Expense_Code:25
			
			If (False:C215)
				[Purchase_Orders_Items:12]ExpenseCode:47:=RMG_getExpenseCode($comKey)
			End if 
		Else 
			[Purchase_Orders_Items:12]ExpenseCode:47:=[Raw_Materials_Groups:22]GL_Expense_Code:25  //[RM_GROUP]ExpenseCode
		End if 
		
		// End if 
		[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=[Raw_Materials_Groups:22]UOM:8
		[Purchase_Orders_Items:12]UM_Ship:5:=[Raw_Materials_Groups:22]UOM:8
		[Purchase_Orders_Items:12]UM_Price:24:=[Raw_Materials_Groups:22]UOM:8
	End if 
End if 
UNLOAD RECORD:C212([Raw_Materials_Groups:22])