//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// Date: 020499
// ----------------------------------------------------
// Method: Job_Bag_Validate
// Description:
// Ensure that the budget adheres to rules for completeness
// ----------------------------------------------------
// Modified by: Mel Bohince (5/31/13) make the p&g test stand by it self
// Modified by: Mel Bohince (1/30/14) disable Est_PandGQtyTest
// Modified by: Mel Bohince (12/15/14) Require a jobtype description for non-production work
// Modified by: Mel Bohince (1/29/20) test for COC (fsc) stock required

C_BOOLEAN:C305($0; $Failed)  //rtn true if valid, false if problem
C_TEXT:C284($1)
C_LONGINT:C283($i; $inkMissing; $qtyMissing; $openPrepWork)

$Failed:=False:C215  //optimistic
$versionControlProblem:=False:C215
$validOrderlineProblem:=False:C215
$openPrepWork:=0
zwStatusMsg("VALIDATING"; " Checking Job Bag for completeness")

If (Count parameters:C259>0)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
End if 

//If (Not(Est_PandGQtyTest (->$Failed;"Print")))  // Added by: Mark Zinke (3/18/13)
// Modified by: Mel Bohince (5/31/13) make the p&g test stand by it self
//min/max failure
//$Failed:=True
//alert msg handled by Est_PandGQtyTest
//End if   // Modified by: Mel Bohince (5/31/13) make the p&g test stand by it self
Case of 
	: ([Job_Forms:42]JobType:33="")  //added 3/1695, with below change, on site Jim B request
		ALERT:C41("You Need to Select a Job type.")
		$Failed:=True:C214
	: (Position:C15(Substring:C12([Job_Forms:42]JobType:33; 1; 1); " 2 5 6 9")>0)  // Modified by: Mel Bohince (12/15/14) Require a jobtype description for non-production work
		If (Length:C16([Job_Forms:42]JobTypeDescription:88)<2)
			ALERT:C41("You Need to enter a Job Type Description.")
			$Failed:=True:C214
		End if 
	Else 
		
		
		If (Position:C15("Prod"; [Job_Forms:42]JobType:33)>0) | (Position:C15("Do Over"; [Job_Forms:42]JobType:33)>0)  //only for these job types do validation  
			If ([Job_Forms:42]NeedDate:1=!00-00-00!)
				//$Failed:=True
				ALERT:C41("WARNING: "+Char:C90(13)+"The Need Date is missing on form "+[Job_Forms:42]JobFormID:5)
			End if 
			
			READ ONLY:C145([Customers_Order_Lines:41])
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $aOrdItem; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]SubFormNumber:32; $aSF; [Job_Forms_Items:44]CustId:15; $aCust; [Job_Forms_Items:44]OutlineNumber:43; $aOutline; [Job_Forms_Items:44]ControlNumber:26; $aControl)
			//$numSF:=0
			zwStatusMsg("VALIDATING"; " Checking Job Bag for completeness... Items")
			For ($i; 1; Size of array:C274($aOrdItem))
				//version checks
				$fg_outline:=Replace string:C233(FG_getOutline($aCPN{$i}; $aCust{$i}); " "; "")
				If (Length:C16($fg_outline)>0)
					If ($aOutline{$i}#$fg_outline)
						BEEP:C151
						ALERT:C41($aCPN{$i}+"'s Outline is different on the F/G record. Revise Job.")
						$Failed:=True:C214
						$versionControlProblem:=True:C214
						//$aOrdItem{$i}:="!Outline!"
					End if 
				End if 
				
				$fg_control:=Replace string:C233(FG_getControlNumber($aCPN{$i}; $aCust{$i}); " "; "")
				If (Length:C16($fg_control)>0)
					If ($aControl{$i}#$fg_control)
						BEEP:C151
						ALERT:C41($aCPN{$i}+"'s Control Number is different on the F/G record. Revise Job.")
						$Failed:=True:C214
						$versionControlProblem:=True:C214
						//$aOrdItem{$i}:="!Control!"
					End if 
				End if 
				
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=($aCust{$i}+":"+$aCPN{$i}); *)
				QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!)
				If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
					$openPrepWork:=$openPrepWork+Records in selection:C76([Finished_Goods_Specifications:98])
				End if 
				
				Case of 
					: ($aOrdItem{$i}="FORECAST")  //legal exception
					: ($aOrdItem{$i}="DF@")  //legal exception
					: ($aOrdItem{$i}="Excess")  //legal exception
					: ($aOrdItem{$i}="Fill-In")  //legal exception
					: ($aOrdItem{$i}="Rerun")  //`•082399  mlb  add "rerun" legal exception
					: ($aOrdItem{$i}="Killed")  //•082302  mlb  
						
					Else 
						QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOrdItem{$i})
						Case of 
							: (Records in selection:C76([Customers_Order_Lines:41])=1)
								If ([Customers_Order_Lines:41]ProductCode:5#$aCPN{$i})
									$aOrdItem{$i}:="CPNinvalid"
									MESSAGE:C88(" "+$aOrdItem{$i})
									$Failed:=True:C214
									$validOrderlineProblem:=True:C214
								End if 
							: (Records in selection:C76([Customers_Order_Lines:41])>1)
								$aOrdItem{$i}:="Not Unique"
								MESSAGE:C88(" Invalid, "+$aOrdItem{$i})
								$Failed:=True:C214
								$validOrderlineProblem:=True:C214
							Else   //=0
								$aOrdItem{$i}:="OL invalid"  //•6/07/99  MLB  exceeded 10 chars
								MESSAGE:C88(" "+$aOrdItem{$i})
								$Failed:=True:C214
								$validOrderlineProblem:=True:C214
						End case 
				End case   //excess or fill in   or forecast  
			End for 
			
			If ($Failed)  //save problems
				If ($versionControlProblem)
					ALERT:C41("One or More Control#s/Outline# are OUT DATED."+"  You May NOT Print "+[Job_Forms:42]JobFormID:5+"'s Job Bag Until it has been REVISED.")
				End if 
				
				If ($validOrderlineProblem)
					ARRAY TO SELECTION:C261($aOrdItem; [Job_Forms_Items:44]OrderItem:2)  // on form "+[JobForm]JobFormID
					ALERT:C41("One or More Orderlines are INVALID."+"  You May NOT Print "+[Job_Forms:42]JobFormID:5+"'s Job Bag Until ALL OrderLines are Valid.")
				End if 
			End if 
			REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		End if 
		
		If (Current user:C182="Designer")
			$Failed:=False:C215  //••••••debug
		End if 
		zwStatusMsg("VALIDATING"; " Checking Job Bag for completeness...Materials")
		SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $aComm; [Job_Forms_Materials:55]Raw_Matl_Code:7; $aRM; [Job_Forms_Materials:55]Planned_Qty:6; $aPlnQty; [Job_Forms_Materials:55]Actual_Qty:14; $aActQty)
		$inkMissing:=0
		$qtyMissing:=0
		$boardMissing:=0
		$lamMissing:=0
		$leafMissing:=0
		$sensorsMissing:=0
		
		//Check for Obsolete RM's specified
		READ ONLY:C145([Raw_Materials:21])
		QUERY WITH ARRAY:C644([Raw_Materials:21]Raw_Matl_Code:1; $aRM)
		SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $aRAW_RM; [Raw_Materials:21]Status:25; $aRAW_Stat; [Raw_Materials:21]Successor:34; $aRAW_Successor)
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
		$hit:=Find in array:C230($aRAW_Stat; "Obsolete")
		If ($hit>-1)  //some rm is obsolete so we'll need to swap or fail
			uConfirm("One or More Raw Materials specified is Obsolete, will attempt to find replacement."; "OK"; "Help")
			$isReadOnly:=Read only state:C362([Job_Forms_Materials:55])
			If ($isReadOnly)
				READ WRITE:C146([Job_Forms_Materials:55])
			End if 
			FIRST RECORD:C50([Job_Forms_Materials:55])
			For ($bud_rm; 1; Records in selection:C76([Job_Forms_Materials:55]))
				If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)  //rm specified
					$hit:=Find in array:C230($aRAW_RM; [Job_Forms_Materials:55]Raw_Matl_Code:7)
					If ($hit>-1)  //this shouldn't fail
						If ($aRAW_Stat{$hit}="Obsolete")  //one that we're interested in
							READ WRITE:C146([Job_Forms_Materials:55])
							UNLOAD RECORD:C212([Job_Forms_Materials:55])
							LOAD RECORD:C52([Job_Forms_Materials:55])
							
							If (Length:C16($aRAW_Successor{$hit})>0)  //replacement available
								$Failed:=RM_findSuccessorToObsolete($aRAW_Successor{$hit}; $aRAW_RM{$hit})  // Fixed by mlb, 12/10/14  Added by: Mark Zinke (8/1/13) Make sure the successor isn't obsolete.
								
							Else 
								uConfirm([Job_Forms_Materials:55]Raw_Matl_Code:7+" is Obsolete and no successor found. You must fix before printing jobbag "+[Job_Forms:42]JobFormID:5; "OK"; "Help")
								[Job_Forms_Materials:55]Raw_Matl_Code:7:=""  //dump it
								$Failed:=True:C214
								
							End if 
							SAVE RECORD:C53([Job_Forms_Materials:55])
						End if 
					End if 
				End if 
				NEXT RECORD:C51([Job_Forms_Materials:55])
			End for 
			
			If ($isReadOnly)
				READ ONLY:C145([Job_Forms_Materials:55])
				UNLOAD RECORD:C212([Job_Forms_Materials:55])
				LOAD RECORD:C52([Job_Forms_Materials:55])
			End if 
			
		End if 
		
		For ($i; 1; Size of array:C274($aComm))
			If ($aComm{$i}="02@") & ($aRM{$i}="")
				$inkMissing:=$inkMissing+1
			End if 
			
			If ($aComm{$i}="08@") & ($aRM{$i}="")
				$lamMissing:=$lamMissing+1
			End if 
			
			If ($aComm{$i}="05@") & ($aRM{$i}="")
				$leafMissing:=$leafMissing+1
			End if 
			
			If ($aComm{$i}="12@") & ($aRM{$i}="")
				$sensorsMissing:=$sensorsMissing+1
			End if 
			
			If ($aComm{$i}="01@")
				If ($aRM{$i}="")
					$boardMissing:=$boardMissing+1
				Else 
					$rm:=$aRM{$i}
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$aRM{$i})
					If (Records in selection:C76([Raw_Materials:21])>0)
						$stockWidth:=[Raw_Materials:21]Flex2:20
						If ([Job_Forms:42]ShortGrain:48)
							$sheetWidth:=[Job_Forms:42]Lenth:24
						Else 
							$sheetWidth:=[Job_Forms:42]Width:23
						End if 
						If ($stockWidth#$sheetWidth)
							BEEP:C151
							//zwStatusMsg ("WARNING";"Stock width = "+String($stockWidth)+" Sheet width = "
							//«+String($sheetWidth))
							ALERT:C41("WARNING: Check the width of the stock you specified."+Char:C90(13)+"Stock width = "+String:C10($stockWidth)+" Sheet width = "+String:C10($sheetWidth))
						End if 
					End if 
				End if 
			End if 
			// If ($aComm{$i}="01@") & ($aRM{$i}#"")
			//$boardType:=$aRM{$i}
			//End if 
			If ($aPlnQty{$i}<=0) & ($aActQty{$i}=0)  //•020499  MLB 
				$qtyMissing:=$qtyMissing+1
			End if 
		End for 
		
		If ($inkMissing>0)
			ALERT:C41(String:C10($inkMissing)+" Budgeted ink(s) without Raw Material code."+Char:C90(13)+"Please enter a Material code for every budgeted ink on "+[Job_Forms:42]JobFormID:5)
			$Failed:=True:C214
		End if 
		
		If ($lamMissing>0)
			ALERT:C41("Warning: "+String:C10($lamMissing)+" Budgeted lamination without Raw Material code."+Char:C90(13)+"Please enter a R/M code on "+[Job_Forms:42]JobFormID:5)
			//$Failed:=True
		End if 
		
		If ($leafMissing>0)
			ALERT:C41("Warning: "+String:C10($leafMissing)+" Budgeted Leaf without Raw Material code."+Char:C90(13)+"Please enter a R/M code on "+[Job_Forms:42]JobFormID:5)
			//$Failed:=True
		End if 
		
		If ($sensorsMissing>0)
			ALERT:C41("Warning: "+String:C10($sensorsMissing)+" Budgeted Sensor Label without Raw Material code."+Char:C90(13)+"Please enter a R/M code on "+[Job_Forms:42]JobFormID:5)
			$Failed:=True:C214
		End if 
		
		If ($boardMissing>0)
			ALERT:C41(String:C10($boardMissing)+" Board needs Raw Material code."+Char:C90(13)+"Please pick a Material code for board & paper "+[Job_Forms:42]JobFormID:5)
			$Failed:=True:C214
		End if 
		
		If ($qtyMissing>0)
			ALERT:C41(String:C10($qtyMissing)+" Budgeted Material(s) without Planned Qty."+Char:C90(13)+"Please fix budget and recalculate "+[Job_Forms:42]JobFormID:5)
			//$Failed:=True
		End if 
		
		If ($openPrepWork>0)  //• mlb - 6/19/02  12:06
			ALERT:C41("WARNING!  WARNING!   Will, Penny..."+Char:C90(13)+String:C10($openPrepWork)+" Open Prep Work Orders exist against this jobform:"+[Job_Forms:42]JobFormID:5+Char:C90(13)+"Please contact the Imaging Dept ")
		End if 
		
		//Case of Moved up top
		//: ([Job_Forms]JobType="")  //added 3/1695, with below change, on site Jim B request
		//ALERT("You Need to Select a Job type.")
		//$Failed:=True
		//: ([Job_Forms]Run_Location="")  //• 6/29/98 cs install a system to track where Job is to run
		//ALERT("It is required that you specify where this JobForm will be running.")
		//  //$Failed:=True
		//End case 
		
		//End if Modified by: Mel Bohince (5/31/13) make the p&g test stand by it self
End case 

If ($Failed)
	If ([Job_Forms:42]Status:6="C@")  //closed or completed, so who cares`•2/21/01  mlb
		$Failed:=False:C215
	End if 
	// Modified by: Mel Bohince (12/19/19) dont hard code frank
	If (User in group:C338(Current user:C182; "BoardScheduler"))  //(Current user="Frank Clark")
		$Failed:=False:C215
	End if 
End if 

$0:=$Failed

OK:=Num:C11(Not:C34($Failed))