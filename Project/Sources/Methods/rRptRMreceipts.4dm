//%attributes = {"publishedWeb":true}
//(p) rRptRmReciepts
//1/3/97 - cs - upr 0235 & Mellisa - added break for commodity & division
//1/7/97 - cs - Melissa request - add ability to print this report
//  without sort/break on company & commodity
//•031699  MLB  UPR tag report option
//•032599  MLB  UPR 2020
dDateBegin:=4D_Current_date
dDateEnd:=dDateBegin
If (Count parameters:C259=0)
	t2:="RECEIVING REPORT"
	t2b:="BY COMMODITY, LOCATION, RECEIVING Nº & PO Nº"
	$xferType:="Receipt"
	Open window:C153(2; 40; 638; 478; 8; t2)
	DIALOG:C40([zz_control:1]; "DateAndOptions2")
Else 
	t2:="R/M TAG REPORT"
	t2b:="BY TAG  Nº"
	$xferType:="ADJUST"
	rbRcvOnly:=1
	Open window:C153(2; 40; 638; 478; 8; t2)
	DIALOG:C40([zz_control:1]; "DateRange2")
End if 

If (OK=1)
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2=$xferType)
	
	If (bSearch=1)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23])
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
	End if 
	
	
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		//• 1/7/97 - Melissa request
		If (rbRcvOnly=1)  //if this report is to be sort only by receivng numbers
			ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]ReceivingNum:23; >; [Raw_Materials_Transactions:23]POItemKey:4; >)
			ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]zCount:16; [Raw_Materials_Transactions:23]ActExtCost:10)
			BREAK LEVEL:C302(0)
			util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "ReceivingRpt2")
			FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "ReceivingRpt2")
		Else 
			//1/7/97 end Melissa request    
			ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24; >; [Raw_Materials_Transactions:23]Location:15; >; [Raw_Materials_Transactions:23]ReceivingNum:23; >; [Raw_Materials_Transactions:23]POItemKey:4; >)  //• 1/3/97 - cs- added sort for companyid & Commodity
			ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]zCount:16; [Raw_Materials_Transactions:23]ActExtCost:10)
			BREAK LEVEL:C302(2)  //•1/3/97 changed from 0 -> 2
			util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "ReceivingRpt")
			FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "ReceivingRpt")
		End if 
		
		PRINT SELECTION:C60([Raw_Materials_Transactions:23])
		FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")
		
	Else 
		ALERT:C41("No "+$xferType+"(s) were found.")
	End if 
	CLOSE WINDOW:C154
End if 
//