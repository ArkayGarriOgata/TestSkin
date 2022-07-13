//%attributes = {}

// Method: REL_WarnBadOrderStatus ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/23/15, 12:07:32
// ----------------------------------------------------
// Description
// email a warning if emenint releases will be blocked by BOL screen because of order status
//`looking for 3 business days
// ----------------------------------------------------
// Added by: Mel Bohince (6/28/19) require numeric char in PO

C_DATE:C307($1; $dateBegin; $dateEnd)
C_LONGINT:C283($weekday; $horizon)
C_TEXT:C284($salemen; $coordinator; $planner; $customerService)
If (Count parameters:C259=1)
	$dateBegin:=$1
Else 
	$dateBegin:=Current date:C33
	$dateBegin:=Date:C102(Request:C163("Look 3 days past:"; String:C10($dateBegin; Internal date short:K1:7); "Ok"; "Cancel"))
End if 

$weekday:=Day number:C114($dateBegin)  //sunday is 1

Case of   //looking for 3 business days
	: ($weekday<4)
		$horizon:=3
	: ($weekday<7)  //wed - fri, skip weekend
		$horizon:=5
	Else   //saturday, skip sunday
		$horizon:=4
End case 

$dateEnd:=$dateBegin+$horizon

$subject:="Cannot-Ship Releases "+String:C10($dateBegin; Internal date short:K1:7)+" - "+String:C10($dateEnd; Internal date short:K1:7)
$preheader:="Listing of Releases whose orderlines need attention before they can ship."
$body:=""

ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aRelease; 0)
ARRAY TEXT:C222($aOL; 0)
ARRAY TEXT:C222($aStatus; 0)
ARRAY TEXT:C222($aProblem; 0)
ARRAY TEXT:C222($aContact; 0)

// get firm releases in that date range
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")

ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12; >)  //to simplify mailing


C_LONGINT:C283($i; $numRecs)

$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])

uThermoInit($numRecs; "Checking Release orderlines")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numRecs)
		
		$problem:=""
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
		$orderline:=[Customers_ReleaseSchedules:46]OrderLine:4
		Case of 
			: (Records in selection:C76([Customers_Order_Lines:41])=0)
				$problem:="Missing"
				$orderline:="Not Found"
				
			: (Records in selection:C76([Customers_Order_Lines:41])>1)
				$problem:="Not Unique"
				$orderline:=String:C10(Records in selection:C76([Customers_Order_Lines:41]))+" found"
				
			: ([Customers_Order_Lines:41]Status:9="Hold@")
				$problem:="ON-HOLD"
				
			: ([Customers_Order_Lines:41]Status:9="Accept@")
				//pass
				
			: ([Customers_Order_Lines:41]Status:9="Budget@")
				//pass
				
			Else 
				$problem:="Status"
		End case 
		
		If (Length:C16($problem)>0)
			
			APPEND TO ARRAY:C911($aCPN; [Customers_ReleaseSchedules:46]ProductCode:11)
			APPEND TO ARRAY:C911($aRelease; String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1))
			APPEND TO ARRAY:C911($aOL; $orderline)
			APPEND TO ARRAY:C911($aStatus; [Customers_Order_Lines:41]Status:9)
			APPEND TO ARRAY:C911($aProblem; $problem)
			
			//figure out who to send it to, just one of the team
			$salemen:=""
			$coordinator:=""
			$planner:=""
			$customerService:=""
			If (Position:C15("edi"; [Customers_ReleaseSchedules:46]CustID:12)=0)
				Cust_getTeam([Customers_ReleaseSchedules:46]CustID:12; ->$salemen; ->$coordinator; ->$planner; ->$customerService)
				If (Length:C16($customerService)>0)
					APPEND TO ARRAY:C911($aContact; $customerService)
				Else 
					If (Length:C16($coordinator)>0)
						APPEND TO ARRAY:C911($aContact; $coordinator)
					Else 
						If (Length:C16($planner)>0)
							APPEND TO ARRAY:C911($aContact; $planner)
						Else 
							If (Length:C16($salemen)>0)
								APPEND TO ARRAY:C911($aContact; $salemen)
							Else 
								APPEND TO ARRAY:C911($aContact; "mlb")
							End if   //sales
						End if   //pln
					End if   //coord
				End if   //cs
			Else   //edi
				APPEND TO ARRAY:C911($aContact; "cvz")  //edi update needed
			End if   //edi
			
		End if   //prob
		
		
		NEXT RECORD:C51([Customers_ReleaseSchedules:46])
		uThermoUpdate($i)
	End for 
	
