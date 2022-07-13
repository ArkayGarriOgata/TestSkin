//%attributes = {}

// Method: Est_Send_Priced_Ltr_html ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/26/15, 17:22:28
// ----------------------------------------------------
// Description
// based on Est_Send_Priced_Letter
//
// ----------------------------------------------------
// Modified by: Mel Bohince (3/26/15) html'ize the mailing
// Modified by: Garri Ogata (9/13/21) Added User_Valid_ToUseB
// Modified by: MelvinBohince (6/6/22) refactor User_Valid_ToUseB , rename to Email_userNotBlackListed

//$debug:=True
//If ($debug)
//QUERY([Estimates];[Estimates]EstimateNo="8-2335.02")
//End if 

C_TEXT:C284($noticeTo; $body; $subject; $from; $customer_service; $customer_service2)
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)

C_COLLECTION:C1488($alwaysGetCCd_c; $distroList_c)  //collections to hold user INITIALS

$alwaysGetCCd_c:=New collection:C1472("KK")  //kristopher.koertge@arkay.com

Cust_getTeam([Estimates:17]Cust_ID:2; ->[Estimates:17]Sales_Rep:13; ->[Estimates:17]SaleCoord:46; ->[Estimates:17]PlannedBy:16; ->$customer_service; ->$customer_service2)
$distroList_c:=New collection:C1472([Estimates:17]Sales_Rep:13; [Estimates:17]SaleCoord:46; [Estimates:17]PlannedBy:16; $customer_service)
$distroList_c.combine($alwaysGetCCd_c)

$noticeTo:=""
For each ($teamMember; $distroList_c)
	
	If (Email_userNotBlackListed(Current method name:C684; $teamMember))
		
		$user_e:=ds:C1482.Users.query("Initials = :1"; $teamMember).first()
		If ($user_e#Null:C1517)
			$noticeTo:=$noticeTo+Email_WhoAmI($user_e.UserName)+$t
		End if 
		
	End if   //black list
	
End for each 

//special customer add-ons
Case of 
	: ([Estimates:17]Cust_ID:2="00074")  //Eliz Arden
		//$noticeTo:=$noticeTo+"anna.soto@arkay.com"+$t
		
	: ([Estimates:17]Cust_ID:2="00199")  //PnG 
		//$noticeTo:=$noticeTo+"Shannon.Seyda@arkay.com"+$t
		
	: ([Estimates:17]Cust_ID:2="01547")  //Inter-parfums
		//$noticeTo:=$noticeTo+"Patty.Hunold@arkay.com"+$t
		
		//: ([Estimates]Cust_ID="01691")  `nu-world
		//$noticeTo:=$noticeTo+"Patty.Hunold@arkay.com@arkay.com"+$t
End case 

$subject:="Estimate "+[Estimates:17]EstimateNo:1+" has been priced"
$body:="Estimate "+[Estimates:17]EstimateNo:1+" for "+[Estimates:17]CustomerName:47+"'s "+[Estimates:17]Brand:3+" has been priced and may now be quoted."

//$noticeTo:="mel.bohince@arkay.com"+$t

QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=([Estimates:17]EstimateNo:1+"@"))

ARRAY TEXT:C222(asDiff; 0)
ARRAY TEXT:C222(asCaseID; 0)
SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; asCaseID; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff; [Estimates_Differentials:38]ProcessSpec:5; $aPspec)
$numDiffs:=Size of array:C274(asDiff)
SORT ARRAY:C229(asCaseID; asDiff; $aPspec; >)
If ($numDiffs>1)
	$count:=" of "+String:C10($numDiffs)+" differentials "
Else 
	$count:=" "
End if 

$body:=$body+Char:C90(13)+Char:C90(13)+String:C10(4D_Current_date; 5)+$r+$r
$body:=$body+fGetAddressText([Estimates:17]z_Bill_To_ID:5)+$r+$r
$body:=$body+"Dear "+[Addresses:30]Name:2+":"+$r+$r

$closing:="Committed to Excellence through Price Effectiveness, Quality, Dependability,"
$closing:=$closing+" Flexibility and Innovation."+$r+$r


$prehead:=""
$prehead:=$prehead+"We are pleased to submit our proposal"+$count+"based upon our understanding of your "
$prehead:=$prehead+"specifications and our terms which appear on the reverse of this proposal."

$template:=""
$template:=$template+"<!doctype html><html>"
$template:=$template+"<head>"
$template:=$template+"<title>Quote</title>"
$template:=$template+"</head><body>"

$template:=$template+"<header><h1>Quote "+[Estimates:17]EstimateNo:1+"</h1>"
$template:=$template+"<p>"+$prehead+"</p></header>"

