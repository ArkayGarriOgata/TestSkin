//%attributes = {"publishedWeb":true}
//rRptRMadjustmen
//10/29/94 upr 1262
//• 12/20/96 Change to report for chargecode change

dDateBegin:=4D_Current_date
dDateEnd:=dDateBegin
Open window:C153(2; 40; 638; 478; 8; "Adjustment Log")
DIALOG:C40([zz_control:1]; "DateRange2")

If (OK=1)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ADJUST")
	
	//SORT SELECTION([RM_XFER];[RAW_MATERIALS]CommodityCode;>;[RM_XFER]Reason
	//«;>;[RM_XFER]POItemKey;>)     ` • sort seem incorect - sorting on raw material
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24; >; [Raw_Materials_Transactions:23]CompanyID:20; >; [Raw_Materials_Transactions:23]Reason:5; >; [Raw_Materials_Transactions:23]POItemKey:4; >)  //•added companyid field  - cs 12/18/96
	ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]Qty:6; [Raw_Materials_Transactions:23]ActExtCost:10)
	BREAK LEVEL:C302(3)  //• changed from 2 level to 3  - cs 12/18/96
	util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "AdjustReport")
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "AdjustReport")
	t2:="ADJUSTMENT LOG"
	t2b:="BY COMMODITY CODE, COMPANY, REASON, & PO Nº"
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	PRINT SELECTION:C60([Raw_Materials_Transactions:23])
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")
	CLOSE WINDOW:C154
End if 
//