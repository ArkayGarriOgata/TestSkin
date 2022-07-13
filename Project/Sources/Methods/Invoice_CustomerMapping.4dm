//%attributes = {"publishedWeb":true}
//PM:  Invoice_CustomerMapping  5/07/99  MLB
//convert an ams custid and bill to into a Dynamics account id
//•052899  mlb  UPR236 
//•060199  mlb  lengthen prefix to accept preprocessed cust name
//•060299  mlb  remove underscore substitution and permit <5 length
//•6/10/99  MLB  change to Billto only method
//•6/18/99  MLB  exclude "The " if in the name
//• mlb - 8/9/01  10:38 get ready for flexware

C_TEXT:C284($1; $billtoid)  //$pad;`;$2;$custid
C_TEXT:C284($0)
C_TEXT:C284($prefix)  //•060199  mlb  

If (Count parameters:C259=1)
	//$custid:=$1
	$billtoid:=$1
	//If ([CUSTOMER]ID # $custid)
	//QUERY([CUSTOMER];[CUSTOMER]ID=$custid)
	//End if 
	If ([Addresses:30]ID:1#$billtoid)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$billtoid)
	End if 
	
	If (<>FlexwareActive) | (<>AcctVantageActive) | (<>OpenAccountsActive)
		$prefix:=Uppercase:C13([Addresses:30]FlexwarePrefix:37)
		If (Length:C16($prefix)=0)
			$prefix:="#ER"
		End if 
	Else   //dynamics still
		//$prefix:=Uppercase([Addresses]DynamicsPrefix)
		//If (Length($prefix)=0)  //•060299  mlb
		//$prefix:="#ERR#"
		//End if 
	End if 
	//••••DON"T UNLOAD THE RECORD!
	
Else   //applied directly to customerMaster, just prefix  
	$custid:=""
	$billtoid:=""
	//$prefix:=Replace string([CUSTOMER]Name;" ";"")
	If (Substring:C12([Addresses:30]Name:2; 1; 4)="The ")  //•6/18/99  MLB  
		$prefix:=Substring:C12([Addresses:30]Name:2; 5)
	Else 
		$prefix:=[Addresses:30]Name:2
	End if 
	$prefix:=Replace string:C233($prefix; " "; "")
	$prefix:=Replace string:C233($prefix; "."; "")
	$prefix:=Replace string:C233($prefix; ","; "")
	$prefix:=Replace string:C233($prefix; "-"; "")  //•060299  mlb
	$prefix:=Replace string:C233($prefix; "/"; "")  //•060299  mlb
	$prefix:=Substring:C12($prefix; 1; 5)
	//$prefix:=Replace string($prefix;" ";"_")
	//$prefix:=Replace string($prefix;".";"_")
	//$prefix:=Replace string($prefix;",";"_")
	//$prefix:=Replace string($prefix;"/";"_")
	//$prefix:=Replace string($prefix;"é";"e")` this messes up the capital E's
	//$prefix:=Replace string($prefix;"-";"_")
	//$prefix:=Replace string($prefix;"'";"_")
	utl_Trace
	//$pad:=5*"_" `•060299  mlb
	$prefix:=Uppercase:C13($prefix)  //Change string($pad;$prefix;1)) `•060299  mlb
End if 

$0:=$prefix+$billtoid