$template:=$template+"<div><div>"
//REPEAT AS NEEDED:
$template:=$template+"<h2>Option {{opt-num}}) {{opt-name}}</h2>"
$template:=$template+"<h3>DESCRIPTION</h3>"
$template:=$template+"<p>{{opt-description}}</p>"
$template:=$template+"<h3>PRICING DETAILS </h3>"
$template:=$template+"<p>{{opt-pricing}}</p>"
$template:=$template+"<h3>STOCK</h3>"
$template:=$template+"<p>{{opt-stock}}</p>"
$template:=$template+"<h3>PRESS WORK</h3>"
$template:=$template+"<h4>FRONTSIDE</h4>"
$template:=$template+"<p>{{opt-front}}</p>"
$template:=$template+"<h4>BACKSIDE</h4>"
$template:=$template+"<p>{{opt-back}}</p>"
$template:=$template+"<h3>FINISHING</h3>"
$template:=$template+"<p>{{opt-finishing}}</p>"

$template:=$template+"<h3>ITEMS</h3>"
$template:=$template+"<table>"
$template:=$template+"<tr>"
$template:=$template+"<th>PRODUCT CODE</th>"
$template:=$template+"<th>SIZE</th>"
$template:=$template+"<th>STYLE</th>"
$template:=$template+"<th style=\"text-align:right\\>QTY</th>"
$template:=$template+"<th style=\"text-align:right\\>$PRICE/M</th>"
$template:=$template+"<th style=\"text-align:right\\>YLD-QTY</th>"
$template:=$template+"<th style=\"text-align:right\\>YLD-$PRICE/M</th>"
$template:=$template+"<th style=\"text-align:center\">%OVER/%UNDER</th>"
$template:=$template+"</tr>"

//INNER REPEAT AS NEEDED:
$templateItem:=$templateItem+"<tr>"
$templateItem:=$templateItem+"<td>{{cpn}} </td>"
$templateItem:=$templateItem+"<td>{{size}}</td>"
$templateItem:=$templateItem+"<td>{{style}}</td>"
$templateItem:=$templateItem+"<td style=\"text-align:right\">{{qty}} </td>"
$templateItem:=$templateItem+"<td style=\"text-align:right\">{{price}}</td>"
$templateItem:=$templateItem+"<td style=\"text-align:right\">{{y-qty}}</td>"
$templateItem:=$templateItem+"<td style=\"text-align:right\">{{y-price}}</td>"
$templateItem:=$templateItem+"<td style=\"text-align:center\">{{over-under}}</td>"
$templateItem:=$templateItem+"</tr>"
//end inner repeat

$templateEnd:=$templateEnd+"</table></div></div></body></html>"

For ($diff; 1; $numDiffs)
	$optNum:=""
	$optName:=""
	$optDescription:=""
	$optPricing:=""
	$optStock:=""
	$optFront:=""
	$optBack:=""
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$aPspec{$i})
	gRptQuoteBody($i; 1)
	$body:=$body+sIntro
	
	For ($carton; 1; $numCartons)
		$optNum:=""
		$optName:=""
		$optDescription:=""
		$optPricing:=""
		$optStock:=""
		$optFront:=""
		$optBack:=""
		
		NEXT RECORD:C51([Estimates_Carton_Specs:19])
	End for 
	
	NEXT RECORD:C51([Estimates_Differentials:38])
End for 

$body:=$body+"PREPARATION:"+$t+"To be determined upon receipt of final art."+$r+$r
$body:=$body+"PACKING:"+$t+"275lb Test Corrugated Cartons "+[Estimates_Carton_Specs:19]SpecialPacking:50+$r+$r
$body:=$body+"TERMS:"+$t+[Estimates:17]Terms:7+$r+$r

$body:=$body+$r+$r  //closing

$body:=$body+"Respectfully,"+$r+$r+$r
//MESSAGE(Char(13)+"       Closing ")
QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Estimates:17]Sales_Rep:13)
$body:=$body+[Salesmen:32]FirstName:3+" "+[Salesmen:32]MI:4+" "+[Salesmen:32]LastName:2
If ([Salesmen:32]Title:6#"")
	$body:=$body+", "+[Salesmen:32]Title:6
End if 
$body:=$body+$r
$body:=$body+[Salesmen:32]BusTitle:7+$r

$body:=$body+$closing
$from:=Email_WhoAmI

If ($debug)
	$noticeTo:="mel.bohince@arkay.com"
End if 
//EMAIL_Sender ($subject;"";$html;$noticeTo;"";$from;$from;$emailHeader)
EMAIL_Sender($subject; ""; $body; $noticeTo; ""; $from; $from)