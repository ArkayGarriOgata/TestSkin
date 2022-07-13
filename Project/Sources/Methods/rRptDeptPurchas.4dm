//%attributes = {"publishedWeb":true}
//rRptDeptPurchas

//•091295 upr 1696

//(p) rVendorSumry
//print a 'vensum' report for Purchasing
//$1 optional, anything indicate that the originating call is from 
//PO Pallette
//on site, turned off search messages 4/6/95
//•062695  MLB  UPR 219
//Upr 0235 -cs -12/9/96

If (Count parameters:C259=1)
	SET WINDOW TITLE:C213("Dept Summary Report")
	uDialog("DateRange2"; 250; 120)
	If (OK=1)
		util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "DeptSumReport")
		PRINT SETTINGS:C106
	End if 
Else 
	OK:=1
End if 

If (OK=1)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=dDateBegin; *)
	QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]PoItemDate:40<=dDateEnd)
	//UPR 0235
	
	//  SORT SELECTION([PO_ITEMS];[PO_ITEMS]ChargeCode;>)
	
	ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Purchase_Orders_Items:12]ExtPrice:11)
	util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "DeptSumReport")
	FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "DeptSumReport")
	t2:="ARKAY PACKAGING CORPORATION"
	t2b:="TOTAL PURCHASES BY DEPARTMENT"
	t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	PDF_setUp(<>pdfFileName)
	PRINT SELECTION:C60([Purchase_Orders_Items:12]; *)
	FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "List")
End if 