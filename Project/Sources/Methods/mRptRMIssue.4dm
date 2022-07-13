//%attributes = {"publishedWeb":true}
//mRptRMIssue: Raw Material Issue Report BAK 8/30/92
//$1 - string - aything flag print current selection of RM_xfer
//10/29/94 commdity code field has been added
//this could have been done as a print selection!!!
//12/6/94 change to print selection cause rpt was grouping correctly
//12/6/94 change to print selection cause rpt was grouping correctly  
//1/3/97 - cs - added break/header to report for division upr 0235
//• 3/2/98 cs modifed to allow user to select comodity code to print
//• 4/13/98 cs added ability to print this report from code with all data 
//   setup prior to call
//• 6/25/98 cs added ability to print an issue log for a specific job/jobform

C_TEXT:C284($1)

If (Count parameters:C259=0)
	dDateBegin:=Date:C102(String:C10(Month of:C24(4D_Current_date))+"/1/"+String:C10(Year of:C25(4D_Current_date)))
	dDateEnd:=Date:C102(String:C10((Month of:C24(4D_Current_date)+1))+"/1/"+String:C10(Year of:C25(4D_Current_date)))
	dDateEnd:=dDateEnd-1  //last day of month
	windowTitle:="Issue Log Report"
	$winRef:=OpenFormWindow(->[zz_control:1]; "SelectIssueLog"; ->windowTitle; windowTitle)
	DIALOG:C40([zz_control:1]; "SelectIssueLog")
	CLOSE WINDOW:C154($winRef)
	
	If (OK=1)
		Case of 
			: (rbDate=1) & (cb1=0)  //user wants to report by date & print report for all issues
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ISSUE")
			: (rbDate=1)  //user wants to report by date & for specifc commodity
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ISSUE"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=Num:C11(xCol1))
			: (rbJob=1) & (cb1=0)  //user wants to report by Job for all issues
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=sJobform; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ISSUE")
			Else   //• 3/2/98 cs user wants to print report for specifc commodity
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=sJobform; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ISSUE"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=Num:C11(xCol1))
		End case 
	End if 
Else   //print current selection of rm_xfers
	OK:=1
End if 

If (OK=1) & (Records in selection:C76([Raw_Materials_Transactions:23])>0)  //• 3/2/98 cs do not try to print an empty selection
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24; >; [Raw_Materials_Transactions:23]viaLocation:11; >; [Raw_Materials_Transactions:23]JobForm:12; >; [Raw_Materials_Transactions:23]XferDate:3; >)  //10/29/94`•1/ 3/97upr 0235 added sort for division
	ACCUMULATE:C303(real1; real2; [Raw_Materials_Transactions:23]Qty:6; [Raw_Materials_Transactions:23]ActExtCost:10)
	BREAK LEVEL:C302(3)  //1/3/97 upr 0235 changed level from 2 -> 3
	util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "IssueRpt")
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "IssueRpt")  //"ReturnRpt")
	t2:="ISSUE LOG"
	t2b:="BY COMMODITY CODE, LOCATION & JOB Nº"  //modified title
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	PRINT SELECTION:C60([Raw_Materials_Transactions:23]; >)
Else 
	ALERT:C41("No records found to print.")
End if 
FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")
CLOSE WINDOW:C154