//%attributes = {"publishedWeb":true,"executedOnServer":true}
//PM:  JIC_Regenerate($fgKey})  111299  mlb
//normally called with $1 = "@" to do all f/g
//############
//############
//############ if called with specific fgkey, then you must FG_Bill_and_Hold_Collection ("init") and FG_Bill_and_Hold_Collection ("kill") in calling method 
//############
//############
//set up the jobitemcost records from scratch
//called from rRptMthEndSuite and Batch_Runner
//•2/24/00  mlb allow specific cpn to be regen'd
// • mel (2/11/04, 17:03:40) added canHaveExcess flag for Marty test
//see also Fifo_CalcItem
//◊IgnorObsoleteAndOld flag option to exclude fg's that are statused as obsolete or glued 9 mths ago (07/11/07), not currently activated (11/2011)

//How is the FIFO Valuation done?  FIFO is done in two passes: (from blog entry 3/5/2004)

//1st-Deteremine excesses. For each jobit that is on-hand, find its Production quantity. 
//     The amount over the lesser of Want (+5%) or Good is Excess and excused from the rest of the calculation,
//     designate the rest the "Basis" quantity. This is shown in the FIFO Detail report.

//2nd-Distribute quantities. All units are spread from newest to oldest job that made that item,
//     up to their Basis quantity. The quantity that is allocated to each job is extended by that jobs unit cost.
//     The sum of those extensions is the value assigned to that item. The unit cost used is at budget unless  
//     the jobit has been tagged as Closed. This is shown in the FIFO Summary report.

//Each costed jobitem record, [Job_Forms_Items], aka jmi, is given a cost record, [Job_Forms_Items_Costs], aka jic. The cost record has two parts, the allocated part and the remaining part,
//  the idea being that the entire cost of the job is to be allocated to the planned (want) qty, not the total produced, thus transferring to the CoGS per customer liability. 
// The remaining part is initially equal to the allocated part then relieved as the item ships or is scrapped. At the time that the remaining part is zero, any 
// additional inventory of that item is uncosted excess. In general terms this excess is the quantity produced over the want qty. The final step in this method is to push qty's from older jobs
// to newer jobs so fifo costing is maintained even if the inventory is shipped out of order.

//see x_fifo_error_check for a sanity check where shipping didn't fifo

// Modified by: Mel Bohince (5/15/14) don't change fg selection when passed one cpn like from THC_request_update
// Modified by: Mel Bohince (5/12/16) devalue FG in locations with a killstat=1 or location contains kill


C_TEXT:C284($1; $fgKey)
C_TEXT:C284($custid)
C_TEXT:C284($cpn)
C_LONGINT:C283($numJMI; $numJIC; $i; $recNo; $now; $qty)
C_BOOLEAN:C305(canHaveExcess; $valueIt; $initBnH; $ignoreKills)  //see also JOB_AllocateActual
C_DATE:C307($ignoreBefore)
//trace
MESSAGES OFF:C175
$ignoreKills:=True:C214  // Modified by: Mel Bohince (5/12/16) devalue FG in locations with a killstat=1 or location contains kill
canHaveExcess:=True:C214  //original code
$initBnH:=True:C214  // Modified by: Mel Bohince (5/15/14) don't change fg selection when passed one cpn like from THC_request_update

If (Current user:C182="Designer")
	//canHaveExcess:=False
End if 



If (Count parameters:C259=0)  //test case
	CONFIRM:C162("Recreate JobItemCost records for all existing JobMakesItem records?"; "Create"; "Cancel")
	$fgKey:="@"  //all
	$cpn:="@"
	$custid:="@"
	
Else 
	$fgKey:=$1
	If (Length:C16($fgKey)>6)
		$initBnH:=False:C215  // Modified by: Mel Bohince (5/15/14) don't change fg selection when passed one cpn like from THC_request_update
		$cpn:=Substring:C12($fgKey; 7)
		$custid:=Substring:C12($fgKey; 1; 5)
		
	Else 
		x_FixJMIFormClosed2  //sets the items closed if the form is closed so actuals are used instead of budget
		$cpn:="@"
		$custid:="@"
	End if 
	OK:=1
End if 
//TRACE
If (OK=1)
	// ////////////////////////////////////
	//1==>  zero out all the existing [Job_Forms_Items_Costs] records, as they may no longer be in play
	$now:=TSTimeStamp
	
	//zwStatusMsg ("ReGen";"Zero'g JIC records")
	READ WRITE:C146([Job_Forms_Items_Costs:92])
	QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=$fgKey)  //QUERY([JobItemCosts];[JobItemCosts]FG_Key="00125:20-103900-01")`a test case
	
	If (Count parameters:C259>0)  //normally 1 which is the @ sign
		$numJIC:=Records in selection:C76([Job_Forms_Items_Costs:92])
		ARRAY LONGINT:C221($zeroQty; $numJIC)
		ARRAY REAL:C219($zeroMatl; $numJIC)
		ARRAY REAL:C219($zeroLabor; $numJIC)
		ARRAY REAL:C219($zeroBurden; $numJIC)
		ARRAY REAL:C219($zeroTotal; $numJIC)
		For ($i; 1; $numJIC)
			$zeroQty{$i}:=0
			$zeroMatl{$i}:=0
			$zeroLabor{$i}:=0
			$zeroBurden{$i}:=0
			$zeroTotal{$i}:=0
		End for 
		ARRAY TO SELECTION:C261($zeroQty; [Job_Forms_Items_Costs:92]AllocatedQuantity:14; $zeroMatl; [Job_Forms_Items_Costs:92]AllocatedMaterial:4; $zeroLabor; [Job_Forms_Items_Costs:92]AllocatedLabor:5; $zeroBurden; [Job_Forms_Items_Costs:92]AllocatedBurden:6; $zeroTotal; [Job_Forms_Items_Costs:92]AllocatedTotal:7)
		ARRAY TO SELECTION:C261($zeroQty; [Job_Forms_Items_Costs:92]RemainingQuantity:15; $zeroMatl; [Job_Forms_Items_Costs:92]RemainingMaterial:9; $zeroLabor; [Job_Forms_Items_Costs:92]RemainingLabor:10; $zeroBurden; [Job_Forms_Items_Costs:92]RemainingBurden:11; $zeroTotal; [Job_Forms_Items_Costs:92]RemainingTotal:12)
		ARRAY LONGINT:C221($zeroQty; 0)
		ARRAY REAL:C219($zeroMatl; 0)
		ARRAY REAL:C219($zeroLabor; 0)
		ARRAY REAL:C219($zeroBurden; 0)
		ARRAY REAL:C219($zeroTotal; 0)
		
	Else   //*Get rid of any existing [Job_Forms_Items_Costs] records for test case
		util_DeleteSelection(->[Job_Forms_Items_Costs:92]; "no-msg"; "locked-ok")
	End if 
	
	If (Count parameters:C259=0)
		FLUSH CACHE:C297
	End if 
	// ////////////////////////////////////
	
	//2==>  *create new or update cost records allocated values, form may have closed since last calc
	// every jmi record will have a jic record with its allocation part set after this step
	
	//cache jobits that have receipts so value isn't given to an unproduced jobit
	$ignoreBefore:=Add to date:C393(4D_Current_date; 0; -10; 0)  //over 9 months are devalued anyway
	READ ONLY:C145([Finished_Goods_Transactions:33])
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>$ignoreBefore; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]ProductCode:1=$cpn; *)  // maybe running for just one code
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Qty:6>1)  //negatives and batch 1's
	DISTINCT VALUES:C339([Finished_Goods_Transactions:33]Jobit:31; $aFGXjobit)
	
	READ ONLY:C145([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$cpn; *)  //QUERY([JobMakesItem];[JobMakesItem]ProductCode="20-103900-01")
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=$custid)
	
	$numJMI:=Records in selection:C76([Job_Forms_Items:44])
	uThermoInit($numJMI; "Preparing JobItemCosts Records")
	For ($i; 1; $numJMI)
		//If (Position("Lip Gloss V1";[Job_Forms_Items]ProductCode)>0)
		//TRACE
		//end if
		If (<>IgnorObsoleteAndOld)  // set on DBA screen so that status obsolete fg and glued > 9mth items are not costed
			$valueIt:=JMI_TestForValue([Job_Forms_Items:44]Jobit:4)
			
		Else 
			$valueIt:=True:C214
		End if 
		
		If ($valueIt)
			//exclude if this jobit doesn't appear to have glue transactions greater than 1
			$hit:=Find in array:C230($aFGXjobit; [Job_Forms_Items:44]Jobit:4)
			If ($hit=-1)
				$valueIt:=False:C215
			End if 
		End if 
		
		If ($valueIt)
			$recNo:=JIC_Create([Job_Forms_Items:44]Jobit:4)
			
		Else   //remove its cost record
			QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3=[Job_Forms_Items:44]Jobit:4)
			If (Records in selection:C76([Job_Forms_Items_Costs:92])>0)
				util_DeleteSelection(->[Job_Forms_Items_Costs:92]; "no-msg")
			End if 
			//utl_Logfile ("not_valued.log";"Ignored: "+[Job_Forms_Items]Jobit+" "+[Job_Forms_Items]ProductCode)
		End if 
		
		NEXT RECORD:C51([Job_Forms_Items:44])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	//3==>  Establish the onhand qty of inventory by jobit in preparation for calc'g excesses
	// after summing the bin qtys, the Bill and Hold will be deducted
	//*consolidate bin qtys to jobits $aJobit and $aQtyOH
	//zwStatusMsg ("Loading";"Bins")
	READ WRITE:C146([Finished_Goods_Locations:35])
	If (Not:C34($ignoreKills))  //count all inventory
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$fgKey)
	Else   //elim kills
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$fgKey; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]KillStatus:30=0; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"@kill@")
	End if 
	
	ARRAY LONGINT:C221($aQtyBin; 0)  //intermediate
	ARRAY TEXT:C222($aLocationJobit; 0)  //intermediate
	ARRAY LONGINT:C221($aQtyOH; 0)  //used by fifo
	ARRAY LONGINT:C221($aQtyMade; 0)  //used by fifo
	ARRAY TEXT:C222($aJobit; 0)  //used by fifo
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $aLocationJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQtyBin)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	$numJMI:=Size of array:C274($aLocationJobit)
	SORT ARRAY:C229($aLocationJobit; $aQtyBin; >)
	ARRAY LONGINT:C221($aQtyOH; $numJMI)
	ARRAY TEXT:C222($aJobit; $numJMI)
	C_LONGINT:C283($jobCursor)
	$jobCursor:=0
	//uThermoInit ($numJMI;"Collapsing inventory to jobit's")
	For ($i; 1; $numJMI)  //collapse inventory down to jobit's    
		$hit:=Find in array:C230($aJobit; $aLocationJobit{$i}; $jobCursor)
		If ($hit=-1)
			$jobCursor:=$jobCursor+1
			$aJobit{$jobCursor}:=$aLocationJobit{$i}
			$hit:=$jobCursor
		End if 
		$aQtyOH{$hit}:=$aQtyOH{$hit}+$aQtyBin{$i}
		//uThermoUpdate ($i)
	End for 
	//uThermoClose 
	ARRAY LONGINT:C221($aQtyOH; $jobCursor)
	ARRAY TEXT:C222($aJobit; $jobCursor)
	ARRAY LONGINT:C221($aQtyMade; $jobCursor)
	ARRAY LONGINT:C221($aQtyBin; 0)
	ARRAY TEXT:C222($aLocationJobit; 0)
	$numJMI:=$jobCursor
	
	//4==>  Reduce onhand qty where we are holding payed for cartons (B&H)
	//adjust out the Bill and holds
	If ($initBnH)  //WARNING: FG_Bill_and_Hold_Collection WILL CHG THE FG SELECTION!
		$numBH:=FG_Bill_and_Hold_Collection("init")  //init creates arrays that show inventory by jobit reduced by the amount that was billed and held
	End if 
	For ($i; 1; $numJMI)  //remove b&h from jobit's  
		//If ($aJobit{$i}="86897.05.48")  ` | ($aJobit{$i}="86844.01.15") | ($aJobit{$i}="87149.01.18")  `M8M1-01-8111  6HM3-01-E112
		//TRACE
		//End if 
		$ourQty:=FG_Bill_and_Hold_Collection("avail_jmi"; $aJobit{$i})  // -1 is returned if no B&H involvement
		If ($ourQty>=0)  //involved with a b&h so use the adjusted qty
			$aQtyOH{$i}:=$ourQty
		End if 
	End for 
	If ($initBnH)
		$numBH:=FG_Bill_and_Hold_Collection("kill")
	End if 
	
	// ////////////////////////////////////
	//somewhat obsolete as netchg is no long run, instead we do a complete regen, but this does leave a tag that it was done.
	iEndAt:=TSTimeStamp  //set the date for next time a net chg is run
	TS2DateTime(iEndAt; ->dDateEnd; ->tTimeEnd)
	$err:=Batch_RunDate("Set"; "JIC_NetChg"; ->dDateEnd; ->iEndAt)  //set the date for next time
	// ////////////////////////////////////
	
	//5==> Now need to establish the qty produced by each jobit so excess can be determined by adding inventory to shipments
	// this is the final set of "1st-Deteremine excesses", we'll be left with cost records for jobits with a remaining qty
	// at this point the jmi population are only ones with onhand inventory
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$fgKey)
		uRelateSelect(->[Finished_Goods_Transactions:33]Jobit:31; ->[Finished_Goods_Locations:35]Jobit:33)
		CREATE SET:C116([Finished_Goods_Transactions:33]; "releventXfers")
		
		
	Else 
		
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Transactions:33])+" file. Please Wait...")
		QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
			([Finished_Goods_Transactions:33]Jobit:31=[Finished_Goods_Locations:35]Jobit:33)\
			 & ([Finished_Goods_Locations:35]FG_Key:34=$fgKey)\
			)
		
		zwStatusMsg(""; "")
	End if   // END 4D Professional Services : January 2019 query selection
	
	//uThermoInit ($numJMI;"Adding in Shipments")
	For ($i; 1; $numJMI)  //look for what has already been shipped on each jobit    
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			USE SET:C118("releventXfers")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="B&H@"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="SHIP"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Jobit:31=$aJobit{$i})
			
		Else 
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=[Finished_Goods_Locations:35]Jobit:33)\
				 & ([Finished_Goods_Locations:35]FG_Key:34=$fgKey)\
				 & (([Finished_Goods_Transactions:33]XactionType:2="B&H@") | ([Finished_Goods_Transactions:33]XactionType:2="SHIP"))\
				 & ([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$i})\
				)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)  //*Add in any net shipments
			$shipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		Else 
			$shipped:=0
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			USE SET:C118("releventXfers")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Jobit:31=$aJobit{$i})
			
		Else 
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=[Finished_Goods_Locations:35]Jobit:33)\
				 & ([Finished_Goods_Locations:35]FG_Key:34=$fgKey)\
				 & (([Finished_Goods_Transactions:33]XactionType:2="Return") | ([Finished_Goods_Transactions:33]XactionType:2="RevShip"))\
				 & ([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$i})\
				)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)  //remove anything that reverses a shipment
			$shipped:=$shipped-Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		End if 
		
		$aQtyMade{$i}:=$aQtyOH{$i}+$shipped  //scraps are being ignored because they shouldnt be counted as "good" qty
		If ($aQtyMade{$i}>0)
			QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3=$aJobit{$i})
			If (Records in selection:C76([Job_Forms_Items_Costs:92])>0)
				$excess:=$aQtyMade{$i}-[Job_Forms_Items_Costs:92]AllocatedQuantity:14
				If (canHaveExcess)
					If ($excess<=0)  //don't negate
						$remainingCost:=JIC_RemainingSetTo($aJobit{$i}; $aQtyOH{$i})
					Else 
						$remainingCost:=JIC_RemainingSetTo($aJobit{$i}; ($aQtyOH{$i}-$excess))
					End if 
					
				Else 
					$remainingCost:=JIC_RemainingSetTo($aJobit{$i}; $aQtyOH{$i})
				End if 
				
			End if 
		End if   //some made
		//uThermoUpdate ($i)
	End for 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		CLEAR SET:C117("releventXfers")
		
	Else 
		
	End if   // END 4D Professional Services : January 2019 query selection
	//uThermoClose 
	
	//6==> The last step is to move remaining qty's to the latest jobs there by enforcing fifo costing, with excesses already removed.
	// Essentially grab all remaining qtys then re-apply them from latest to earliest until all have been distributed.
	// This means that the "real" jobit's cost may no longer be applicable. If the Shipping Dept has followed the SOP
	// there should be no supprises here. 
	
	QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=$fgKey; *)
	//QUERY([Job_Forms_Items_Costs]; & ;[Job_Forms_Items_Costs]RemainingQuantity>0) `ERROR will occur if latest job is completely devoid of inventory.
	QUERY:C277([Job_Forms_Items_Costs:92];  & ; [Job_Forms_Items_Costs:92]AllocatedQuantity:14>0)
	
	ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13; >; [Job_Forms_Items_Costs:92]Jobit:3; <)
	SELECTION TO ARRAY:C260([Job_Forms_Items_Costs:92]FG_Key:13; $aCPN; [Job_Forms_Items_Costs:92]Jobit:3; $aJobit; [Job_Forms_Items_Costs:92]AllocatedQuantity:14; $aAlloQty; [Job_Forms_Items_Costs:92]RemainingQuantity:15; $aRemQty)
	$numJIC:=Size of array:C274($aJobit)
	//consider:
	//BEFORE:
	//part - job - remain - alloc
	//partA - j3 - 0 - 200
	//partA - j3 - 100 - 200
	//partA - j3 - 15 - 200
	//partB - j3 - 30 - 200
	//AFTER:
	//part - job - remain - alloc
	//partA - j3 - 115 - 200
	//partA - j3 - 0 - 200
	//partA - j3 - 0 - 200
	//partB - j3 - 30 - 200
	//uThermoInit ($numJIC;"Applying FiFO Logic")
	For ($i; 1; $numJIC)
		//uThermoUpdate ($i)
		$next:=$i+1
		$continue:=True:C214
		
		While ($aRemQty{$i}<$aAlloQty{$i}) & ($continue)  //see if next jobit is for same cpn      
			$need:=$aAlloQty{$i}-$aRemQty{$i}
			
			Case of 
				: ($next>$numJIC)  //stay inbounds
					$continue:=False:C215
					
				: ($aCPN{$next}#$aCPN{$i})  //same cpn, take its inventory
					$continue:=False:C215
					
				: ($aRemQty{$next}=0)  //can't help
					//look at next jobit
					
				: ($aRemQty{$next}<=$need)
					$aRemQty{$i}:=$aRemQty{$i}+$aRemQty{$next}
					$aRemQty{$next}:=0
					
				: ($aRemQty{$next}>$need)
					$aRemQty{$i}:=$aRemQty{$i}+$need
					$aRemQty{$next}:=$aRemQty{$next}-$need
			End case 
			
			$next:=$next+1
		End while 
		
	End for 
	//uThermoClose 
	
	//uThermoInit ($numJIC;"Saving Remaining Qty's")
	For ($i; 1; $numJIC)
		//uThermoUpdate ($i)
		$remainingCost:=JIC_RemainingSetTo($aJobit{$i}; $aRemQty{$i})
	End for 
	//uThermoClose 
	
	// End if   `false5
	If (Count parameters:C259=0)
		FLUSH CACHE:C297
	End if 
	
	REDUCE SELECTION:C351([Job_Forms_Items_Costs:92]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	
	
	zwStatusMsg("JIC ReGen"; "Elapsed: "+String:C10(TS2Time(TSTimeStamp-$now); HH MM SS:K7:1))
End if   //runit