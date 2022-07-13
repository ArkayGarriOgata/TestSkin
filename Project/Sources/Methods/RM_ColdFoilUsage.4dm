//%attributes = {}
// _______
// Method: RM_ColdFoilUsage   ( ) ->
// By: Mel Bohince @ 07/21/21, 12:03:37
// Description
// UI for pressman to enter cold foil usage with just mouse clicks
// ----------------------------------------------------
// Modified by: Mel Bohince (7/27/21) add {+" at "+$form_o.costCenter} to email subject
// Modified by: Garri Ogata (8/26/21) added updating the list box and ok to true always, changed to 0's
// Modified by: Garri Ogata (10/04/21) Open [Raw_Materials_Transactions];"ColdFoilUsage" as a sheet window 
// Modified by: MelvinBohince (2/3/22) test with RM_coldFoilEquivalent if not the budgeted cf rm
// Modified by: MelvinBohince (2/13/22) don't show negative OH
// Modified by: MelvinBohince (2/14/22) log to server, use iOperator for initials

C_TEXT:C284($jobFormSeq; $1; $costCenter; $2)

If (Count parameters:C259>0)
	$jobFormSeq:=$1
	$costCenter:=$2  //based on the schedule not the budget
	
Else 
	$jobFormSeq:="17123.12.123"
	$costCenter:="419"
End if 

C_OBJECT:C1216($form_o)
$form_o:=New object:C1471
$form_o.dateSubmitted:=4D_Current_date
$form_o.costCenter:=$costCenter
$form_o.jobFormSeq:=$jobFormSeq
$form_o.usageDesc:=""
$form_o.rawMatlCode:=""
$form_o.quantity:=""
$form_o.unitCost:=0  //Garri Ogata (8/26/21) Changed to 0 since it is assigned to [Raw_Materials_Transactions]ActCost
$form_o.otherColor:=""
$form_o.otherVendor:=""
$form_o.width:=0
$form_o.color:="@"
$form_o.vendorID:="@"
$form_o.vendorName:="@"
$form_o.poItemKey:=""
$form_o.location:=""
$form_o.commodityKey:=""
$form_o.picks_c:=New collection:C1472("[ w]"; "[ c]"; "[ v]"; "[ q]")  //willl be joined later for email and log entries
$form_o.budget_c:=New collection:C1472("[ rmc]"; "[ vpn]")
$form_o.actual_c:=New collection:C1472("[rmc]"; "[vpn]")

C_TEXT:C284(iOperator)  // Modified by: MelvinBohince (2/14/22), see also [zz_control].eBag_dio.MachTickNew( )
If (Length:C16(iOperator)=0)
	iOperator:=Request:C163("Please enter your initials:"; ""; "Sign in"; "Use Shift")
	If (Length:C16(iOperator)=0) | (ok=0)
		iOperator:=<>zResp  //kind of useless since they use a common login
	End if 
End if 
$form_o.user:=iOperator


$form_o.inventory_es:=ds:C1482.Raw_Materials_Locations.query("Commodity_Key = :1 and QtyOH > :2"; "09-@"; 0)  // Modified by: MelvinBohince (2/13/22) don't show negative OH

$form_o.matchingInventory_es:=$form_o.inventory_es.orderBy("RAW_MATERIAL.VendorPartNum")  //first sort is by color-width, later it will be by po

//open a dialog for them you log an entry
C_LONGINT:C283($winRef)
$winRef:=Open form window:C675([Raw_Materials_Transactions:23]; "ColdFoilUsage"; Sheet form window:K39:12)

