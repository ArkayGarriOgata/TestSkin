//%attributes = {}
// -------
// Method: JOB_CloseoutCommodities   ( ) ->
// By: Mel Bohince @ 02/16/17, 12:35:14
// Description
// 
// ----------------------------------------------------

READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Raw_Materials_Transactions:23])
C_LONGINT:C283($numJobs; $com; $issue; $hit; $pivot; $numCommodities)
C_TEXT:C284($t; $r; $headings; $data; $error)
C_TEXT:C284($title; $docName)
C_TIME:C306($docRef)

$title:="Closeouts with Commodity Breakdown "

If (Count parameters:C259=0)
	qryByDateRange(->[Job_Forms:42]ClosedDate:11)
	If (ok=1)
		If (bSearch=1)
			$title:=$title+"(custom search)"  //the Find Button
		Else 
			$title:=$title+"from "+String:C10(dDateBegin; Internal date short special:K1:4)+" to "+String:C10(dDateEnd; Internal date short special:K1:4)
		End if 
		QUERY SELECTION:C341([Job_Forms:42]; [Job_Forms:42]Status:6="closed")  //dont want kills
	End if 
Else 
	
End if 

SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobForms; [Job_Forms:42]CustomerLine:62; $aCustLine; [Job_Forms:42]ActLabCost:37; $aLabor; [Job_Forms:42]ActOvhdCost:38; $aBurden; [Job_Forms:42]ActMatlCost:40; $aMaterial; [Job_Forms:42]JobType:33; $aJobType; [Job_Forms:42]cust_id:82; $aCustId)
$numJobs:=Size of array:C274($aJobForms)
REDUCE SELECTION:C351([Job_Forms:42]; 0)

QUERY WITH ARRAY:C644([Raw_Materials_Transactions:23]JobForm:12; $aJobForms)
QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
CREATE SET:C116([Raw_Materials_Transactions:23]; "targetIssues")

DISTINCT VALUES:C339([Raw_Materials_Transactions:23]Commodity_Key:22; $aCommodities)  //used for horizontal axis of pivot
$numCommodities:=Size of array:C274($aCommodities)



$t:="\t"
$r:="\r"
$headings:="Job\tType\tCustomer\tLine\tMaterial\tConversion\tBillings\tP.V.\tInventory\t"
For ($com; 1; $numCommodities)
	$headings:=$headings+$aCommodities{$com}+$t
End for 
$headings:=$headings+$r

$data:=$headings
$error:=""
$ttl_matl:=0
$ttl_conversion:=0
$ttl_billing:=0

For ($job; 1; $numJobs)
	
	$jobform:=$aJobForms{$job}
	$billings:=0
	$inventoryRemaining:=0
	
	Begin SQL
		select sum(ExtendedPrice) from Finished_Goods_Transactions where JobForm = :$jobform and upper(XactionType)='SHIP' into :$billings
	End SQL
	
	$pv:=fProfitVariable("PV"; ($aMaterial{$job}+$aLabor{$job}+$aBurden{$job}); $billings; 0)
	$data:=$data+$jobform+$t+$aJobType{$job}+$t+CUST_getName($aCustId{$job})+$t+$aCustLine{$job}+$t+String:C10(Round:C94($aMaterial{$job}; 0))+$t+String:C10(Round:C94(($aLabor{$job}+$aBurden{$job}); 0))+$t
	$data:=$data+String:C10(Round:C94($billings; 0))+$t+String:C10(Round:C94($pv*100; 0))+$t
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19=$jobform)
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		$inventoryRemaining:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	End if 
	$data:=$data+String:C10($inventoryRemaining)+$t
	
	
	USE SET:C118("targetIssues")
	QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$aJobForms{$job})
	
	SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Commodity_Key:22; $aIssueCommodity; [Raw_Materials_Transactions:23]ActExtCost:10; $aIssueExtCost)
	
	ARRAY REAL:C219($aActCost; 0)
	ARRAY REAL:C219($aActCost; $numCommodities)
	
	For ($issue; 1; Size of array:C274($aIssueCommodity))
		$hit:=Find in array:C230($aCommodities; $aIssueCommodity{$issue})
		If ($hit>-1)
			$aActCost{$hit}:=$aActCost{$hit}+($aIssueExtCost{$issue}*-1)
		Else 
			$error:=$error+$aJobForms{$job}+" "+$aIssueCommodity{$issue}+"; "
		End if 
	End for 
	
	
	For ($pivot; 1; $numCommodities)
		$data:=$data+String:C10(Round:C94($aActCost{$pivot}; 0))+$t
	End for 
	
	$data:=$data+$r
	
	$ttl_matl:=$ttl_matl+$aMaterial{$job}
	$ttl_conversion:=$ttl_conversion+($aLabor{$job}+$aBurden{$job})
	$ttl_billing:=$ttl_billing+$billings
	
End for 

$pv:=fProfitVariable("PV"; ($ttl_matl+$ttl_conversion); $ttl_billing; 0)
$data:=$data+"\r\t\t\t\t"+String:C10(Round:C94($ttl_matl; 0))+$t+String:C10(Round:C94($ttl_conversion; 0))+$t+String:C10(Round:C94($ttl_billing; 0))+$t+String:C10(Round:C94($pv*100; 0))+$r
CLEAR SET:C117("targetIssues")

$docName:="CommodityCloseouts_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	SEND PACKET:C103($docRef; $data)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$err:=util_Launch_External_App($docName)
End if 


//utl_LogIt ("init")
//utl_LogIt ($data)
//utl_LogIt ("show")