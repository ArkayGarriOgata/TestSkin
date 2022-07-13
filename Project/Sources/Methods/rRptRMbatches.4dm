//%attributes = {"publishedWeb":true}
//rRptRMbatches
//10/29/94 upr 1261
dDateBegin:=4D_Current_date
dDateEnd:=dDateBegin
Open window:C153(2; 40; 638; 478; 8; "Batch Log")
DIALOG:C40([zz_control:1]; "DateRange2")

If (OK=1)
	//get the parent components
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="BATCH")
	
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; >; [Raw_Materials_Transactions:23]XferTime:25; >; [Raw_Materials_Transactions:23]JobForm:12; >)
	ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]Qty:6; [Raw_Materials_Transactions:23]ActExtCost:10)
	//BREAK LEVEL(2)
	util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "BatchRpt")
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "BatchRpt")
	t2:="BATCH LOG"
	t2b:="BY BATCH TIME"
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	PRINT SELECTION:C60([Raw_Materials_Transactions:23])
	
	t2:="BATCH COMPONENTS SUMMARY"
	t2b:="BY COMPONENT"
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12="Batch")  //just the components
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; >)
	ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]Qty:6; [Raw_Materials_Transactions:23]ActExtCost:10)
	BREAK LEVEL:C302(1)
	util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "BatchSummary")
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "BatchSummary")
	PRINT SELECTION:C60([Raw_Materials_Transactions:23])
	
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")
	CLOSE WINDOW:C154
End if 
//