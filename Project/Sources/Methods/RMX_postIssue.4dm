//%attributes = {}
//RMX_postIssue
//mlb 092105  moved out of Add button script
//(P) bAccept: Accept Raw Materials Issued and Create [RM_XFER] Record.
//•  1/2/97 - cs - upr 0235 changs in charge code, need to insure the
//  new values are populated when records are created
//•1/16/97 -cs- removed 2nd parameter from updatermbin procedure
//  the extra parameter when processed was causing problems
//• 8/4/98 cs insure that the jobstart date is set on issue
//•121498  Systems G3  don't use current date, misses back dated trns
//•010699  MLB  UPR 
//•100199  mlb  UPR Semi fini goods have no poitem

C_LONGINT:C283($i)
C_TEXT:C284($ChargeCode)

uMsgWindow("Posting Items. Please Wait...")
fCnclTrn:=False:C215

START TRANSACTION:C239

For ($i; 1; arraynum)
	sThisIsPO:=Substring:C12(aRMBinPO{$i}; 12; 9)  //BAK 8/25/94
	//•Upr 0235 1/2/97 
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sThisIsPO)  //get poitem for charge code data
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)  //•100199  mlb  UPR Semi fini goods 
		//• 2/13/97 on site set up charge code so that company id is correct
		//removes problem of calcing it based on other data later  
		// aRmCOmpany is Company ID from po item selected
		//$ChargeCode:=aRmCompany{$i}+[PO_Items]DepartmentID+[PO_Items]ExpenseCode
		$ChargeCode:=[Purchase_Orders_Items:12]CompanyID:45+[Purchase_Orders_Items:12]DepartmentID:46+[Purchase_Orders_Items:12]ExpenseCode:47
	Else   //•100199  mlb  UPR 
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRMCode{$i})
		$ChargeCode:=[Raw_Materials:21]CompanyID:27+[Raw_Materials:21]DepartmentID:28+[Raw_Materials:21]Obsolete_ExpCode:29
	End if   //•100199  mlb  UPR 
	//end upr 0235
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=aRMCode{$i}; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=aRMBinNo{$i}; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sThisIsPO)  //This is the correct PO Number
	//SEARCH([RM_BINS]; & [RM_BINS]PO_No=aRMBinPO{$i})  `Bin and PO Combo
	If (Records in selection:C76([Raw_Materials_Locations:25])=0)
		// ALERT("That Bin No does not exist")
		CREATE RECORD:C68([Raw_Materials_Locations:25])
		[Raw_Materials_Locations:25]Raw_Matl_Code:1:=aRMCode{$i}
		[Raw_Materials_Locations:25]Location:2:=aRMBinNo{$i}
		[Raw_Materials_Locations:25]CompanyID:27:=ChrgCodeParse($ChargeCode; 1)  //•upr 0235 1/2/97  
		[Raw_Materials_Locations:25]POItemKey:19:=sThisIsPO
		If (Not:C34([Purchase_Orders_Items:12]Consignment:49)) | (Records in selection:C76([Purchase_Orders_Items:12])=0)  //• mlb - 2/5/03  16:18
			[Raw_Materials_Locations:25]QtyOH:9:=-aRMPOQty{$i}
			[Raw_Materials_Locations:25]QtyAvailable:13:=-aRMPOQty{$i}
		Else 
			[Raw_Materials_Locations:25]ConsignmentQty:26:=-aRMPOQty{$i}
		End if 
		[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
		[Raw_Materials_Locations:25]ModWho:22:=<>zResp
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		UNLOAD RECORD:C212([Raw_Materials_Locations:25])
	Else 
		RM_BinUpdate($i; $Chargecode)  //upr 0235 1/16/97 removed 2nd parameter
	End if 
	RM_XferCreate($i; Current date:C33; $ChargeCode)  //• upr 0235 1/2/97 2nd and third parameters added
	RM_BudgetUpdate($i; $ChargeCode)  //and allocations, • upr 0235 1/2/97 added 2nd parameter  
	//•121498  Systems G3  don't use current date, misses back dated trns, 2nd param
	uVerifyJobStart(aRmJfNum{$i}; adRMDate{$i})  //• 8/4/98 cs insure start date on form has been set
	
	//If ((aRMCode{$i}="FSC@") | (aRMCode{$i}="SFI@"))  //o/s services may not have had coc#
	//RM_isCertified_FSC_orSFI ("verify";aRmJfNum{$i})
	//End if 
End for 

If (arraynum>0)  //•010699  MLB  UPR 
	RM_IssueCalcTotal  //BAK 9/19/94 - Calc Mat Actuals for WIP
End if 

If (fCnclTrn=True:C214)
	CANCEL TRANSACTION:C241
Else 
	VALIDATE TRANSACTION:C240
End if 
CANCEL:C270
CLOSE WINDOW:C154