DIALOG:C40([Raw_Materials_Transactions:23]; "ColdFoilUsage"; $form_o)
If (ok=1)
	//if narrowed down to one vendor, color, and size and is the r/m code budgeted,
	//then relieve inventory by fifo, otherwise log and email
	C_BOOLEAN:C305($okToIssue)
	//$okToIssue:=False  //Garri Ogata (8/26/21) changed
	$okToIssue:=False:C215  // Modified by: MelvinBohince (2/13/22) always going to issue something, see below, since acctg would need to do something anyway
	
	C_TEXT:C284($note)
	C_OBJECT:C1216($budget_e)
	$budget_e:=ds:C1482.Job_Forms_Materials.query("JobForm = :1 and Sequence = :2 and Commodity_Key = :3"; Substring:C12($form_o.jobFormSeq; 1; 8); Num:C11(Substring:C12($form_o.jobFormSeq; 10; 3)); "09-@").first()
	
	
	If ($budget_e#Null:C1517)  //found a foil budget
		$form_o.budget_c[0]:=$budget_e.Raw_Matl_Code
		$form_o.budget_c[1]:=$budget_e.RAW_MATERIAL.VendorPartNum
		
		$note:="Picks: "+$form_o.picks_c.join(" ")+"; Budget: "+$form_o.budget_c.join(" ")+"; Act: "+$form_o.actual_c.join(" ")
		If ($budget_e.Raw_Matl_Code=$form_o.rawMatlCode)  //perfect match
			$okToIssue:=True:C214
			
		Else 
			If (RM_coldFoilEquivalent($budget_e.Raw_Matl_Code; $form_o.rawMatlCode))  // close enough match. Modified by: MelvinBohince (2/3/22) 
				$okToIssue:=True:C214
				
			Else   //not a match, but do it anyway
				$okToIssue:=True:C214
				$distributionList:=Batch_GetDistributionList("ACCPLN"; "ACCPLN")
				$emailBody:=$note
				EMAIL_Sender("Cold Foil Issue Problem "+$form_o.jobFormSeq+" at the "+$form_o.costCenter; ""; $emailBody; $distributionList)
			End if 
		End if 
		
	Else   //budget matl sequence not found
		
		$okToIssue:=True:C214  // Modified by: MelvinBohince (2/13/22) allow it since they already think they did
		
		$form_o.budget_c[0]:="not budgeted"
		$form_o.budget_c[1]:="no cold foil"
		
		$note:="Picks: "+$form_o.picks_c.join(" ")+"; Budget: "+$form_o.budget_c.join(" ")+"; Act: "+$form_o.actual_c.join(" ")
		
		ALERT:C41("Cold foil not budgeted for "+$form_o.jobFormSeq)
		
		$distributionList:=Batch_GetDistributionList("ACCPLN"; "ACCPLN")
		$emailBody:=$note+" to job sequence "+$form_o.jobFormSeq+" which did not budget cold foil. \r"+$note
		EMAIL_Sender("Cold Foil Issue Problem "+$form_o.jobFormSeq+" at the "+$form_o.costCenter; ""; $emailBody; $distributionList)
	End if 
	
	If ($okToIssue)
		
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		
		[Raw_Materials_Transactions:23]Commodity_Key:22:=$form_o.commodityKey
		[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2))
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$form_o.rawMatlCode
		[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
		[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
		[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		[Raw_Materials_Transactions:23]viaLocation:11:=$form_o.location
		[Raw_Materials_Transactions:23]ModDate:17:=[Raw_Materials_Transactions:23]XferDate:3
		[Raw_Materials_Transactions:23]ModWho:18:=$form_o.user
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]JobForm:12:=Substring:C12($form_o.jobFormSeq; 1; 8)
		[Raw_Materials_Transactions:23]CostCenter:19:=$form_o.costCenter
		[Raw_Materials_Transactions:23]ReferenceNo:14:=[Raw_Materials_Transactions:23]CostCenter:19+fYYMMDD([Raw_Materials_Transactions:23]XferDate:3)
		[Raw_Materials_Transactions:23]Sequence:13:=Num:C11(Substring:C12($form_o.jobFormSeq; 10))
		[Raw_Materials_Transactions:23]POItemKey:4:=$form_o.poItemKey
		[Raw_Materials_Transactions:23]Qty:6:=-1*Num:C11($form_o.quantity)
		[Raw_Materials_Transactions:23]ActCost:9:=$form_o.unitCost
		[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94(([Raw_Materials_Transactions:23]ActCost:9*[Raw_Materials_Transactions:23]Qty:6); 2)
		[Raw_Materials_Transactions:23]Reason:5:="RMX_Issue_Dialog"  //triggers the inventory relief based on the transaction, see trigger_RM_xfers
		
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		
		RM_ColdFoilFill(CorektPhaseAssignVariable)
		
	End if   //ok to issue 
	
	////////////////////////////utl_Logfile
	$path:=System folder:C487(Desktop:K41:16)+"cold_foil_usage.log"
	
	If (Test path name:C476($path)#Is a document:K24:1)
		$docRef:=Create document:C266($path)
		CLOSE DOCUMENT:C267($docRef)
	End if 
	
	//$methCurrent:=Method called on error
	ON ERR CALL:C155("e_file_io_error")
	
	$docRef:=Append document:C265($path)
	If (ok=1)
		SEND PACKET:C103($docRef; TS_ISO_String_TimeStamp+" * "+$form_o.user+" "+$form_o.jobFormSeq+" "+$note+Char:C90(Line feed:K15:40))
	End if 
	CLOSE DOCUMENT:C267($docRef)
	
	utl_LogfileServer($form_o.user; $form_o.jobFormSeq+" "+$note; "cold_foil_usage.log")  // Modified by: MelvinBohince (2/14/22) log to server
	
End if   //ok
//ON ERR CALL("$methCurrent")
ON ERR CALL:C155("")

CLOSE WINDOW:C154($winRef)
