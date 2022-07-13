//%attributes = {"publishedWeb":true}
//JML_EmailChgMAD 02/12/02
//@author mlb - 02/12/02
//• mlb - 3/11/03  16:48 add release list
// Modified by: Mel Bohince (3/21/18) added closing date (gateway)
// Modified by: Mel Bohince (6/21/18) add cc list and include frank if date changed by not frank
// Modified by: Garri Ogata (8/27/21) added multiple CS reps

C_TEXT:C284(distributionList; $body; $subject; $from; $ccList)
C_TEXT:C284($tTableName; $tQuery)
C_OBJECT:C1216($esCustomers)
$esCustomers:=New object:C1471()

$ccList:=""
distributionList:=""
READ ONLY:C145([Users:5])

$tTableName:=Table name:C256(->[Customers:16])  // Modified by: Garri Ogata (8/26/21) add multiple customer service

$tQuery:="Name = "+CorektSingleQuote+[Job_Forms_Master_Schedule:67]Customer:2+CorektSingleQuote

$esCustomers:=ds:C1482[$tTableName].query($tQuery)

If ($esCustomers.length=1)
	
	$eCustomer:=$esCustomers.first()
	
	C_OBJECT:C1216($oPeople)  // Modified by: Garri Ogata (8/26/21) People object
	$oPeople:=New object:C1471()
	$oPeople.tCustomerID:=$eCustomer.ID
	$oPeople.bCustomerService:=True:C214
	distributionList:=Cust_GetEmailsT($oPeople)
	
End if 

QUERY:C277([Users:5]; [Users:5]Initials:1=custServiceRep)  //• mlb - 2/21/02  11:34

If (Records in selection:C76([Users:5])>0)
	
	distributionList:=distributionList+Email_WhoAmI([Users:5]UserName:11; custServiceRep)+<>TB
	
End if 

QUERY:C277([Users:5]; [Users:5]Initials:1=plannerOnRecord)
If (Records in selection:C76([Users:5])>0)
	$planner:=Email_WhoAmI([Users:5]UserName:11)+<>TB
	If (Position:C15($planner; distributionList)=0)
		distributionList:=distributionList+$planner
	End if 
End if 

QUERY:C277([Users:5]; [Users:5]Initials:1=coordinator)
If (Records in selection:C76([Users:5])>0)
	$planner:=Email_WhoAmI([Users:5]UserName:11)+<>TB
	If (Position:C15($planner; distributionList)=0)
		distributionList:=distributionList+$planner
	End if 
End if 

If (Position:C15(salesrep; " LHC ")>0)
	QUERY:C277([Users:5]; [Users:5]Initials:1=salesrep)
	If (Records in selection:C76([Users:5])>0)
		$planner:=Email_WhoAmI([Users:5]UserName:11)+<>TB
		If (Position:C15($planner; distributionList)=0)
			distributionList:=distributionList+$planner  //+"mel.bohince@arkay.com"+<>TB
		End if 
	End if 
End if 

If (Current user:C182#"Designer")
	$ccList:="Kristopher.Koertge@arkay.com"+<>TB  // craig.bradley@arkay.com
	
	If (<>zResp#"FFC")
		$ccList:=$ccList+"frank.clark@arkay.com"+<>TB
	End if 
	
Else 
	distributionList:="mel.bohince@arkay.com"+<>TB
End if 

C_TEXT:C284($affected)  //• mlb - 3/11/03  16:48
$affected:="Releases that may be impacted by this date change:"+<>CR+JML_getReleaseList([Job_Forms_Master_Schedule:67]JobForm:4)+<>CR

$firstRel:=<>CR+"BTW: It looks like the 1st Release pegged to this job is on "+String:C10([Job_Forms_Master_Schedule:67]FirstReleaseDat:13; System date short:K1:1)+"."
If (Old:C35([Job_Forms_Master_Schedule:67]MAD:21)#!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]MAD:21>Old:C35([Job_Forms_Master_Schedule:67]MAD:21))
		$body:="Your greatest fears are true; "+<>CR
		$body:=$body+"the new date is "+String:C10([Job_Forms_Master_Schedule:67]MAD:21-Old:C35([Job_Forms_Master_Schedule:67]MAD:21))+" days past the original agreement."+<>CR
		$body:=$body+"Maybe you should look for existing inventory."+<>CR
		$subject:="8-( HRD has Changed on "+[Job_Forms_Master_Schedule:67]JobForm:4+" "+[Job_Forms_Master_Schedule:67]Line:5+"-"+[Job_Forms_Master_Schedule:67]Customer:2
	Else 
		$body:="You're never going to believe this, but "+<>CR
		$body:=$body+"the new date is "+String:C10([Job_Forms_Master_Schedule:67]MAD:21-Old:C35([Job_Forms_Master_Schedule:67]MAD:21))+" days BEFORE the original agreement."+<>CR
		$body:=$body+"You should feel honored!"+<>CR
		
		$subject:="8-) HRD has Changed on "+[Job_Forms_Master_Schedule:67]JobForm:4+" "+[Job_Forms_Master_Schedule:67]Line:5+"-"+[Job_Forms_Master_Schedule:67]Customer:2
	End if 
	
	
	$body:=$body+<>CR
	//$body:=$body+"HRD was "+String([JobMasterLog]MAD;Abbreviated )+<>CR
	$body:=$body+"HRD was "+String:C10(Old:C35([Job_Forms_Master_Schedule:67]MAD:21); System date abbreviated:K1:2)+<>CR
	$body:=$body+"HRD now "+String:C10([Job_Forms_Master_Schedule:67]MAD:21; System date abbreviated:K1:2)+<>CR
	$body:=$body+"Closing date is "+String:C10([Job_Forms_Master_Schedule:67]GateWayDeadLine:42; System date abbreviated:K1:2)+<>CR  // Modified by: Mel Bohince (3/21/18) added closing date (gateway)
	$body:=$body+$affected+$firstRel
	
Else 
	$body:="Finally, what you've waited so long for; "+<>CR
	$body:=$body+"the HRD was set to "+String:C10([Job_Forms_Master_Schedule:67]MAD:21; System date abbreviated:K1:2)+<>CR
	$body:=$body+"I hope this exceeds your expectations!"+<>CR
	$body:=$body+$affected+$firstRel
	$subject:="HRD was set for "+[Job_Forms_Master_Schedule:67]JobForm:4+" "+[Job_Forms_Master_Schedule:67]Line:5
End if 

$body:=$body
$from:=Email_WhoAmI

EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from; ""; $ccList)
zwStatusMsg("EMail"; "HRD change has been sent to "+distributionList)