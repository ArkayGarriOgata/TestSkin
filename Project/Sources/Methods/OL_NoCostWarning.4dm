//%attributes = {}
// -------
// Method: OL_NoCostWarning   ( ) ->
// By: Mel Bohince @ 12/01/16, 10:24:50
// Description
// report booked orderlines without cost that are not specialbillings
//like select count(orderline) from customers_order_lines where UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED') 
// and cost_extended = 0  and SpecialBilling = false and dateopened between '08/01/2016' and '08/30/2016'
// ----------------------------------------------------
// Modified by: Mel Bohince (12/7/16) don't send if no orderlines found

C_DATE:C307(dDateBegin; $1; dDateEnd; $2; $To)
C_TEXT:C284($distributionList; windowTitle; $tBody; $subject; $prehead; $t; $r)
C_LONGINT:C283($winRef)

If (Count parameters:C259=3)
	dDateBegin:=$1
	dDateEnd:=$2
	$distributionList:=$3
	
Else 
	$distributionList:=Email_WhoAmI
	windowTitle:="Backside jobs between"
	$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
	dDateBegin:=UtilGetDate(Current date:C33; "ThisMonth")  // the first
	$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
	
	DIALOG:C40([zz_control:1]; "DateRange2")
	CLOSE WINDOW:C154($winRef)
	
End if 

ARRAY TEXT:C222($aOrderline; 0)
ARRAY TEXT:C222($aCustid; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY REAL:C219($aValue; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aLine; 0)

Begin SQL
	SELECT orderline, custid, Quantity, Price_Extended, productcode, customerline 
	from Customers_Order_Lines
	where DateOpened >= :dDateBegin and
	DateOpened <= :dDateEnd and
	UPPER(Status) not in ('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED') and 
	cost_extended = 0  and SpecialBilling = false and ExcessQtySold = 0 
	order by custid, orderline 
	into :$aOrderline, :$aCustid, :$aQty, :$aValue, :$aCPN, :$aLine
End SQL

$numOL:=Size of array:C274($aOrderline)
If ($numOL>0)  // Modified by: Mel Bohince (12/7/16) don't send if no orderlines found
	ARRAY TEXT:C222($aCustomer; $numOL)
	
	$tBody:=""
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$r:="</td></tr>"+Char:C90(13)
	
	$tBody:=$tBody+$b+"Customer"+$t+"Line"+$t+"Orderline"+$t+"ProductCode"+$t+"Qtuantity"+$t+"ExtendedPrice"+$r
	
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	
	For ($ol; 1; $numOL)
		$aCustomer{$ol}:=CUST_getName($aCustid{$ol}; "elc")
		$tBody:=$tBody+$b+$aCustomer{$ol}+$t+$aLine{$ol}+$t+$aOrderline{$ol}+$t+$aCPN{$ol}+$t+String:C10($aQty{$ol})+$t+String:C10(Round:C94($aValue{$ol}; 0))+$r
	End for 
	
	
	
	
	
	//utl_LogIt ("init")
	//utl_LogIt ($tBody)
	//utl_LogIt ("show")
	$subject:="Booked without Cost from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)
	
	$prehead:="Booked without Cost from "+String:C10(dDateBegin; Internal date short:K1:7)+" to "+String:C10(dDateEnd; Internal date short:K1:7)+"."
	
	Email_html_table($subject; $prehead; $tBody; 960; $distributionList)
	
Else 
	If (Count parameters:C259=3)  //batched, so just log it
		utl_Logfile("BatchRunner.Log"; "   •••• No orderlines w/o cost found ••••")
	Else   //show alert
		BEEP:C151
		ALERT:C41("No orderlines without cost found")
	End if 
End if 