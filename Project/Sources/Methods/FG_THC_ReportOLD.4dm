//%attributes = {}
// Method: FG_THC_ReportOLD () -> 
// ----------------------------------------------------
// by: mel: 06/30/05, 11:14:50
// ----------------------------------------------------
// Description:
// report releases by thc state
// see THC_decode, BatchTHCcalc
// mlb 10.20.05 add outline
// ----------------------------------------------------
// Modified by: Mel Bohince (1/9/19) add packing spec column
// Modified by: Garri Ogata (9/14/20) show Price, Want and TotalOnHand to the end (follow cb10)
// Modified by: Mel Bohince (10/22/21) convert from .xls to .csv for excel

C_LONGINT:C283(cb0; cb1; cb2; cb3; cb4; cb5; cb6; cb7; cb8; cb9; $winRef)
C_TEXT:C284(sCustId; $1)
C_TEXT:C284($t; $r)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

C_OBJECT:C1216($oCustomerTotal)

C_TEXT:C284($tPrice; $tQtyWant; $tTotalOnHand)

$t:=","  //Char(9)
$r:="\r"  //Char(13)

$oCustomerTotal:=New object:C1471

xTitle:="THC Report for "
xText:="Customer"+$t+"Line"+$t+"Outline"+$t+"ProductCode"+$t+"THC"+$t+"Comment"+$t+"Schd_Date"+$t+"Schd_Qty"+$t+"Need_Qty"+$t+"Art Received Date"+$t+"Cust_Refer"+$t+"Open Jobs"+$t+"Destination"+$t+"FG_Status"+$t+"Control#"+$t+"PlateID"+$t+"PackingSpec"+$r
docName:="THC_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"

READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers_ReleaseSchedules:46])

If (Count parameters:C259=0)
	$winRef:=Open form window:C675([Customers_ReleaseSchedules:46]; "THC_Rpt_dio")
	DIALOG:C40([Customers_ReleaseSchedules:46]; "THC_Rpt_dio")
	CLOSE WINDOW:C154($winRef)
Else 
	sCustId:=$1
	cb0:=1
	cb1:=1
	cb2:=1
	cb3:=1
	cb4:=1
	cb5:=1
	cb6:=1
	cb7:=1
	cb8:=1
	cb9:=0
	cb10:=0
	cb11:=0  // Added by: Mark Zinke (1/27/14) 
	OK:=1
End if 

