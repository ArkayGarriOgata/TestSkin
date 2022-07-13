//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 08/20/13, 11:08:18
// ----------------------------------------------------
// Method: GluelineStatus
// Description:
// Creates the Glueline Status Report.
// This report has the following columns:
//  1. Description, atDescription
//  2. Product Code, atProdCode
//  3. Job No, axlJobNum
//  4. 1st Release Quantity (Editable), axl1RelQuantity
//  5. 1st Release Date (Editable), ad1RelDate
//  6. Have Ready Date (Editable), adHRD
//  7. Total Quantity (Editable), axlTotalQty
//  8. Carton Style (Editable), atCtnStyle
//  9. "A" No, atANo
//  10. Printed (Green or Red), apPrinted
//  11. Die Cut (Green or Red), apDieCut
//  12. Comments (Editable), atComments
//  13. Line Number (Hidden), axlLineNum
// ----------------------------------------------------

C_LONGINT:C283($i; $xlNumSelection)
ARRAY TEXT:C222(atDescription; 0)
ARRAY TEXT:C222(atProdCode; 0)
ARRAY LONGINT:C221(axlJobNum; 0)
ARRAY LONGINT:C221(axl1RelQuantity; 0)
ARRAY DATE:C224(ad1RelDate; 0)
ARRAY DATE:C224(adHRD; 0)  //                   ?
ARRAY LONGINT:C221(axlTotalQty; 0)
ARRAY TEXT:C222(atCtnStyle; 0)
ARRAY TEXT:C222(atANo; 0)
ARRAY PICTURE:C279(apPrinted; 0)
ARRAY PICTURE:C279(apDieCut; 0)
ARRAY TEXT:C222(atComment; 0)
ARRAY LONGINT:C221(axlLineNum; 0)

//Get the first section: Rush Items (Releases for the next 3 days)
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=Add to date:C393(Current date:C33; 0; 0; -3); *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=Current date:C33)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
	
	$xlNumSelection:=Records in selection:C76([Customers_ReleaseSchedules:46])
	For ($i; 1; $xlNumSelection)
		GOTO SELECTED RECORD:C245([Customers_ReleaseSchedules:46]; $i)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Customers_ReleaseSchedules:46]CustID:12)
		APPEND TO ARRAY:C911(atDescription; [Customers_Order_Lines:41]CustomerLine:42)
		APPEND TO ARRAY:C911(atProdCode; [Customers_Order_Lines:41]ProductCode:5)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Lines:41]OrderNumber:1)
		APPEND TO ARRAY:C911(axlJobNum; [Customers_Orders:40]JobNo:44)
		APPEND TO ARRAY:C911(axl1RelQuantity; [Customers_ReleaseSchedules:46]Sched_Qty:6)
		APPEND TO ARRAY:C911(ad1RelDate; [Customers_ReleaseSchedules:46]Sched_Date:5)
	End for 
	
Else 
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY LONGINT:C221($_Sched_Qty; 0)
	ARRAY DATE:C224($_Sched_Date; 0)
	
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
		[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
		[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date)
	
	$xlNumSelection:=Size of array:C274($_Sched_Date)
	QUERY WITH ARRAY:C644([Customers_Order_Lines:41]CustID:4; $_CustID)
	ARRAY TEXT:C222($_CustomerLine; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_OrderNumber; 0)
	ARRAY TEXT:C222($_CustID1; 0)
	
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CustomerLine:42; $_CustomerLine; \
		[Customers_Order_Lines:41]ProductCode:5; $_ProductCode; \
		[Customers_Order_Lines:41]OrderNumber:1; $_OrderNumber; \
		[Customers_Order_Lines:41]CustID:4; $_CustID1)
	
	QUERY WITH ARRAY:C644([Customers_Orders:40]OrderNumber:1; $_OrderNumber)
	ARRAY LONGINT:C221($_OrderNumber1; 0)
	ARRAY LONGINT:C221($_JobNo; 0)
	
	SELECTION TO ARRAY:C260([Customers_Orders:40]OrderNumber:1; $_OrderNumber1; \
		[Customers_Orders:40]JobNo:44; $_JobNo)
	
	For ($i; 1; $xlNumSelection)
		$position:=Find in array:C230($_CustID1; $_CustID{$i})
		If ($position>0)
			APPEND TO ARRAY:C911(atDescription; $_CustomerLine{$position})
			APPEND TO ARRAY:C911(atProdCode; $_ProductCode{$position})
			$position1:=Find in array:C230($_OrderNumber1; $_OrderNumber{$position})
			If ($position1>0)
				APPEND TO ARRAY:C911(axlJobNum; $_JobNo{$position1})
				
			Else 
				APPEND TO ARRAY:C911(axlJobNum; "")
				
			End if 
		Else 
			APPEND TO ARRAY:C911(atDescription; "")
			APPEND TO ARRAY:C911(atProdCode; "")
			APPEND TO ARRAY:C911(axlJobNum; "")
			
		End if 
		APPEND TO ARRAY:C911(axl1RelQuantity; $_Sched_Qty{$i})
		APPEND TO ARRAY:C911(ad1RelDate; $_Sched_Date{$i})
		
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection
