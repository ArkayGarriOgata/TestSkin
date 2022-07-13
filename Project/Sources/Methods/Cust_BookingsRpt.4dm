//%attributes = {}
// Method: Cust_BookingsRpt () -> 
// ----------------------------------------------------
// by: mel: 08/18/05, 10:04:21
// ----------------------------------------------------
// Modified by: Mel Bohince (8/30/21) change to CSV, remove 4D_ps if, use cust_getname

C_TIME:C306($docRef)
C_TEXT:C284($t; $cr)
C_LONGINT:C283($fiscalYear; $1)
C_TEXT:C284($year)

$t:=","  //Char(9)
$cr:="\r"  //Char(13)

If (Count parameters:C259=1)
	$fiscalYear:=$1
	OK:=1
Else 
	$year:=FiscalYear("year"; Current date:C33)
	$fiscalYear:=Num:C11(Request:C163("For which fiscal year"; $year; "OK"; "Cancel"))
End if 

If (OK=1)
	QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear)
	ORDER BY:C49([Customers_Bookings:93]; [Customers_Bookings:93]BookedYTD:3; <)
	
	docName:="Bookings"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	$docRef:=util_putFileName(->docName)
	If (User in group:C338(Current user:C182; "RoleAccounting")) | (User in group:C338(Current user:C182; "SalesManager"))
		
		SEND PACKET:C103($docRef; "CustomerName"+$t+"BookedYTD"+$t+"BookedChange"+$t+"BookedYesterday"+$t+"CostYTD"+$t+"PV_YTD"+$t+"Period1"+$t+"Period2"+$t+"Period3"+$t+"Period4"+$t+"Period5"+$t+"Period6"+$t+"Period7"+$t+"Period8"+$t+"Period9"+$t+"Period10"+$t+"Period11"+$t+"Period12"+$t+"QTY_YTD"+$cr)
		
		ARRAY TEXT:C222($_CustomerName; 0)
		ARRAY TEXT:C222($_Custid; 0)  // Modified by: Mel Bohince (8/30/21) 
		ARRAY REAL:C219($_BookedYTD; 0)
		ARRAY REAL:C219($_BookedChange; 0)
		ARRAY REAL:C219($_BookedYesterday; 0)
		ARRAY REAL:C219($_CostYTD; 0)
		ARRAY REAL:C219($_PV_YTD; 0)
		ARRAY REAL:C219($_Period1; 0)
		ARRAY REAL:C219($_Period2; 0)
		ARRAY REAL:C219($_Period3; 0)
		ARRAY REAL:C219($_Period4; 0)
		ARRAY REAL:C219($_Period5; 0)
		ARRAY REAL:C219($_Period6; 0)
		ARRAY REAL:C219($_Period7; 0)
		ARRAY REAL:C219($_Period8; 0)
		ARRAY REAL:C219($_Period9; 0)
		ARRAY REAL:C219($_Period10; 0)
		ARRAY REAL:C219($_Period11; 0)
		ARRAY REAL:C219($_Period12; 0)
		ARRAY LONGINT:C221($_QuantityYTD; 0)
		
		SELECTION TO ARRAY:C260([Customers_Bookings:93]CustomerName:18; $_CustomerName; [Customers_Bookings:93]Custid:1; $_Custid; [Customers_Bookings:93]BookedYTD:3; $_BookedYTD; [Customers_Bookings:93]BookedChange:5; $_BookedChange; [Customers_Bookings:93]BookedYesterday:4; $_BookedYesterday; [Customers_Bookings:93]CostYTD:19; $_CostYTD; [Customers_Bookings:93]PV_YTD:20; $_PV_YTD; [Customers_Bookings:93]Period1:6; $_Period1; [Customers_Bookings:93]Period2:7; $_Period2; [Customers_Bookings:93]Period3:8; $_Period3; [Customers_Bookings:93]Period4:9; $_Period4; [Customers_Bookings:93]Period5:10; $_Period5; [Customers_Bookings:93]Period6:11; $_Period6; [Customers_Bookings:93]Period7:12; $_Period7; [Customers_Bookings:93]Period8:13; $_Period8; [Customers_Bookings:93]Period9:14; $_Period9; [Customers_Bookings:93]Period10:15; $_Period10; [Customers_Bookings:93]Period11:16; $_Period11; [Customers_Bookings:93]Period12:17; $_Period12; [Customers_Bookings:93]QuantityYTD:23; $_QuantityYTD)
		
		For ($i; 1; Size of array:C274($_Custid))
			$_CustomerName{$i}:=CUST_getName($_Custid{$i}; "elc")
			SEND PACKET:C103($docRef; CUST_getName($_Custid{$i}; "elc")+$t+String:C10($_BookedYTD{$i})+$t+String:C10($_BookedChange{$i})+$t+String:C10($_BookedYesterday{$i})+$t+String:C10($_CostYTD{$i})+$t+String:C10($_PV_YTD{$i})+$t+String:C10($_Period1{$i})+$t+String:C10($_Period2{$i})+$t+String:C10($_Period3{$i})+$t+String:C10($_Period4{$i})+$t+String:C10($_Period5{$i})+$t+String:C10($_Period6{$i})+$t+String:C10($_Period7{$i})+$t+String:C10($_Period8{$i})+$t+String:C10($_Period9{$i})+$t+String:C10($_Period10{$i})+$t+String:C10($_Period11{$i})+$t+String:C10($_Period12{$i})+$t+String:C10($_QuantityYTD{$i})+$cr)
		End for 
		
		
		$endFormula:=String:C10(Records in selection:C76([Customers_Bookings:93])+1)+")"+$t  //account for totals
		$column:="ABCDEFGHIJKLMNOPQRSTUVWXYZ"  //enumeration so offset ≤≥ can be used
		$totals:="    TOTALS"+$t
		For ($i; 2; 18)
			If ($i#6)
				$totals:=$totals+"=SUM("+$column[[$i]]+"2:"+$column[[$i]]+$endFormula  //"=SUM(B2:B56)"
			Else 
				$totals:=$totals+"=AVERAGE("+$column[[$i]]+"2:"+$column[[$i]]+$endFormula
			End if 
		End for 
		
		SEND PACKET:C103($docRef; $totals+$cr)
		
	Else 
		SEND PACKET:C103($docRef; "REPORT NOT AUTHORIZED")
	End if 
	
	CLOSE DOCUMENT:C267($docRef)
	
	If (Count parameters:C259=0)
		$err:=util_Launch_External_App(docName)
	End if 
End if 