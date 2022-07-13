//%attributes = {"publishedWeb":true}
//BatchForecastNeedDate 102299 mlb'
// make sure at least 1 release exists for every open orderline 
//which has a need date
//• mlb - 4/25/01  10:44 remove fnd's that are no longer needed

C_LONGINT:C283($i; $hit; $numOrds)
C_TEXT:C284(xTitle; xText)
C_TEXT:C284($t; $cr)
C_DATE:C307(atp)
C_DATE:C307($today; $1)

READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_ReleaseSchedules:46])

MESSAGES OFF:C175

$today:=$1
$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Forecasted Releases based on Orderline NeedDate on "+String:C10($today; <>MIDDATE)
xText:="Orderline"+$t+"Brand"+$t+"FCST_Qty"+$t+"FCST_Date"+$t+"Custid"+$t+"CPN"+$cr
zwStatusMsg("Forecasting"; "Gathering orderines...")
//*Find the open orders
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	qryOpenOrdLines
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]NeedDate:14#!00-00-00!; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]QtyWithRel:20=0)
	
	
Else 
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]NeedDate:14#!00-00-00!; *)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]QtyWithRel:20=0)
	
	
End if   // END 4D Professional Services : January 2019 query selection
$numOrds:=Records in selection:C76([Customers_Order_Lines:41])
If (False:C215)  //realtime way, for Insider searches
	uOLcalcRel_info([Customers_Order_Lines:41]OrderLine:3)  //searches releases
End if 
utl_Trace

uThermoInit($numOrds; "Creating forecasts")
For ($i; 1; $numOrds)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	atp:=REL_getAvailableToPromise([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)
	CREATE RECORD:C68([Customers_ReleaseSchedules:46])
	[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
	[Customers_ReleaseSchedules:46]OrderNumber:2:=[Customers_Order_Lines:41]OrderNumber:1
	[Customers_ReleaseSchedules:46]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
	[Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17
	[Customers_ReleaseSchedules:46]Billto:22:=[Customers_Order_Lines:41]defaultBillto:23
	[Customers_ReleaseSchedules:46]ProductCode:11:=[Customers_Order_Lines:41]ProductCode:5
	[Customers_ReleaseSchedules:46]CustID:12:=[Customers_Order_Lines:41]CustID:4
	[Customers_ReleaseSchedules:46]CustomerRefer:3:="<FND>FORECAST-TTL-"+[Customers_Order_Lines:41]ProductCode:5
	[Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Order_Lines:41]CustomerLine:42  //•060295  MLB  UPR 184
	[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
	[Customers_ReleaseSchedules:46]ModWho:19:="BATC"
	[Customers_ReleaseSchedules:46]PayU:31:=Num:C11([Customers_Order_Lines:41]PayUse:47)  //•101095  MLB 
	[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
	[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
	[Customers_ReleaseSchedules:46]Sched_Date:5:=atp
	[Customers_ReleaseSchedules:46]Promise_Date:32:=[Customers_Order_Lines:41]NeedDate:14
	[Customers_ReleaseSchedules:46]Sched_Qty:6:=[Customers_Order_Lines:41]Qty_Open:11
	[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_Order_Lines:41]Qty_Open:11
	[Customers_ReleaseSchedules:46]ChangeLog:23:="This was created by aMs on "+String:C10(Current date:C33; System date short:K1:1)+".  Please consume as firm releases are provided."
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	
	[Customers_Order_Lines:41]QtyWithRel:20:=[Customers_Order_Lines:41]Qty_Open:11
	SAVE RECORD:C53([Customers_Order_Lines:41])
	
	xText:=xText+[Customers_ReleaseSchedules:46]OrderLine:4+$t+[Customers_ReleaseSchedules:46]CustomerLine:28+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6; "###,###,###,###")+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+$t+[Customers_ReleaseSchedules:46]CustID:12+$t+[Customers_ReleaseSchedules:46]ProductCode:11+$cr
	
	NEXT RECORD:C51([Customers_Order_Lines:41])
	uThermoUpdate($i)
End for 
uThermoClose

xText:=xText+$cr+"--end of creations--"+$cr+$cr
//• mlb - 4/25/01  10:44 below
xText:=xText+"ORDERLINES WHICH HAD THEIR NEED DATE FORECAST REMOVED:"+$cr
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<FND>FORECAST-TTL-@")
SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $aOrderline)
SORT ARRAY:C229($aOrderline; >)
uThermoInit(Size of array:C274($aOrderline); "Clearing unneeded forecasts")
For ($i; 1; Size of array:C274($aOrderline))
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$aOrderline{$i})
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>1)
		xText:=xText+$aOrderline{$i}+$t+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+$cr
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<FND>FORECAST-TTL-@")
		DELETE SELECTION:C66([Customers_ReleaseSchedules:46])
	End if 
	uThermoUpdate($i)
End for 
xText:=xText+$cr+"--end of deletions--"+$cr+$cr
uThermoClose

REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)