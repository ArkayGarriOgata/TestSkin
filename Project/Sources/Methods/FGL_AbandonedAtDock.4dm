//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/28/13, 10:34:33
// ----------------------------------------------------
// Method: FGL_AbandonedAtDock
// Description:
// Queries the [Finished_Goods_Locations]Location record for FG:R_Shipped,
// Queries the [Finished_Goods_Transactions]JobIt for each Location,
// add up the plus and neg quantities. The remainder should equal what's in inventory.
// Ignore if there are any [Finished_Goods_Transactions]XactionType = "Adjust".
// This runs from the Batch called "Inventory Mismatch".
// ----------------------------------------------------

// Modified by: Mel Bohince (3/31/15) htmlize the email
// Modified by: Mel Bohince (9/8/16) make it look at all shipped locations, not just FG:R_Shipped, don't worry about the transactions adding up or when the next release is

C_LONGINT:C283($i; $j; $xlQtyShipped; $xlQtyCustomer; $xlDiff; $xlDaysBack; $xlDaysForward)
C_TEXT:C284($tSubject; $tBodyHeader; $tBody)
C_BOOLEAN:C305($bSendEmail)
C_DATE:C307($dNextRelease)
ARRAY TEXT:C222($atType; 0)
ARRAY TEXT:C222($atProdCode; 0)
ARRAY TEXT:C222($atQtyOH; 0)
ARRAY TEXT:C222($atOrigDate; 0)
ARRAY TEXT:C222($atNextRelDate; 0)


$dateBegin:=Current date:C33
//$weekday:=Day number($dateBegin)  //sunday is 1
//If ($weekday=Monday) | ($weekday=Thursday)

$tSubject:="Inventory Abandoned in location @Ship@"
$tBodyHeader:="The following products appear to have quantities left in a shipped location, please check them and make any adjustments needed."

$tBody:=""

$bSendEmail:=False:C215
$xlQtyShipped:=0
$xlQtyCustomer:=0
$xlDaysBack:=7  //Change this for more days back to check.
//$xlDaysForward:=14  //Change this for more days forward to check.

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="@Ship@"; *)  //has been in a ship location ...
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]OrigDate:27<=Current date:C33-$xlDaysBack)  // for at least a week
If (Records in selection:C76([Finished_Goods_Locations:35])>0)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
			GOTO SELECTED RECORD:C245([Finished_Goods_Locations:35]; $i)
			// Modified by: Mel Bohince (9/8/16) ignore matching the transactoins up
			//QUERY([Finished_Goods_Transactions];[Finished_Goods_Transactions]Jobit=[Finished_Goods_Locations]Jobit;*)
			//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]XactionDate<=Current date-$xlDaysBack)
			//DISTINCT VALUES([Finished_Goods_Transactions]XactionType;$atType)
			//If (Not(Find in array($atType;"Adjust")>0))  //Skip if "Adjust" found.
			//If (Records in selection([Finished_Goods_Transactions])>0)
			//For ($j;1;Records in selection([Finished_Goods_Transactions]))
			//GOTO SELECTED RECORD([Finished_Goods_Transactions];$j)
			//Case of 
			//: (Position("ship";[Finished_Goods_Transactions]Location)>0)  // Modified by: Mel Bohince (9/8/16) more general than just fg:r_shipped
			//$xlQtyShipped:=$xlQtyShipped+[Finished_Goods_Transactions]Qty
			
			//: ([Finished_Goods_Transactions]Location="Customer")
			//$xlQtyCustomer:=$xlQtyCustomer+[Finished_Goods_Transactions]Qty
			//End case 
			//End for 
			//End if 
			//End if 
			
			//$xlDiff:=$xlQtyShipped-$xlQtyCustomer
			$dNextRelease:=JMI_getNextReleaseDate([Finished_Goods_Locations:35]ProductCode:1; 0)
			
			//Send an email if the qtys don't match and no next release date or the release date is over 7 days in the future or the release date is in the past.
			//If (([Finished_Goods_Locations]QtyOH#$xlDiff) & (($dNextRelease=!00/00/0000!) | ($dNextRelease>(Current date+$xlDaysForward)) | ($dNextRelease<Current date)))
			If (True:C214)  // Modified by: Mel Bohince (9/8/16) send no matter when the  next release is
				$bSendEmail:=True:C214
				APPEND TO ARRAY:C911($atProdCode; [Finished_Goods_Locations:35]ProductCode:1)
				APPEND TO ARRAY:C911($atQtyOH; String:C10([Finished_Goods_Locations:35]QtyOH:9))
				APPEND TO ARRAY:C911($atOrigDate; String:C10([Finished_Goods_Locations:35]OrigDate:27; Internal date short special:K1:4))
				If ($dNextRelease#!00-00-00!)
					APPEND TO ARRAY:C911($atNextRelDate; String:C10($dNextRelease; Internal date short special:K1:4))
				Else 
					APPEND TO ARRAY:C911($atNextRelDate; "NONE")
				End if 
			End if 
			
			//$xlDiff:=0
			//$xlQtyShipped:=0
			//$xlQtyCustomer:=0
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY LONGINT:C221($_QtyOH; 0)
		ARRAY DATE:C224($_OrigDate; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; \
			[Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; \
			[Finished_Goods_Locations:35]OrigDate:27; $_OrigDate)
		
		For ($i; 1; Size of array:C274($_OrigDate); 1)
			$dNextRelease:=JMI_getNextReleaseDate($_ProductCode{$i}; 0)
			$bSendEmail:=True:C214
			APPEND TO ARRAY:C911($atProdCode; $_ProductCode{$i})
			APPEND TO ARRAY:C911($atQtyOH; String:C10($_QtyOH{$i}))
			APPEND TO ARRAY:C911($atOrigDate; String:C10($_OrigDate{$i}; Internal date short special:K1:4))
			If ($dNextRelease#!00-00-00!)
				APPEND TO ARRAY:C911($atNextRelDate; String:C10($dNextRelease; Internal date short special:K1:4))
			Else 
				APPEND TO ARRAY:C911($atNextRelDate; "NONE")
			End if 
			
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If ($bSendEmail)
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$r:="</td></tr>"+<>CR
	$tBody:=$tBody+$b+"Product Code"+$t+"Qty Docked"+$t+"Orig Date"+$t+"Next Release"+$r
	
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	
	SORT ARRAY:C229($atProdCode; $atQtyOH; $atOrigDate; $atNextRelDate; >)
	For ($i; 1; Size of array:C274($atProdCode))
		$tBody:=$tBody+$b+$atProdCode{$i}+$t+$atQtyOH{$i}+$t+$atOrigDate{$i}+$t+$atNextRelDate{$i}+$r
		//Case of 
		//: (Length($atProdCode{$i})=6)
		//$tBody:=$tBody+<>TB+$atQtyOH{$i}+<>TB+<>TB
		//: (Length($atProdCode{$i})>6)
		//$tBody:=$tBody+$atQtyOH{$i}+<>TB+<>TB
		//End case 
		//$tBody:=$tBody+$atOrigDate{$i}+<>TB
		//$tBody:=$tBody+$atNextRelDate{$i}+<>CR
	End for 
	//EMAIL_Sender ($tSubject;$tBodyHeader;$tBody;distributionList)
	//distributionList:="mel.bohince@arkay.com"
	Email_html_table($tSubject; $tBodyHeader; $tBody; 560; distributionList)
End if 

//End if   //monday or thursday
