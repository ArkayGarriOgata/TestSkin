//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceEmail() -> 
//called from {FG_Spec}input method
//@author mlb - 4/19/01  14:53
//• mlb - 11/7/02  16:17 chgd 
// • mel (4/11/05, 19:33:28) chg distribution
// Added by: Mel Bohince (5/30/19) email for proofreading
// Modified by: Mel Bohince (5/20/20) add the +"\t" after BatchGetDistribution
// Modified by: Garri Ogata (8/27/21) changed to support multiple Customer emails

C_TEXT:C284(distributionList; $body; $subject; $from)
C_OBJECT:C1216($oPeople)  // Modified by: Garri Ogata (8/26/21) People object
$oPeople:=New object:C1471()
$oPeople.tCustomerID:=[Customers_ReleaseSchedules:46]CustID:12
$oPeople.bCustomerService:=True:C214

Case of 
	: (Count parameters:C259=0)  // was in FG_PrepServiceStateChange, deactivated
		If ([Finished_Goods_Specifications:98]ServiceRequested:54#"Original")
			$subject:="Purge File and Film"
			distributionList:=Batch_GetDistributionList($subject)+"\t"
			
			$body:="A new FG_Specification has been entered for product code: '"+[Finished_Goods_Specifications:98]ProductCode:3+"'. "
			$body:=$body+"The new control number is designated as "+[Finished_Goods_Specifications:98]ControlNumber:2+". "
			$body:=$body+"The service requested that prompted this email was categorized as a '"+[Finished_Goods_Specifications:98]ServiceRequested:54+"'. "
			$body:=$body+"Make sure you are working with current artifacts and dispose any that have been "+"superceded. "
			If ([Finished_Goods:26]PressDate:64#!00-00-00!) & ([Finished_Goods_Specifications:98]ProductCode:3=[Finished_Goods:26]ProductCode:1)
				$body:=$body+Char:C90(13)+Char:C90(13)+"Press Date is set for "+String:C10([Finished_Goods:26]PressDate:64; Internal date abbreviated:K1:6)
			End if 
			$body:=$body+Char:C90(13)+Char:C90(13)+"Reply to the Sender of this email if you have any questions."+Char:C90(13)
			$body:=$body
			$from:=Email_WhoAmI
			$subject:=$subject+" of "+[Finished_Goods_Specifications:98]ProductCode:3+" "+[Customers:16]Name:2
			//EMAIL_Sender ($subject;"";$body;distributionList;"";$from;$from)
			$preheader:="FG_PrepServiceEmail responded to Purge File and Film, no param"
			Email_html_body($subject; $preheader; $body; 500; distributionList; ""; $from; $from)
			zwStatusMsg("EMail"; "Purge File and Film has been sent to "+distributionList)
		End if 
		
	: ($1="PREP DONE")
		$subject:="Prep Done Notice"  // • mel (4/11/05, 19:33:28) chg distribution
		distributionList:=Batch_GetDistributionList($subject)+"\t"
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]PlannerID:5)+Char:C90(9)
		If ([Customers:16]SalesmanID:3#"WJS")  //Walter wants off the list
			distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]SalesmanID:3)+Char:C90(9)
		End if 
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]CustomerService:46)+Char:C90(9)
		$subject:=$1+" on "+[Finished_Goods_Specifications:98]ProductCode:3+" "+[Customers:16]Name:2
		$body:="Prep is done on Control number "+[Finished_Goods_Specifications:98]ControlNumber:2+Char:C90(13)  //+"which appears to involve stamping or embossing ."+Char(13)
		//$body:=$body+"[FG_Specification]Stamps set to "+[FG_Specification]Stamps+Char(13)
		//$body:=$body+"[FG_Specification]Embosses set to "+[FG_Specification]Embosses+Char(13)
		$body:=$body
		$from:=Email_WhoAmI
		//EMAIL_Sender ($subject;"";$body;distributionList;"";$from;$from)
		$preheader:="FG_PrepServiceEmail responded to "+$1
		Email_html_body($subject; $preheader; $body; 500; distributionList; ""; $from; $from)
		zwStatusMsg("EMail"; $1+" Notification has been sent to "+distributionList)
		
	: ($1="PROOFREAD")  // Added by: Mel Bohince (5/30/19) 
		$subject:="Proofread Notice"  // • mel (4/11/05, 19:33:28) chg distribution
		distributionList:=Batch_GetDistributionList($subject)+"\t"
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]PlannerID:5)+Char:C90(9)
		If ([Customers:16]SalesmanID:3#"WJS")  //Walter wants off the list
			distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]SalesmanID:3)+Char:C90(9)
		End if 
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]CustomerService:46)+Char:C90(9)
		$subject:=$1+" - "+[Finished_Goods_Specifications:98]ProductCode:3+" "+[Customers:16]Name:2
		$body:="Proofreading is done on Control number "+[Finished_Goods_Specifications:98]ControlNumber:2+Char:C90(13)
		$from:=Email_WhoAmI
		//EMAIL_Sender ($subject;"";$body;distributionList;"";$from;$from)
		$preheader:="FG_PrepServiceEmail responded to "+$1
		Email_html_body($subject; $preheader; $body; 500; distributionList; ""; $from; $from)
		zwStatusMsg("EMail"; $1+" Notification has been sent to "+distributionList)
		
		
	: ($1="Additional Reqs Done")
		$subject:=$1+" Notification"
		distributionList:=Batch_GetDistributionList($subject)+"\t"
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]PlannerID:5)+Char:C90(9)
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]CustomerService:46)+Char:C90(9)
		$body:="Control number "+[Finished_Goods_Specifications:98]ControlNumber:2+"'s Additional Requests (iteration "+[Finished_Goods_Specifications:98]ServiceRequested:54+") has been marked as done."+Char:C90(13)
		$body:=$body
		$from:=Email_WhoAmI
		$subject:=$subject+" of "+[Finished_Goods_Specifications:98]ProductCode:3+" "+[Customers:16]Name:2
		//EMAIL_Sender ($subject;"";$body;distributionList;"";$from;$from)
		$preheader:="FG_PrepServiceEmail responded to "+$1
		Email_html_body($subject; $preheader; $body; 500; distributionList; ""; $from; $from)
		zwStatusMsg("EMail"; $1+" Notification has been sent to "+distributionList)
		
	Else 
		distributionList:=Batch_GetDistributionList($1)+"\t"
		distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]PlannerID:5)+Char:C90(9)
		
		distributionList:=distributionList+Cust_GetEmailsT($oPeople)
		//distributionList:=distributionList+Email_WhoAmI ("";[Customers]CustomerService)+Char(9)
		$subject:=$1+" Notification"
		$body:="Control number "+[Finished_Goods_Specifications:98]ControlNumber:2+" has been set "+$1+Char:C90(13)
		$body:=$body
		$from:=Email_WhoAmI
		$subject:=$subject+" of "+[Finished_Goods_Specifications:98]ProductCode:3+" "+[Customers:16]Name:2
		//EMAIL_Sender ($subject;"";$body;distributionList;"";$from;$from)
		$preheader:="FG_PrepServiceEmail responded to "+$1
		Email_html_body($subject; $preheader; $body; 500; distributionList; ""; $from; $from)
		zwStatusMsg("EMail"; $1+" Notification has been sent to "+distributionList)
End case 