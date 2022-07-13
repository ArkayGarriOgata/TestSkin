//%attributes = {}
// ----------------------------------------------------
// Method: Est_MergeForms   ( ) ->
// By: Mel Bohince @ 02/12/16, 17:09:12
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (5/1/17) don't rebrand estimate if merging from same customer
// Modified by: Mel Bohince (6/6/17) don't  reassign to combined cust, ever
// Modified by: Mel Bohince (10/5/17) offer change regardless of customers, better messaging
// Modified by: Garri Ogata (9/21/21) - Add EsCS_SetItemT to find unreproducable error

C_BOOLEAN:C305($1; $formLevel)  //false is for worksheet only, true is for worksheet and diff form
If (Count parameters:C259=1)
	$formLevel:=$1  //True
Else 
	$formLevel:=True:C214
End if 

C_TEXT:C284($mergedJobsCust)  // Modified by: Mel Bohince (5/1/17) 
$mergedJobsCust:=""

READ WRITE:C146([Job_Forms:42])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Job_Forms_Materials:55])

ARRAY TEXT:C222($aJobforms; 0)
ARRAY TEXT:C222($aCustomers; 0)

//uConfirm ("Can we put the merged jobs on HOLD?";"HOLD";"Ignore")
//If (ok=1)
//$setToHold:=True
//Else 
//$setToHold:=False
//End if 
$setStatus:=uYesNoCancel("\r\r        Change status on merged jobfor to: "; "Kill"; "HOLD"; "No Change")

gEstimateLDWkSh("Wksht")

//gather the jobforms to merge
$notesToAppend:=""

