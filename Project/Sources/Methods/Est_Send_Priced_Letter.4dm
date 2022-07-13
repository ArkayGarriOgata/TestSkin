//%attributes = {}
// Method: Est_Send_Priced_Letter()  --> 
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/30/07, 10:16:07
// ----------------------------------------------------
// Description
// email estimate to salemen when rfq has been priced
// see also Est_Send_Priced_Ltr_html
// ----------------------------------------------------
// Modified by: Mel Bohince (2/5/14) add c/s
// Modified by: Garri Ogata (9/13/21) Added User_Valid_ToUseB
// Modified by: MelvinBohince (6/6/22) refactor User_Valid_ToUseB , rename to Email_userNotBlackListed
// Modified by: MelvinBohince (6/8/22) get the 2nd customer service, don't email to terminated employees

C_TEXT:C284($noticeTo; $body; $subject; $from; $customer_service; $teamMember; $customer_service2)
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)

//$debug:=True
//If ($debug)
//QUERY([Estimates];[Estimates]EstimateNo="2-0930.01")
//End if 

C_COLLECTION:C1488($alwaysGetCCd_c; $distroList_c)  //collections to hold user INITIALS

$alwaysGetCCd_c:=New collection:C1472("KK")  //kristopher.koertge@arkay.com

Cust_getTeam([Estimates:17]Cust_ID:2; ->[Estimates:17]Sales_Rep:13; ->[Estimates:17]SaleCoord:46; ->[Estimates:17]PlannedBy:16; ->$customer_service; ->$customer_service2)

$distroList_c:=New collection:C1472([Estimates:17]Sales_Rep:13; [Estimates:17]SaleCoord:46; [Estimates:17]PlannedBy:16; $customer_service; $customer_service2)
$distroList_c.combine($alwaysGetCCd_c)
$distroList_c:=$distroList_c.distinct()

//Repeat 
//$index:=$distroList_c.indexOf("")
//if($index>-1)
//$distroList_c.remove($index)
//End if
//Until($index=-1)

$noticeTo:=""
C_OBJECT:C1216($user_e; $user_es)

For each ($teamMember; $distroList_c)
	
	If (Email_userNotBlackListed(Current method name:C684; $teamMember))
		
		$user_es:=ds:C1482.Users.query("Initials = :1 and DOT = :2"; $teamMember; !00-00-00!)  //skip if terminated
		If ($user_es.length>0)
			$user_e:=$user_es.first()
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
$body:=$body+"We are pleased to submit our proposal"+$count+"based upon our understanding of your "
$body:=$body+"specifications and our terms which appear on the reverse of this proposal."+$r+$r
$closing:="Committed to Excellence through Price Effectiveness, Quality, Dependability,"
$closing:=$closing+" Flexibility and Innovation."+$r+$r
xText2:=""  //don't add closing to each letter


For ($i; 1; $numDiffs)
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$aPspec{$i})
	gRptQuoteBody($i; 1)
	$body:=$body+sIntro
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

EMAIL_Sender($subject; ""; $body; $noticeTo; ""; $from; $from)
