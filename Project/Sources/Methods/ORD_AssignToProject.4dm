//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/27/07, 14:44:38
// ----------------------------------------------------
// Method: ORD_AssignToProject

// ----------------------------------------------------

C_TEXT:C284($1; $newPjtNum)
C_LONGINT:C283($numFound)

$newPjtNum:=$1

If (Length:C16($newPjtNum)#0)
	[Customers_Orders:40]ProjectNumber:53:=$newPjtNum  //•5/03/00  mlb 
	[Customers_Orders:40]CustID:2:=pjtCustid
	[Customers_Orders:40]CustomerName:39:=pjtCustName
	//see if project name matches a brand
	$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
	QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=pjtCustid; *)
	QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=pjtName)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($numFound>0)
		[Customers_Orders:40]CustomerLine:22:=pjtName
	End if 
	
	READ WRITE:C146([Customers_Order_Lines:41])
	RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)  // SELECTION
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50:=pjtId)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4:=pjtCustid)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24:=pjtCustName)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerLine:42:=[Customers_Orders:40]CustomerLine:22)
	
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40:=pjtId)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12:=pjtCustid)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Orders:40]CustomerLine:22)
	
End if 