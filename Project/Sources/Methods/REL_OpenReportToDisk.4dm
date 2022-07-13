//%attributes = {}
// Method: REL_OpenReportToDisk () -> 
// ----------------------------------------------------
// by: mel: 10/23/03, 10:06:41
// ----------------------------------------------------
// Description:
// report that marty wants to compare jobs to releases
//see also JML_OpenToDisk
// ----------------------------------------------------
C_TEXT:C284($t; $cr)
C_TEXT:C284($distributionList; $1; xTitle; xText; docName; $value)
C_TEXT:C284($period)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Open Releases (Firm and Forecast)"
xText:="see  "+"http://intranet.arkay.com/ams/categories/faqs/2003/09/15.html#a37"+" for explanation of THC column"+$cr
xText:=xText+"Rel_Num"+$t+"ProductCode"+$t+"Line"+$t+"RelType"+$t+"Schd_Date"+$t+"Period"+$t+"RelValue"+$t+"Schd_Qty"+$t+"THC"+$t+"Custid"+$cr
$distributionList:=$1
docName:="OpenReleases"+fYYMMDD(4D_Current_date; 1)+".xls"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	SEND PACKET:C103($docRef; xText)
	xText:=""
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	READ ONLY:C145([Customers_Order_Lines:41])
	READ ONLY:C145([Finished_Goods:26])
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
	uThermoInit($numRecs; "Reporting Release Records")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			$period:=String:C10(Year of:C25([Customers_ReleaseSchedules:46]Sched_Date:5)+(Month of:C24([Customers_ReleaseSchedules:46]Sched_Date:5)/100); "0000.00")
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)  //[OrderLines]Price_Per_M
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				$value:=String:C10([Customers_Order_Lines:41]Price_Per_M:8*([Customers_ReleaseSchedules:46]Sched_Qty:6/1000))
			Else 
				$numFG:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
				If ($numFG>0)
					$value:=String:C10([Finished_Goods:26]RKContractPrice:49*([Customers_ReleaseSchedules:46]Sched_Qty:6/1000))
				Else 
					$value:="0"
				End if 
			End if 
			$type:=util_iif(Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; 1)="<"; "FRCST"; "FIRM")
			xText:=xText+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+$t+[Customers_ReleaseSchedules:46]ProductCode:11+$t+[Customers_ReleaseSchedules:46]CustomerLine:28+$t+$type+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+$t+$period+$t+$value+$t+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+$t+THC_decode+$t+[Customers_ReleaseSchedules:46]CustID:12+$cr
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		ARRAY DATE:C224($_Sched_Date; 0)
		ARRAY TEXT:C222($_CustID; 0)
		ARRAY TEXT:C222($_OrderLine; 0)
		ARRAY LONGINT:C221($_Sched_Qty; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_CustomerRefer; 0)
		ARRAY LONGINT:C221($_ReleaseNumber; 0)
		ARRAY TEXT:C222($_CustomerLine; 0)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; \
			[Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
			[Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; \
			[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
			[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
			[Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; \
			[Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; \
			[Customers_ReleaseSchedules:46]CustomerLine:28; $_CustomerLine)
		
		
		For ($i; 1; $numRecs; 1)
			If ($break)
				$i:=$i+$numRecs
			End if 
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			$period:=String:C10(Year of:C25($_Sched_Date{$i})+(Month of:C24($_Sched_Date{$i})/100); "0000.00")
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderLine{$i})  //[OrderLines]Price_Per_M
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				$value:=String:C10([Customers_Order_Lines:41]Price_Per_M:8*($_Sched_Qty{$i}/1000))
			Else 
				$numFG:=qryFinishedGood($_CustID{$i}; $_ProductCode{$i})
				If ($numFG>0)
					$value:=String:C10([Finished_Goods:26]RKContractPrice:49*($_Sched_Qty{$i}/1000))
				Else 
					$value:="0"
				End if 
			End if 
			$type:=util_iif(Substring:C12($_CustomerRefer{$i}; 1; 1)="<"; "FRCST"; "FIRM")
			xText:=xText+String:C10($_ReleaseNumber{$i})+$t+$_ProductCode{$i}+$t+$_CustomerLine{$i}+$t+$type+$t+String:C10($_Sched_Date{$i}; System date short:K1:1)+$t+$period+$t+$value+$t+String:C10($_Sched_Qty{$i})+$t+THC_decode+$t+$_CustID{$i}+$cr
			
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
	//
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	
	EMAIL_Sender(xTitle; ""; "Open attached spreadsheet with Excel."; $distributionList; docName)
	util_deleteDocument(docName)
	
Else 
	EMAIL_Sender(xTitle; ""; "Couldn't create document"; $distributionList)
End if 

xTitle:=""
xText:=""