If (OK=1)
	
	If (cb10=1)  //
		xText:=Substring:C12(xText; 1; Length:C16(xText)-1)+$t+\
			"Price"+$t+\
			"Qty_OrderLines"+$t+\
			"Qty_OrderLines_OverRun"+$t+\
			"Qty_Releases"+$t+\
			"Qty_Inventory"+$t+\
			"Qty_Production"+$r
	End if 
	
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		
		If (sCustId="ALL")
			xTitle:=xTitle+$t+"ALL Customers"
			sCustId:="@"
		Else 
			xTitle:=xTitle+$t+CUST_getName(sCustid)+$r
		End if 
		xTitle:=xTitle+"Show THC's: "+$t
		
		// BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) set
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=sCustid; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=0; *)
		If (cb6=1)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3="@")
		Else 
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")
		End if 
		
		ARRAY LONGINT:C221($_THC_State; 0)
		If (cb0=1)
			xTitle:=xTitle+"0,"
			APPEND TO ARRAY:C911($_THC_State; 0)
		End if 
		If (cb1=1)
			xTitle:=xTitle+"1,"
			APPEND TO ARRAY:C911($_THC_State; 1)
		End if 
		If (cb2=1)
			xTitle:=xTitle+"2,"
			APPEND TO ARRAY:C911($_THC_State; 2)
		End if 
		If (cb3=1)
			xTitle:=xTitle+"3,"
			APPEND TO ARRAY:C911($_THC_State; 3)
		End if 
		If (cb4=1)
			xTitle:=xTitle+"4,"
			APPEND TO ARRAY:C911($_THC_State; 4)
		End if 
		If (cb5=1)
			xTitle:=xTitle+"5,"
			APPEND TO ARRAY:C911($_THC_State; 5)
		End if 
		If (cb7=1)
			xTitle:=xTitle+"7,"
			APPEND TO ARRAY:C911($_THC_State; 7)
		End if 
		If (cb8=1)
			xTitle:=xTitle+"8 "
			APPEND TO ARRAY:C911($_THC_State; 8)
		End if 
		If (cb9=1)
			xTitle:=xTitle+"9 "
			APPEND TO ARRAY:C911($_THC_State; 9)
		End if 
		
		QUERY SELECTION WITH ARRAY:C1050([Customers_ReleaseSchedules:46]THC_State:39; $_THC_State)
		
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
		
		
		$break:=False:C215
		$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
		If ($numRecs>0)
			//If (Count parameters=0)
			//ORDER BY([Customers_ReleaseSchedules])
			//Else 
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
			//End if 
			xTitle:=xTitle+$r
			SEND PACKET:C103($docRef; xTitle+Char:C90(13)+Char:C90(13))
			
			uThermoInit($numRecs; "Updating Records")
			
			// BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			ARRAY TEXT:C222($_CustID; 0)
			ARRAY TEXT:C222($_CustomerLine; 0)
			ARRAY TEXT:C222($_CustomerRefer; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY DATE:C224($_Sched_Date; 0)
			ARRAY LONGINT:C221($_Sched_Qty; 0)
			ARRAY TEXT:C222($_Shipto; 0)
			ARRAY LONGINT:C221($_THC_Qty; 0)
			ARRAY LONGINT:C221($_THC_State; 0)
			ARRAY TEXT:C222($_OrderLine; 0)
			
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
				[Customers_ReleaseSchedules:46]CustomerLine:28; $_CustomerLine; \
				[Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; \
				[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
				[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; \
				[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
				[Customers_ReleaseSchedules:46]Shipto:10; $_Shipto; \
				[Customers_ReleaseSchedules:46]THC_Qty:37; $_THC_Qty; \
				[Customers_ReleaseSchedules:46]THC_State:39; $_THC_State; \
				[Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine)
			
			For ($i; 1; $numRecs; 1)
				
				xText:=xText+CUST_getName($_CustID{$i}; "elc")+$t+$_CustomerLine{$i}+$t+FG_getOutline($_ProductCode{$i})+$t+$_ProductCode{$i}+$t+String:C10($_THC_State{$i})+$t
				xText:=xText+txt_quote(THC_decode($_THC_State{$i}))+$t+String:C10($_Sched_Date{$i}; System date short:K1:1)+$t+String:C10($_Sched_Qty{$i})+$t
				If ($_THC_Qty{$i}>0)
					xText:=xText+String:C10($_THC_Qty{$i})+$t
				Else 
					xText:=xText+"0"+$t
				End if 
				xText:=xText+GetArtReceivedDate($_ProductCode{$i})+$t  // Added by: Mark Zinke (1/27/14) Add the Art Received Date
				
				xText:=xText+$_CustomerRefer{$i}+$t+txt_quote(JMI_plannedProduction($_ProductCode{$i}; $_OrderLine{$i}))+$t+$_Shipto{$i}+"-"+Replace string:C233(ADDR_getCity($_Shipto{$i}); ","; "-")+$t
				$numFG:=qryFinishedGood($_CustID{$i}; $_ProductCode{$i})
				xText:=xText+[Finished_Goods:26]Status:14+$t+[Finished_Goods:26]ControlNumber:61+$t+[Finished_Goods:26]PlateID:21+$t
				$cases:=PK_getCasesPerSkid([Finished_Goods:26]OutLine_Num:4)
				$packed_at:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
				packing_spec:=String:C10($cases)+"x"+String:C10($packed_at)+"="+String:C10($cases*$packed_at)
				
				xText:=xText+packing_spec
				
				If (cb10=0)
					
					xText:=xText+$r
					
				Else 
					
					$tPrice:=String:C10(FG_getLastPrice([Finished_Goods:26]FG_KEY:47))
					
					CmOL_THC_GetTotal($_CustID{$i}; $_ProductCode{$i}; ->$oCustomerTotal)
					
					xText:=xText+$t+\
						$tPrice+$t+\
						String:C10($oCustomerTotal.rTotalOrderLine)+$t+\
						String:C10($oCustomerTotal.rTotalOrderLineOverRun)+$t+\
						String:C10($oCustomerTotal.rTotalRelease)+$t+\
						String:C10($oCustomerTotal.rTotalInventory)+$t+\
						String:C10($oCustomerTotal.rTotalProduction)+$r
					
				End if 
				
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				uThermoUpdate($i)
			End for 
			
			
			uThermoClose
			
			SEND PACKET:C103($docRef; xText)
			SEND PACKET:C103($docRef; Char:C90(13)+Char:C90(13)+"------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			
			// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
			If (Count parameters:C259=0)
				$err:=util_Launch_External_App(docName)
			End if 
			
			REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
			
		Else 
			If (Count parameters:C259=0)
				BEEP:C151
				ALERT:C41("No releases were found with that criterion.")
			End if 
		End if 
		
	Else 
		If (Count parameters:C259=0)
			BEEP:C151
			ALERT:C41(docName+" could not be created.")
		End if 
	End if 
End if 