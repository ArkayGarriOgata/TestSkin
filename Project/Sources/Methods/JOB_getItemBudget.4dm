//%attributes = {"publishedWeb":true}
//PM:  JOB_getItemBudget  2/21/01  mlb

C_LONGINT:C283($hit; $i; $numHRDs)
C_DATE:C307($latestHRD)
$latestHRD:=!00-00-00!
$continue:=True:C214

If (Count parameters:C259>2)  //revising, so blank out existing data
	READ WRITE:C146([Job_Forms_Items:44])
	
	qryJMI(($3+"@"))
	CREATE SET:C116([Job_Forms_Items:44]; "currentSeqs")
	
	//make the existing JMI to see if they will still be needed, and count HRD
	$latestHRD:=JOB_CheckHRD  // Added by: Mark Zinke (11/20/13) 
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]MAD:37; $aHRD)
	$numHRDs:=0
	ARRAY TEXT:C222($aDeleteTag; Size of array:C274($aCPN))  //this will be used to try to match up hrd after
	
	For ($i; 1; Size of array:C274($aCPN))
		$aDeleteTag{$i}:="DELETE"
		If ($aHRD{$i}#!00-00-00!)
			$numHRDs:=$numHRDs+1
		End if 
	End for 
	
	ARRAY TO SELECTION:C261($aDeleteTag; [Job_Forms_Items:44]ProductCode:3)  //tag them for deletion
	
	//test to see if the tagging was successful and if we should continue
	If (Records in set:C195("LockedSet")>0)  //• mlb - 1/11/02  15:52
		$continue:=False:C215
		CONFIRM:C162("A jobit record is locked so changes will not be saved."+Char:C90(13)+"Do you wish to see who has it locked?")
		If (OK=1)
			USE SET:C118("LockedSet")
			LOCKED BY:C353([Job_Forms_Items:44]; $lockProcNo; $userName; $machName; $lockProcess)
			PROCESS PROPERTIES:C336(Current process:C322; $procName; $state; $time)
			If ($userName#"")
				ALERT:C41($procName+" is waiting for a "+Table name:C256(->[Job_Forms_Items:44])+" record locked by "+$userName+"@"+$machName+" doing "+$lockProcess)
			Else 
				ALERT:C41($procName+" is waiting for a "+Table name:C256(->[Job_Forms_Items:44])+" record YOU have locked doing "+$lockProcess)
			End if 
		End if 
		ALERT:C41("You will need to revise this job again to repair product codes after the lock is "+"released.")
	End if 
End if 

If ($continue)  //no jmi were locked
	FIRST RECORD:C50([Job_Forms_Items:44])
	JMI_findDefaultOrderPeg("init")
	
	QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$2+"@")
	$numRecs:=Records in selection:C76([Estimates_FormCartons:48])
	If ($numRecs>0)
		ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2; >)  //;[FormCartons]ItemNumber;>)
		
		For ($i; 1; $numRecs)
			MESSAGE:C88("."+String:C10($i))
			If (Count parameters:C259<=2)  //original planning run
				CREATE RECORD:C68([Job_Forms_Items:44])
				[Job_Forms_Items:44]JobForm:1:=String:C10($1; "00000")+"."+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 12; 2)
				[Job_Forms_Items:44]ItemNumber:7:=[Estimates_FormCartons:48]ItemNumber:3
				[Job_Forms_Items:44]SubFormNumber:32:=[Estimates_FormCartons:48]SubFormNumber:10
				
			Else   //making a revision
				USE SET:C118("currentSeqs")
				$jobit:=JMI_makeJobIt($3; [Estimates_FormCartons:48]ItemNumber:3)
				QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$jobit; *)
				QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]SubFormNumber:32=[Estimates_FormCartons:48]SubFormNumber:10)
				If (Records in selection:C76([Job_Forms_Items:44])=0)  // new sequence added
					CREATE RECORD:C68([Job_Forms_Items:44])
					[Job_Forms_Items:44]JobForm:1:=String:C10($1; "00000")+"."+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 12; 2)
					[Job_Forms_Items:44]ItemNumber:7:=[Estimates_FormCartons:48]ItemNumber:3
					[Job_Forms_Items:44]SubFormNumber:32:=[Estimates_FormCartons:48]SubFormNumber:10
					[Job_Forms_Items:44]MAD:37:=$latestHRD  // Modified by: Mel Bohince (9/8/14) rtn'd hrd or 0/0/0
				End if 
				
			End if 
			uUpdateTrail(->[Job_Forms_Items:44]PlnnrDate:35; ->[Job_Forms_Items:44]PlnnrWho:34)
			
			If ([Estimates_Carton_Specs:19]CartonSpecKey:7#[Estimates_FormCartons:48]Carton:1)
				RELATE ONE:C42([Estimates_FormCartons:48]Carton:1)  //get carton_spec
			End if 
			
			//below finds the fg record as a side effect
			FG_LastJobInfo([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5; $1)  //5/3/95 upr 1489 chip
			
			[Job_Forms_Items:44]SqInches:22:=[Finished_Goods:26]SquareInch:6
			
			// • mel (3/23/05, 14:29:34) make sure current specs are stored, 
			If (Length:C16([Finished_Goods:26]ControlNumber:61)>0)
				[Job_Forms_Items:44]ControlNumber:26:=[Finished_Goods:26]ControlNumber:61
			Else 
				[Job_Forms_Items:44]ControlNumber:26:="not avail"
			End if 
			
			If (Length:C16([Finished_Goods:26]OutLine_Num:4)>0)
				[Job_Forms_Items:44]OutlineNumber:43:=[Finished_Goods:26]OutLine_Num:4
			Else 
				[Job_Forms_Items:44]OutlineNumber:43:="not avail"
			End if 
			If ([Job_Forms:42]JobFormID:5#[Job_Forms_Items:44]JobForm:1)
				RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
			End if 
			[Job_Forms_Items:44]LineSpec:42:=[Job_Forms:42]ProcessSpec:46
			
			[Job_Forms_Items:44]Category:31:=[Finished_Goods:26]OriginalOrRepeat:71
			[Job_Forms_Items:44]ProductCode:3:=[Estimates_Carton_Specs:19]ProductCode:5
			[Job_Forms_Items:44]NumberUp:8:=[Estimates_FormCartons:48]NumberUp:4
			[Job_Forms_Items:44]Qty_Yield:9:=[Estimates_FormCartons:48]MakesQty:5
			[Job_Forms_Items:44]Qty_Want:24:=[Estimates_FormCartons:48]FormWantQty:9
			
			// [JobMakesItem]ItemCost:=[FormCartons]ItemCost_Per_M `upr 1449 3/10/95
			[Job_Forms_Items:44]PldCostMatl:17:=[Estimates_FormCartons:48]CostMatl:13
			[Job_Forms_Items:44]PldCostLab:18:=[Estimates_FormCartons:48]CostLabor:14
			[Job_Forms_Items:44]PldCostOvhd:19:=[Estimates_FormCartons:48]CostBurden:15
			[Job_Forms_Items:44]PldCostS_E:20:=0  //uNANCheck ([CARTON_SPEC]CostScrap_Per_M)
			[Job_Forms_Items:44]PldCostTotal:21:=[Estimates_FormCartons:48]ItemCost_Per_M:6
			//[JobMakesItem]EstCost_M:=[CARTON_SPEC]CostWant_Per_M`upr 1449 3/10/95
			//[JobMakesItem]Qty_Actual:=0
			//  [JobMakesItem]CustId:=$1  `• 1/9/97 - cs modification for multiple jobs on one
			[Job_Forms_Items:44]CustId:15:=[Estimates_Carton_Specs:19]CustID:6  //• 1/9/97 - cs modification for multiple jobs on one form
			
			[Job_Forms_Items:44]ProjectNumber:6:=pjtId
			[Job_Forms_Items:44]AllocationPercent:23:=[Estimates_FormCartons:48]AllocationPercent:11*100
			
			JOB_getItemAccumulations(0; [Job_Forms_Items:44]JobForm:1; [Job_Forms_Items:44]Qty_Want:24; [Job_Forms_Items:44]NumberUp:8; [Job_Forms_Items:44]Qty_Yield:9)
			JMI_findDefaultOrderPeg("peg")
			
			SAVE RECORD:C53([Job_Forms_Items:44])
			//in the trigger above-> $err:=JIC_Create ([JobMakesItem]Jobit)
			NEXT RECORD:C51([Estimates_FormCartons:48])
		End for 
		JMI_findDefaultOrderPeg("done")
		
	Else 
		BEEP:C151
		ALERT:C41("No Form items were found, better check the results.")
	End if 
	
	//clean up unused sequences
	If (Count parameters:C259>2)  //revising, so blank out existing data
		USE SET:C118("currentSeqs")
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3="DELETE")
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			DELETE SELECTION:C66([Job_Forms_Items:44])
		End if 
		
		//see if any Have Ready dates were lost
		For ($i; 1; Size of array:C274($aCPN))
			USE SET:C118("currentSeqs")
			QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$aCPN{$i})
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37:=$aHRD{$i})
			End if 
		End for 
		
		USE SET:C118("currentSeqs")
		$numHRDsAfter:=0
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]MAD:37; $aHRD)
		For ($i; 1; Size of array:C274($aHRD))
			If ($aHRD{$i}#!00-00-00!)
				$numHRDsAfter:=$numHRDsAfter+1
			End if 
		End for 
		CLEAR SET:C117("currentSeqs")
		
		If ($numHRDs#$numHRDsAfter)
			ALERT:C41("Count of Have Ready Dates is different, contact Scheduling dept.")
		End if 
		
	End if 
	
End if   //no jmi were locked