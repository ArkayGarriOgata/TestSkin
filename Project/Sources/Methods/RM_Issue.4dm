//%attributes = {"publishedWeb":true}
//(P) RM_Issue was gIssueRM: Issue Raw Materials
//•090895  MLB  UPR 1737
//• 1/20/98 cs clear selections

If (False:C215)  // (Current user="Designer")
	NewIssuing
Else 
	windowTitle:="Issue Materials to Jobs"
	$winRef:=OpenFormWindow(->[Raw_Materials:21]; "FormArray"; ->windowTitle; windowTitle)  //;"wCloseOption")
	SET MENU BAR:C67(4)
	ARRAY TEXT:C222(aCostCenter; 0)
	MESSAGES OFF:C175
	READ ONLY:C145([Cost_Centers:27])  // Modified by: Mel Bohince (3/31/21) 
	ALL RECORDS:C47([Cost_Centers:27])
	DISTINCT VALUES:C339([Cost_Centers:27]ID:1; aCostCenter)
	MESSAGES ON:C181
	Repeat 
		sPONum:=""
		arraynum:=0
		gClrRMFields
		sIssType:="Issue"
		uClrBudgetArray
		ARRAY TEXT:C222(asJFBudget; 0)
		ARRAY REAL:C219(arActCost; 0)
		ARRAY TEXT:C222(aRMJFNum; 0)
		ARRAY INTEGER:C220(aRMBudItem; 0)
		ARRAY TEXT:C222(aRMCode; 0)
		ARRAY TEXT:C222(aRMBinNo; 0)
		ARRAY TEXT:C222(aRMRefNo; 0)
		ARRAY REAL:C219(aRMPOQty; 0)
		ARRAY REAL:C219(aRMPOPrice; 0)
		ARRAY REAL:C219(aRMStdPrice; 0)
		ARRAY TEXT:C222(aRMType; 0)
		ARRAY TEXT:C222(aRMBinPO; 0)
		ARRAY DATE:C224(adRMDate; 0)
		ARRAY TEXT:C222(aRmCompany; 0)
		DIALOG:C40([Raw_Materials:21]; "FormArray")
	Until (bCancel=1)  //until canceled
	CLOSE WINDOW:C154($winRef)
	ARRAY TEXT:C222(aCostCenter; 0)
	uClearSelection(->[Job_Forms_Materials:55])  //• 1/20/98 cs clean up
	uClearSelection(->[Raw_Materials_Locations:25])
	uClearSelection(->[Raw_Materials:21])
	uClearSelection(->[Purchase_Orders_Items:12])
	uClearSelection(->[Raw_Materials_Transactions:23])
	uClearSelection(->[Job_Forms:42])
	uClearSelection(->[Cost_Centers:27])  // Modified by: Mel Bohince (3/31/21) 
End if 
uWinListCleanup