Repeat 
	$jobform:=Request:C163("Enter a jobform to merge into this estimate form:"; ""; "Merge"; "Done")
	If (ok=1)
		utl_LogfileServer(<>zResp; "JOB MERGE--"+$jobform+" into "+[Estimates:17]EstimateNo:1+" level: "+String:C10($formLevel))
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
		If (Records in selection:C76([Job_Forms:42])=1)
			APPEND TO ARRAY:C911($aJobforms; $jobform)
			$mergedJobsCust:=[Job_Forms:42]cust_id:82
			If ($setStatus#"No Change")
				[Job_Forms:42]Status:6:=$setStatus
				
				If ([Job_Forms:42]Status:6="Kill")  // Modified by: Mel Bohince (2/10/17) 
					If ([Job_Forms:42]ClosedDate:11=!00-00-00!)
						[Job_Forms:42]ClosedDate:11:=4D_Current_date
					End if 
					If ([Job_Forms:42]Completed:18=!00-00-00!)
						[Job_Forms:42]Completed:18:=[Job_Forms:42]ClosedDate:11
					End if 
					
					$numAlloc:=RM_AllocationRemove([Job_Forms:42]JobFormID:5)
					
					If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
						[Job_Forms_Master_Schedule:67]Comment:22:="KILL/MERGE  BY "+<>zResp+"  "+[Job_Forms_Master_Schedule:67]Comment:22
						[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
						[Job_Forms_Master_Schedule:67]PlannerReleased:14:=!00-00-00!  //[JobForm]PlnnerReleased
						SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
					End if 
					
					READ WRITE:C146([ProductionSchedules:110])
					QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=([Job_Forms:42]JobFormID:5+"@"))
					APPLY TO SELECTION:C70([ProductionSchedules:110]; PS_setJobInfo([ProductionSchedules:110]JobSequence:8))
					REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
					User_NotifyAll
				End if   //kill
				
			End if   //change
			$notesToAppend:=$notesToAppend+[Job_Forms:42]Notes:32
			[Job_Forms:42]Notes:32:="TO BE MERGED WITH JOB "+String:C10([Estimates:17]JobNo:50)+" "+[Job_Forms:42]Notes:32
			SAVE RECORD:C53([Job_Forms:42])
			UNLOAD RECORD:C212([Job_Forms:42])
			
		Else 
			uConfirm($jobform+" was not found."; "Try again"; "Help")
		End if 
	End if 
Until (ok=0)

$listOfMergers:="Merged: "

$numJobforms:=Size of array:C274($aJobforms)  // lets pull the shit in
If ($numJobforms>0)
	//do some housekeeping
	//If (False)  // Modified by: Mel Bohince (6/6/17) don't  reassign to combined cust
	//If (True)  // Modified by: Mel Bohince (8/4/17) change back
	// Modified by: Mel Bohince (10/5/17) offer change regardless of customers, better messaging
	If ($mergedJobsCust#[Estimates:17]Cust_ID:2)  // Modified by: Mel Bohince (5/1/17) 
		$msg:="Merging different customer"
	Else 
		$msg:="Merging job of same customer"
	End if 
	uConfirm($msg+", change ESTIMATE to 'combined'?"; "Combined"; "Cust="+[Estimates:17]Cust_ID:2)
	If (ok=1)
		[Estimates:17]Cust_ID:2:=<>sCombindID
		[Estimates:17]ProjectNumber:63:=<>JobMergePjtID
		[Estimates:17]CustomerName:47:=<>CombinedCustomerName
		uConfirm("Estimate put in the 'JobMerge' project under 'Combined Customer'."; "I know"; "What?")
	End if 
	//End if 
	//End if 
	
	[Estimates:17]DateOriginated:19:=4D_Current_date
	$line:=Request:C163("Edit Line/Brand:"; [Estimates:17]Brand:3; "Change"; "Ignore")
	If (ok=1)
		[Estimates:17]Brand:3:=$line
	End if 
	
	For ($job; 1; $numJobforms)
		$listOfMergers:=$listOfMergers+$aJobforms{$job}+" "
		//grab the items
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$aJobforms{$job})
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Want:24; $aQty)
		For ($item; 1; Size of array:C274($aCPN))
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$aCPN{$item})
			
			CREATE RECORD:C68([Estimates_Carton_Specs:19])
			[Estimates_Carton_Specs:19]Estimate_No:2:=[Estimates:17]EstimateNo:1
			[Estimates_Carton_Specs:19]diffNum:11:=<>sQtyWorksht  //◊sQtyWorksht  `defined in 00CompileString()  indicates records go to Qty-Workshe
			[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(nextItem)
			//[Estimates_Carton_Specs]Item:=String(nextItem;"00")
			[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
			[Estimates_Carton_Specs:19]PONumber:73:=[Estimates:17]POnumber:18
			[Estimates_Carton_Specs:19]zCount:51:=1
			[Estimates_Carton_Specs:19]Quantity_Want:27:=$aQty{$item}
			[Estimates_Carton_Specs:19]Qty1Temp:52:=[Estimates_Carton_Specs:19]Quantity_Want:27
			
			FG_CspecLikeFG
			SAVE RECORD:C53([Estimates_Carton_Specs:19])
			
			If ($formLevel)
				[Estimates_DifferentialsForms:47]Notes:33:=[Estimates_DifferentialsForms:47]Notes:33+$notesToAppend
				SAVE RECORD:C53([Estimates_DifferentialsForms:47])
				
				$case:=Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)
				$form:=[Estimates_DifferentialsForms:47]DiffFormId:3
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$aCPN{$item})
				
				CREATE RECORD:C68([Estimates_Carton_Specs:19])
				[Estimates_Carton_Specs:19]Estimate_No:2:=[Estimates:17]EstimateNo:1
				[Estimates_Carton_Specs:19]diffNum:11:=$case  //◊sQtyWorksht  `defined in 00CompileString()  indicates records go to Qty-Workshe
				[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(nextItem)
				//[Estimates_Carton_Specs]Item:=String(nextItem;"00")
				[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
				[Estimates_Carton_Specs:19]PONumber:73:=[Estimates:17]POnumber:18
				[Estimates_Carton_Specs:19]zCount:51:=1
				[Estimates_Carton_Specs:19]Quantity_Want:27:=$aQty{$item}
				[Estimates_Carton_Specs:19]Qty1Temp:52:=$aQty{$item}
				[Estimates_Carton_Specs:19]ProcessSpec:3:=[Estimates_DifferentialsForms:47]ProcessSpec:23
				FG_CspecLikeFG
				SAVE RECORD:C53([Estimates_Carton_Specs:19])
				
				//*    Create the FormCarton record
				CREATE RECORD:C68([Estimates_FormCartons:48])
				[Estimates_FormCartons:48]Carton:1:=[Estimates_Carton_Specs:19]CartonSpecKey:7  //upr 1246
				[Estimates_FormCartons:48]DiffFormID:2:=$form
				[Estimates_FormCartons:48]ItemNumber:3:=Num:C11([Estimates_Carton_Specs:19]Item:1)  //upr 1365 12/21/94$FormCtnTtl+$zzz
				[Estimates_FormCartons:48]NumberUp:4:=1
				[Estimates_FormCartons:48]NetSheets:7:=[Estimates_DifferentialsForms:47]NumberSheets:4
				[Estimates_FormCartons:48]MakesQty:5:=[Estimates_DifferentialsForms:47]NumberSheets:4
				[Estimates_FormCartons:48]FormWantQty:9:=$aQty{$item}
				SAVE RECORD:C53([Estimates_FormCartons:48])
			End if 
			
			nextItem:=nextItem+1
			
		End for   //carton
		
		//uConfirm ("Add materials from "+$aJobforms{$job}+" to the existing process spec?";"Add";"Ignore")
		//If (ok=1)
		If ($formLevel)
			//uConfirm ("Material merge not implemented yet.")
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$aJobforms{$job}; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7#"")
			SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Raw_Matl_Code:7; $aJF_material)
			
			For ($matl; 1; Size of array:C274($aJF_material))
				QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3; *)
				QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]Raw_Matl_Code:4=$aJF_material{$matl})
				If (Records in selection:C76([Estimates_Materials:29])=0)
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$aJF_material{$matl})
					If (Records in selection:C76([Raw_Materials:21])>0)
						CREATE RECORD:C68([Estimates_Materials:29])
						[Estimates_Materials:29]Raw_Matl_Code:4:=$aJF_material{$matl}
						[Estimates_Materials:29]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
						[Estimates_Materials:29]CostCtrID:2:="MERG"  //[Machine_Est]CostCtrID
						[Estimates_Materials:29]RMName:10:=""
						[Estimates_Materials:29]Comments:13:="MERGED"  //"Effectivity:"+String([RM_GROUP]EffectivityDate;1)
						[Estimates_Materials:29]Commodity_Key:6:=[Raw_Materials:21]Commodity_Key:2
						[Estimates_Materials:29]UOM:8:=[Raw_Materials:21]IssueUOM:10
						[Estimates_Materials:29]Qty:9:=0
						[Estimates_Materials:29]Cost:11:=0
						[Estimates_Materials:29]ModWho:21:=<>zResp
						[Estimates_Materials:29]ModDate:22:=4D_Current_date
						[Estimates_Materials:29]zCount:23:=1
						[Estimates_Materials:29]TempSeq:20:=0
						[Estimates_Materials:29]EstimateType:7:="Prod"
						SAVE RECORD:C53([Estimates_Materials:29])
					End if   //rm code
				End if 
			End for   //matl
			
		End if 
		
	End for   //form
	[Estimates:17]Comments:34:=$listOfMergers+"  "+[Estimates:17]Comments:34
	SAVE RECORD:C53([Estimates:17])
	
End if   //doing a merge

READ ONLY:C145([Job_Forms:42])
