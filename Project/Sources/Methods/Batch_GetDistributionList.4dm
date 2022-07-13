//%attributes = {"publishedWeb":true}
//Method: Batch_GetDistributionList(batchName{;hardcoded_list_name}) ->text  042299  MLB
//return a list of email addresses for a given batch run
//run w/o parameters to create a new batch distribution record

// Modified by: Mel Bohince (2/7/14) hardcode option $2 better than distributing everywhere
// Modified by: Mel Bohince (3/29/17) add "lynn.carden@arkay.com", the new darlene
// Modified by: Mel Bohince (2/23/18) add "heather.webb@arkay.com"+$t+"joann.holland@arkay.com"+$t+"irma.osornio@arkay.com"+$t to qa_move
// Modified by: Mel Bohince (1/10/19) replace Melody with Scott in acctg
// Modified by: Mel Bohince (7/30/19) soft code the QA Move list
// Modified by: Mel Bohince (5/4/20) remove Scott, refactored, soft code all email addresses, see _version20200504
// Modified by: Mel Bohince (8/26/20) set $makeNew to true

C_TEXT:C284($1; $batchName; $2; $0; $email_address_list; $t)
C_BOOLEAN:C305($makeNew)
$makeNew:=True:C214

$t:=Char:C90(9)
$email_address_list:=""

READ ONLY:C145([y_batches:10])
READ ONLY:C145([y_batch_distributions:164])

Case of 
	: (Count parameters:C259=1)
		$batchName:=$1
		
	: (Count parameters:C259=2)  //the second param was for backward compatibility with the old hardcode way at the bottom of this method
		$batchName:=$2
		
	Else 
		$batchName:=Request:C163("What is the new batch's name?"; ""; "Create"; "Cancel")  //"test_autoincrement"
		If (ok=1) & (Length:C16($batchName)>0)
			$makeNew:=True:C214
		End if 
End case 

QUERY:C277([y_batches:10]; [y_batches:10]BatchName:1=$batchName)
If (Records in selection:C76([y_batches:10])>0)
	QUERY:C277([y_batch_distributions:164]; [y_batch_distributions:164]BatchName:1=$batchName)
	SELECTION TO ARRAY:C260([y_batch_distributions:164]EmailAddress:2; $emailaddress)
	$email_address_list:=util_textFromArray_implode(->$emailaddress; $t)
	
Else   //make a new distribution
	If ($makeNew)
		CREATE RECORD:C68([y_batches:10])
		[y_batches:10]BatchName:1:=$batchName
		[y_batches:10]Monthly:7:=False:C215
		[y_batches:10]Description:2:="new_batch_distribution"
		[y_batches:10]sort_order:3:=890
		SAVE RECORD:C53([y_batches:10])
		
		CREATE RECORD:C68([y_batch_distributions:164])
		[y_batch_distributions:164]BatchName:1:=$batchName
		[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
		SAVE RECORD:C53([y_batch_distributions:164])
		
		$email_address_list:=[y_batch_distributions:164]EmailAddress:2+$t
		zwStatusMsg($batchName; "Created")
	Else 
		BEEP:C151
		zwStatusMsg($batchName; "Not Found or Created")
	End if 
End if 

UNLOAD RECORD:C212([y_batches:10])
UNLOAD RECORD:C212([y_batch_distributions:164])

$0:=$email_address_list

If (False:C215)  //old way
	//Case of   //Hard coded
	//: ($batchName="QA_MOVE")  //Batch_GetDistributionList("";"QA_MOVE")
	//$email_address_list:="john.sheridan@arkay.com"+$t+"lisa.dirsa@arkay.com"+$t+"eliedny.vega@arkay.com"+$t+"Trisha.Oconnor@arkay.com"+$t
	//$email_address_list:=$email_address_list+"heather.webb@arkay.com"+$t+"rhonda.justice@arkay.com"+$t+"irma.osornio@arkay.com"+$t
	
	//: ($batchName="ACCTG")  //Batch_GetDistributionList("";"ACCTG")
	//$email_address_list:="jill.cook@arkay.com"+$t+"mel.bohince@arkay.com"+$t+"lynn.carden@arkay.com"+$t+"scott.sarver@arkay.com"+$t  //"darlene.triglia@arkay.com"+$t+ // Modified by: Mel Bohince (3/1/17) darlene is gone
	
	//: ($batchName="ACCPLN")  //Batch_GetDistributionList("";"ACCTG")
	//$email_address_list:="jill.cook@arkay.com"+$t+"mel.bohince@arkay.com"+$t+"Kristopher.Koertge@arkay.com"+$t
	
	//: ($batchName="PROD")  //Batch_GetDistributionList("";"PROD")
	//$email_address_list:="Kristopher.Koertge@arkay.com, frank.clark@arkay.com,"+"john.sheridan@arkay.com, "+"mel.bohince@arkay.com,"
	
	//: ($batchName="PREPRESS")  //Batch_GetDistributionList("";"PREPRESS")
	//$email_address_list:="brian.hopkins@arkay.com"+$t+"jerry.duckett@arkay.com"+$t+"mel.bohince@arkay.com,"
	
	//: ($batchName="RAMA")
	//$email_address_list:="kristopher.koertge@arkay.com,"+"Walter.Shiels@arkay.com,"+"mel.bohince@arkay.com,"
	
	//: ($batchName="A/R")
	//$email_address_list:="mel.bohince@arkay.com,"+"scott.sarver@arkay.com,"+"lynn.carden@arkay.com,"+"jill.cook@arkay.com,"+"debra.mckibbin@arkay.com,"
	
	//: ($batchName="A/P")  // Modified by: Mel Bohince (8/2/16) 
	//$email_address_list:="mel.bohince@arkay.com,"+"Laura.Gader@arkay.com,"+"lynn.carden@arkay.com,"+"jill.cook@arkay.com,"  //+"darlene.triglia@arkay.com,"
	
	//: ($batchName="RM_AGING")  //Batch_GetDistributionList("";"RM_AGING")
	//$email_address_list:="brian.hopkins@arkay.com"+$t+"kristopher.koertge@arkay.com"+$t+"jill.cook@arkay.com"+$t+"sean.mckiernan@arkay.com"+$t+"eric.simon@arkay.com"+$t+"mel.bohince@arkay.com"+$t+"lynn.carden@arkay.com"+$t  //+"paul.Ladino@arkay.com,"
	
	//: ($batchName="ADD_SHEET")  //Batch_GetDistributionList("";"RM_AGING")
	//$email_address_list:="brian.hopkins@arkay.com"+$t+"kristopher.koertge@arkay.com"+$t+"jill.cook@arkay.com"+$t+"eric.simon@arkay.com"+$t+"mel.bohince@arkay.com"+$t+"Walter.Shiels@arkay.com"+$t+"mitchell.kaneff@arkay.com"+$t+"sean.mckiernan@arkay.com"+$t
	//End case 
End if 

