//%attributes = {"publishedWeb":true}
//Procedure: doBillPayU()  092795  MLB
//Relieve payu inventory and invoice
//•092795  MLB  UPR 1729
//•101095  MLB add cpn, date, and cust refer to invoice
//•101295  MLB  add orderline and continuous logging
//•031297  mBohince  
//072503 mlb take care of estee lauder's edi releases that are filled from 
//Panapina whse

C_TEXT:C284(sPOnum2)
C_TEXT:C284(sCPN)
C_TEXT:C284(sCriterion1)
C_LONGINT:C283(iQty; iTotal; iRelNumber)
C_DATE:C307($XactDate)
C_TEXT:C284(xText; xTitle)

sPOnum2:=<>POnum
<>POnum:=""
app_Log_Usage("log"; "Pay-Use"; "Invoice Button")
MESSAGES OFF:C175
$XactDate:=4D_Current_date
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Finished_Goods_Locations:35])
READ WRITE:C146([Finished_Goods:26])
READ WRITE:C146([Customers_ReleaseSchedules:46])  //072503 mlb take care of estee lauder's edi releases
//*Find out what PO and qty to invoice
SET MENU BAR:C67(<>DefaultMenu)
xTitle:="Pay-Use Invoice Session on "+String:C10(Current date:C33; <>SHORTDATE)+" from "+String:C10(Current time:C178; <>HHMM)+" to "
xText:=Char:C90(13)
If (sPOnum2#"")
	sPayUPO
End if 

$winRef:=OpenFormWindow(->[Finished_Goods:26]; "InvoicePayUs")
DIALOG:C40([Finished_Goods:26]; "InvoicePayUs")
CLOSE WINDOW:C154($winRef)
If (xText#Char:C90(13))
	xTitle:=xTitle+String:C10(Current time:C178; <>HHMM)
	xText:=xText+Char:C90(13)+Char:C90(13)+"----- End of Report -----"
	rPrintText  //•101095  MLB  
End if 

ARRAY TEXT:C222(asBin; 0)
ARRAY TEXT:C222(aJobit; 0)
ARRAY LONGINT:C221(aQty; 0)
ARRAY LONGINT:C221(aRel; 0)
ARRAY LONGINT:C221(aBinRecNum; 0)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Customers_Order_Lines:41])
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	UNLOAD RECORD:C212([Customers_Orders:40])
	UNLOAD RECORD:C212([Customers:16])
	UNLOAD RECORD:C212([Finished_Goods:26])
	UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
	//UNLOAD RECORD([old_Bookings])
	//UNLOAD RECORD([old_BookingTran])
	
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)  //•031297  mBohince  
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	REDUCE SELECTION:C351([Customers:16]; 0)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	
	
Else 
	
	
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)  //•031297  mBohince  
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	REDUCE SELECTION:C351([Customers:16]; 0)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	
	
End if   // END 4D Professional Services : January 2019 
//REDUCE SELECTION([old_Bookings];0)
//REDUCE SELECTION([old_BookingTran];0)
sPOnum2:=""
iQty:=0
iTotal:=0
sCPN:=""
sBreakText:=""  //•101095  MLB 
t3:=""
xText:=""
xTitle:=""
sCriterion1:=""
MESSAGES ON:C181