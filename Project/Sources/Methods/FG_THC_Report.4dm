//%attributes = {}
// Method: FG_THC_Report () -> 
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
// Modified by: Mel Bohince (10/25/21) call for processing on server, see FG_THC_ReportOLD for replaced code

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
docName:="THC_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"


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
	
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		CLOSE DOCUMENT:C267($docRef)
		
		If (sCustId="ALL")
			xTitle:=xTitle+$t+"ALL Customers"
			sCustId:="@"
		Else 
			xTitle:=xTitle+$t+CUST_getName(sCustid)+$r
		End if 
		
		
		If (cb6=1)
			xTitle:=xTitle+" with Forecasts,"
		End if 
		$includeForecasts:=(cb6=1)
		
		$includeAskMeTotals:=(cb10=1)
		
		
		xTitle:=xTitle+"Show THC's: "+$t
		
		C_COLLECTION:C1488($thcStates_c)
		C_OBJECT:C1216($params_o)
		$thcStates_c:=New collection:C1472  //(cb0;cb1;cb2;cb3;cb4;cb5;cb6;cb7;cb8;cb9;cb10)
		
		ARRAY LONGINT:C221($_THC_State; 0)
		If (cb0=1)
			xTitle:=xTitle+"0,"
			$thcStates_c.push("0")
		End if 
		If (cb1=1)
			xTitle:=xTitle+"1,"
			$thcStates_c.push("1")
		End if 
		If (cb2=1)
			xTitle:=xTitle+"2,"
			$thcStates_c.push("2")
		End if 
		If (cb3=1)
			xTitle:=xTitle+"3,"
			$thcStates_c.push("3")
		End if 
		If (cb4=1)
			xTitle:=xTitle+"4,"
			$thcStates_c.push("4")
		End if 
		If (cb5=1)
			xTitle:=xTitle+"5,"
			$thcStates_c.push("5")
		End if 
		
		//no THC 6 intentionally
		
		If (cb7=1)
			xTitle:=xTitle+"7,"
			$thcStates_c.push("7")
		End if 
		If (cb8=1)
			xTitle:=xTitle+"8 "
			$thcStates_c.push("8")
		End if 
		If (cb9=1)
			xTitle:=xTitle+"9 "
			$thcStates_c.push("9")
		End if 
		
		// Modified by: Mel Bohince (10/25/21) this is the execute on server call
		$params_o:=New object:C1471("customerId"; sCustId; "line"; ""; "forecasts"; $includeForecasts; "totals"; $includeAskMeTotals; "thc_states"; $thcStates_c)
		$csvText:=FG_THC_Report_EOS($params_o)
		
		$csvText:=xTitle+"\r\r"+$csvText+"\r\r------ END OF FILE ------"
		
		TEXT TO DOCUMENT:C1237(docName; $csvText)
		
		If (Count parameters:C259=0)
			$err:=util_Launch_External_App(docName)
		End if 
		
		
	Else 
		If (Count parameters:C259=0)
			BEEP:C151
			ALERT:C41(docName+" could not be created.")
		End if 
	End if 
End if 