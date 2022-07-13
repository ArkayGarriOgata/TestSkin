//%attributes = {"publishedWeb":true}
//(p) PoItemCommSetup
//used by bth Requistions & PoItems to setup
//the commodity code & expense code popup menus
//on startup of screen 
//  setup commodity/department codes

//on change of department code
// - if there is a RM selected
//    determine if it is allowed (by commodity)
//    - if allowed determine 
//     - is department code is different than default
//       prompt user and change if needed
//     -> else depart same 
//         do nothing
//    -> else not allowed 
//        clear rm info
//        set up commodity default based on Dept 
//  -> else no Rm Selected
//      set up commodity default based on Dept 
//• 9/22/97 cs created
//• 9/29/97 cs added optional param (called from screen startup)

READ ONLY:C145([y_accounting_departments:4])
READ ONLY:C145([y_accounting_dept_commodities:89])

MESSAGES OFF:C175

ARRAY TEXT:C222(aExpCode; 0)
ARRAY TEXT:C222(aCommCode; 0)

If (<>FlexwareActive) | (<>AcctVantageActive) | (<>OpenAccountsActive)
	LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
	LIST TO ARRAY:C288("CommCodes"; aCommCode)
Else 
	If ([y_accounting_departments:4]DepartmentID:1#[Purchase_Orders_Items:12]DepartmentID:46) | (Records in selection:C76([y_accounting_departments:4])=0)
		QUERY:C277([y_accounting_departments:4]; [y_accounting_departments:4]DepartmentID:1=[Purchase_Orders_Items:12]DepartmentID:46)
	End if 
	
	If (Records in selection:C76([y_accounting_departments:4])=1)  //a department has been setup
		ExpCodeListBld  //• 6/22/98 cs build aExpList
		//build Commidities from Department/Commodity link
		RELATE MANY:C262([y_accounting_departments:4]DepartmentID:1)
		$Count:=Records in selection:C76([y_accounting_dept_commodities:89])
		
		If ($Count>0)  //some commodities have been setup
			ARRAY INTEGER:C220($id; $Count)
			ARRAY TEXT:C222($Desc; $Count)
			ARRAY TEXT:C222(aCommCode; $Count)
			SELECTION TO ARRAY:C260([y_accounting_dept_commodities:89]CommodityCode:1; $Id; [y_accounting_dept_commodities:89]CommDesc:3; $Desc)
			
			For ($i; 1; $Count)
				aCommCode{$i}:=String:C10($Id{$i}; "00")+" - "+$Desc{$i}
			End for 
			
			//If ($Count=1) & (Records in selection([RAW_MATERIALS])=0)
			// [PO_Items]CommodityCode:=Num(Substring(aCommCode{1};1;2))
			//End if 
			
		Else   //there are no Commodities setup
			LIST TO ARRAY:C288("CommCodes"; aCommCode)
		End if 
		
	Else   //no departemnt selected give big lists
		LIST TO ARRAY:C288("ExpenseCodes"; aExpCode)
		LIST TO ARRAY:C288("CommCodes"; aCommCode)
	End if 
	
End if 
SORT ARRAY:C229(aExpCode; >)
SORT ARRAY:C229(aCommCode; >)

If ([Purchase_Orders_Items:12]CommodityCode:16=0)  //department code is empty - clear other arrays
	//[PO_Items]Commodity_Key:=""  `clear displayed fields too
	//[PO_Items]SubGroup:=""
	//[PO_Items]Raw_Matl_Code:=""
	//uClearSelection (->[RAW_MATERIALS])
Else 
	PoItemValdatRM
End if 