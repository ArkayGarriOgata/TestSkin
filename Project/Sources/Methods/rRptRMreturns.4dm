//%attributes = {"publishedWeb":true}
//rRptRMreturns
//10/27/94 upr 1257
//1/3/97 - cs - upr 0235 added break level to report for division
//•042299  MLB  chg due to new relations
dDateBegin:=4D_Current_date
dDateEnd:=dDateBegin
Open window:C153(2; 40; 638; 478; 8; "Return Log")
DIALOG:C40([zz_control:1]; "DateRange2")

If (OK=1)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Return")
	
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24; >; [Raw_Materials_Transactions:23]CompanyID:20; >; [Raw_Materials_Transactions:23]Location:15; >)  //• 1/3/97 added sort on companyid
	ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]Qty:6; [Raw_Materials_Transactions:23]ActExtCost:10)
	BREAK LEVEL:C302(2)  //• 1/3/97 changed from 1 -> 2
	util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "ReturnRpt")
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "ReturnRpt")
	t2:="RETURN LOG"
	t2b:="BY COMMODITY CODE, DIVISION & DEBIT MEMO"
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	SET QUERY LIMIT:C395(1)  //•042299  MLB  chg due to new relations
	PRINT SELECTION:C60([Raw_Materials_Transactions:23])
	SET QUERY LIMIT:C395(0)  //•042299  MLB  chg due to new relations
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")
	CLOSE WINDOW:C154
End if 
//