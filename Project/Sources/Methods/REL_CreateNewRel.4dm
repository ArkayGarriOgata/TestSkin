//%attributes = {"publishedWeb":true}
//uCreateNewRel, called by uAdjustReleases upr 57 5/18/94
//upr 90 8/8/94
//•011097  MLB  UPR 1845 Don't change the scheduled date of release to the expirat
//• mlb - 2/13/03  14:14 don't make dr if less than case count
// Modified by: Mel Bohince (4/12/16) don't blank out the dest on dr


C_LONGINT:C283($NewRelQty; $1; $numFG)
C_DATE:C307($2)
C_LONGINT:C283($NewRelQty; $addOn; $openRelease; $oldRel; $1)
C_BOOLEAN:C305($continue)  //• mlb - 2/13/03  14:14 don't make dr if less than case count

$NewRelQty:=$1
$continue:=True:C214

If ([Finished_Goods:26]ProductCode:1#[Customers_ReleaseSchedules:46]ProductCode:11)
	READ ONLY:C145([Finished_Goods:26])
	$numFG:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
Else 
	$numFG:=1
End if 
If ($numFG>0)
	READ ONLY:C145([Finished_Goods_PackingSpecs:91])
	$case_count:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
	If ($case_count>0)
		If ($NewRelQty<$case_count)
			$continue:=False:C215
		End if 
	End if 
End if 

If ($continue)
	$oldRel:=[Customers_ReleaseSchedules:46]ReleaseNumber:1
	$addOn:=0
	If ([Customers_ReleaseSchedules:46]LastRelease:20)  //not any more, another is being created.
		[Customers_ReleaseSchedules:46]LastRelease:20:=False:C215
	End if 
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	
	If (Count parameters:C259=2)  //make a last release  
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			COPY NAMED SELECTION:C331([Customers_ReleaseSchedules:46]; "current")
			
		Else 
			
			ARRAY LONGINT:C221($_current; 0)
			LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; $_current)
			
		End if   // END 4D Professional Services : January 2019 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8=0)
		$openRelease:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			USE NAMED SELECTION:C332("current")
			CLEAR NAMED SELECTION:C333("current")
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_current)
			
		End if   // END 4D Professional Services : January 2019 
		
		
		$addOn:=[Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100)
		$NewRelQty:=([Customers_Order_Lines:41]Quantity:6+$addOn)-[Customers_Order_Lines:41]Qty_Shipped:10-$openRelease
		
	End if 
	
	DUPLICATE RECORD:C225([Customers_ReleaseSchedules:46])
	[Customers_ReleaseSchedules:46]pk_id:54:=Generate UUID:C1066
	[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
	//[Customers_ReleaseSchedules]Shipto:="n/a"  // Modified by: Mel Bohince (4/12/16) don't blank ou the dest
	[Customers_ReleaseSchedules:46]Sched_Qty:6:=$NewRelQty
	[Customers_ReleaseSchedules:46]OriginalRelQty:24:=$NewRelQty
	[Customers_ReleaseSchedules:46]Actual_Date:7:=!00-00-00!
	[Customers_ReleaseSchedules:46]Actual_Qty:8:=0
	[Customers_ReleaseSchedules:46]InvoiceNumber:9:=0
	[Customers_ReleaseSchedules:46]VarianceComment:13:=""
	[Customers_ReleaseSchedules:46]ChgQtyVersion:14:=[Customers_ReleaseSchedules:46]ChgQtyVersion:14+1
	[Customers_ReleaseSchedules:46]OpenQty:16:=$NewRelQty
	[Customers_ReleaseSchedules:46]B_O_L_number:17:=0
	[Customers_ReleaseSchedules:46]B_O_L_pending:45:=0
	[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
	[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
	[Customers_ReleaseSchedules:46]OverRunAddOn:21:=$addOn
	[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  set default on new
	[Customers_ReleaseSchedules:46]user_date_1:48:=!00-00-00!  // Modified by: Mel Bohince (4/20/16) 
	[Customers_ReleaseSchedules:46]user_date_2:49:=!00-00-00!
	[Customers_ReleaseSchedules:46]Expedite:35:=""  // Modified by: Mel Bohince (4/27/16) 
	
	If (Count parameters:C259=2)
		[Customers_ReleaseSchedules:46]LastRelease:20:=True:C214
		//[ReleaseSchedule]Sched_Date:=$2`•011097  MLB  UPR 1845
		[Customers_ReleaseSchedules:46]ChangeLog:23:="Balance of release #"+String:C10($oldRel)+" created this LAST release for "+String:C10($NewRelQty)
		[Customers_ReleaseSchedules:46]VarianceComment:13:="AD"
	Else 
		[Customers_ReleaseSchedules:46]ChangeLog:23:="Balance of release #"+String:C10($oldRel)+" = "+String:C10($NewRelQty)+" created this release."
		[Customers_ReleaseSchedules:46]VarianceComment:13:="DR"
	End if 
	// deleted 5/15/20: gns_ams_clear_sync_fields(->[Customers_ReleaseSchedules]z_SYNC_ID;->[Customers_ReleaseSchedules]z_SYNC_DATA)
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	
Else 
	[Customers_ReleaseSchedules:46]ChangeLog:23:=[Customers_ReleaseSchedules:46]ChangeLog:23+Char:C90(13)+"Short by less than 1 case count"
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	
	$subject:="DR Not Made for "+[Customers_ReleaseSchedules:46]ProductCode:11
	$body:="Shortage was "+String:C10($NewRelQty)+"; case count was "+String:C10([Finished_Goods_PackingSpecs:91]CaseCount:2)+Char:C90(13)
	$body:=$body+"Orderline: "+[Customers_ReleaseSchedules:46]OrderLine:4+Char:C90(13)
	$body:=$body+"P.O.: "+[Customers_ReleaseSchedules:46]CustomerRefer:3+Char:C90(13)
	$body:=$body+"Scheduled: "+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+" for "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+" cartons"+Char:C90(13)
	$body:=$body+"Release Number: "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+Char:C90(13)
	$body:=$body
	If ([Customers_ReleaseSchedules:46]CustID:12#[Customers:16]ID:1)
		READ ONLY:C145([Customers:16])
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
	End if 
	distributionList:=""
	READ ONLY:C145([Users:5])
	QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]CustomerService:46)  //• mlb - 2/21/02  11:34
	If (Records in selection:C76([Users:5])>0)
		distributionList:=distributionList+Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
	End if 
	distributionList:=distributionList  //+"mel.bohince@arkay.com"+Char(9)
	EMAIL_Sender($subject; ""; $body; distributionList)
End if 