Else 
	
	ARRAY TEXT:C222($_OrderLine; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_ReleaseNumber; 0)
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY TEXT:C222($_CustomerRefer; 0)  // Added by: Mel Bohince (6/28/19) require numeric char in PO
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; \
		[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
		[Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; \
		[Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; \
		[Customers_ReleaseSchedules:46]CustID:12; $_CustID)
	
	For ($i; 1; $numRecs; 1)
		
		$problem:=""
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderLine{$i})
		$orderline:=$_OrderLine{$i}
		Case of 
			: (Records in selection:C76([Customers_Order_Lines:41])=0)
				$problem:="Missing"
				$orderline:="Not Found"
				
			: (Records in selection:C76([Customers_Order_Lines:41])>1)
				$problem:="Not Unique"
				$orderline:=String:C10(Records in selection:C76([Customers_Order_Lines:41]))+" found"
				
			: ([Customers_Order_Lines:41]Status:9="Hold@")
				$problem:="ON-HOLD"
				
			: ([Customers_Order_Lines:41]Status:9="Accept@")
				//pass
				
			: ([Customers_Order_Lines:41]Status:9="Budget@")
				//pass
				
			: (util_isOnlyAlpha([Customers_Order_Lines:41]PONumber:21))  // Added by: Mel Bohince (6/28/19) require numeric char in PO
				If (util_isOnlyAlpha($_CustomerRefer{$i}))
					$problem:="PO invalid"
				End if 
				
			Else 
				$problem:="Status"
		End case 
		
		If (Length:C16($problem)>0)
			
			APPEND TO ARRAY:C911($aCPN; $_ProductCode{$i})
			APPEND TO ARRAY:C911($aRelease; String:C10($_ReleaseNumber{$i}))
			APPEND TO ARRAY:C911($aOL; $orderline)
			APPEND TO ARRAY:C911($aStatus; [Customers_Order_Lines:41]Status:9)
			APPEND TO ARRAY:C911($aProblem; $problem)
			
			//figure out who to send it to, just one of the team
			$salemen:=""
			$coordinator:=""
			$planner:=""
			$customerService:=""
			If (Position:C15("edi"; $_CustID{$i})=0)
				Cust_getTeam($_CustID{$i}; ->$salemen; ->$coordinator; ->$planner; ->$customerService)
				If (Length:C16($customerService)>0)
					APPEND TO ARRAY:C911($aContact; $customerService)
				Else 
					If (Length:C16($coordinator)>0)
						APPEND TO ARRAY:C911($aContact; $coordinator)
					Else 
						If (Length:C16($planner)>0)
							APPEND TO ARRAY:C911($aContact; $planner)
						Else 
							If (Length:C16($salemen)>0)
								APPEND TO ARRAY:C911($aContact; $salemen)
							Else 
								APPEND TO ARRAY:C911($aContact; "mlb")
							End if   //sales
						End if   //pln
					End if   //coord
				End if   //cs
			Else   //edi
				APPEND TO ARRAY:C911($aContact; "cvz")  //edi update needed
			End if   //edi
			
		End if   //prob
		
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 

uThermoClose

//build an email for each contact
MULTI SORT ARRAY:C718($aContact; >; $aCPN; >; $aRelease; $aOL; $aStatus; $aProblem; >)
$numElements:=Size of array:C274($aContact)
$currentInitials:=""
$body:=""
uThermoInit($numElements; "Processing Array")
For ($i; 1; $numElements)
	If ($aContact{$i}#$currentInitials)
		If (Length:C16($body)>0)
			distributionList:=$emailAddress+", Kristopher.Koertge@arkay.com, mel.bohince@arkay.com,"
			//distributionList:="mel.bohince@arkay.com,"
			Email_html_table($subject; $preheader; $body; 600; distributionList)
		End if 
		
		//setup for next
		$currentInitials:=$aContact{$i}
		$emailAddress:=Email_WhoAmI(""; $currentInitials)
		$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$r:="</td></tr>"+Char:C90(13)
		
		$body:=$b+"ProductCode"+$t+"Release"+$t+"Orderline"+$t+"Status"+$t+"Problem"+$r
		
		$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
		$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	End if 
	
	$body:=$body+$b+$aCPN{$i}+$t+$aRelease{$i}+$t+$aOL{$i}+$t+$aStatus{$i}+$t+$aProblem{$i}+$r
	
	uThermoUpdate($i)
End for 
uThermoClose

If (Length:C16($body)>0)
	distributionList:=$emailAddress+", Kristopher.Koertge@arkay.com, mel.bohince@arkay.com,"
	//distributionList:="mel.bohince@arkay.com,"
	Email_html_table($subject; $preheader; $body; 600; distributionList)
End if 
