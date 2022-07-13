//%attributes = {"publishedWeb":true}
//PM:  JIC_NetChange  2/03/00  mlb
//adjust the fifo inventory based on a selection of FG transactions
//see also JIC_Regenerate

C_LONGINT:C283(iEndAt; iBeginAt; $err; $numXfers; $uniqueCPNs; $i; $numJIC; $allowable; $j)
C_DATE:C307(dDateEnd; dDateBegin)
C_TIME:C306(tTimeEnd; tTimeBegin)
C_REAL:C285($oldValue; $newValue; $dollarChg)
C_TEXT:C284($cpnsConsidered)

$cpnsConsidered:="Product codes with activity:"+Char:C90(13)
QUERY:C277([z_batch_run_dates:77]; [z_batch_run_dates:77]BatchType:4="JIC_NetChg")
If (Records in selection:C76([z_batch_run_dates:77])=0)  //need to regen from scratch
	JIC_Regenerate("@")
Else   //do the net chg of the fg transactions
	$newValue:=0
	$oldValue:=0
	$dollarChg:=0
	//*Determine date to assign to this invocation
	iEndAt:=TSTimeStamp
	//dDateEnd:=TS2Date (iEndAt)
	TS2DateTime(iEndAt; ->dDateEnd; ->tTimeEnd)  //•110899  mlb get time boundary on upside
	
	//*Determine the date of the last run,
	$err:=Batch_RunDate("Get"; "JIC_NetChg"; ->dDateBegin; ->iBeginAt)
	If ($err=0)
		If (iBeginAt=0)  //if can not determine, go with the end date, therefore no transacitons
			iBeginAt:=iEndAt
		End if 
		TS2DateTime(iBeginAt; ->dDateBegin; ->tTimeBegin)
		
		//Remove the transaction that are obviously not wanted
		//SET QUERY DESTINATION(Into set;"Candidates")`
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5#"@.sb"; *)  //dont want special billings
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2#"MOVE"; *)  //don't want move transactions
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]JobForm:5#"Price@"; *)  //don't want price changes
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin)  //not the day before
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Candidates")
			//remove the trans prior to last TIME
			//SET QUERY DESTINATION(Into set;"beforeLast")`
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=dDateBegin; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionTime:13<tTimeBegin)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "beforeLast")
			
			DIFFERENCE:C122("Candidates"; "beforeLast"; "Candidates")
			CLEAR SET:C117("beforeLast")
			
			//•110899  mlb  take care of back dated transactions
			USE SET:C118("Candidates")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=dDateEnd; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionTime:13>tTimeEnd)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "afterNow")
			DIFFERENCE:C122("Candidates"; "afterNow"; "Candidates")
			CLEAR SET:C117("afterNow")
			USE SET:C118("Candidates")
			
		Else 
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				(\
				(\
				([Finished_Goods_Transactions:33]JobForm:5#"@.sb")\
				 & ([Finished_Goods_Transactions:33]XactionType:2#"MOVE")\
				 & ([Finished_Goods_Transactions:33]JobForm:5#"Price@")\
				 & ([Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin)\
				)\
				#\
				(\
				([Finished_Goods_Transactions:33]XactionDate:3=dDateBegin)\
				 & ([Finished_Goods_Transactions:33]XactionTime:13<tTimeBegin)\
				)\
				)\
				#\
				(\
				([Finished_Goods_Transactions:33]XactionDate:3=dDateEnd)\
				 & ([Finished_Goods_Transactions:33]XactionTime:13>tTimeEnd)\
				)\
				)
			
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Candidates")
		End if   // END 4D Professional Services : January 2019 query selection
		
		$numXfers:=Records in selection:C76([Finished_Goods_Transactions:33])
		If ($numXfers>0)
			ARRAY TEXT:C222($aCPN; 0)
			ARRAY TEXT:C222($aCust; 0)
			ARRAY LONGINT:C221($aQty; 0)  //not used here
			ARRAY TEXT:C222($aXtype; 0)
			ARRAY LONGINT:C221($aNetChg; 0)
			ARRAY TEXT:C222($aJIC_CPN; 0)
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ProductCode:1; $aCPN; [Finished_Goods_Transactions:33]CustID:12; $aCust; [Finished_Goods_Transactions:33]Qty:6; $aQty; [Finished_Goods_Transactions:33]XactionType:2; $aXtype)
			REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
			ARRAY LONGINT:C221($aNetChg; $numXfers)
			ARRAY TEXT:C222($aJIC_CPN; $numXfers)
			SORT ARRAY:C229($aCPN; $aQty; $aXtype; >)
			//build a sort key for the arrays
			$lastCPN:=""
			$uniqueCPNs:=0
			For ($i; 1; $numXfers)
				If (($aCust{$i}+":"+$aCPN{$i})#$lastCPN)  //take out a new slot
					$uniqueCPNs:=$uniqueCPNs+1
					$aJIC_CPN{$uniqueCPNs}:=$aCust{$i}+":"+$aCPN{$i}
					$lastCPN:=$aJIC_CPN{$uniqueCPNs}
				End if 
				
				Case of 
					: ($aXtype{$i}="Receipt")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}+$aQty{$i}
						
					: ($aXtype{$i}="Ship")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}-$aQty{$i}
						
					: ($aXtype{$i}="Return")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}+$aQty{$i}
						
					: ($aXtype{$i}="Scrap")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}-$aQty{$i}
						
					: ($aXtype{$i}="RevShip")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}+$aQty{$i}
						
					: ($aXtype{$i}="B&H@")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}-$aQty{$i}
						
					: ($aXtype{$i}="Adjust")
						$aNetChg{$uniqueCPNs}:=$aNetChg{$uniqueCPNs}+$aQty{$i}
				End case 
				
			End for 
			
			ARRAY TEXT:C222($aCPN; 0)
			ARRAY LONGINT:C221($aQty; 0)
			ARRAY TEXT:C222($aXtype; 0)
			
			For ($i; 1; $uniqueCPNs)
				If (Length:C16($cpnsConsidered)<31000)
					$cpnsConsidered:=$cpnsConsidered+$aJIC_CPN{$i}+Char:C90(9)+String:C10($aNetChg{$i})+Char:C90(13)
				End if 
				
				$numJIC:=qryJIC(""; $aJIC_CPN{$i})
				If ($numJIC>0)
					If ($aNetChg{$i}>0)  //increasing inventory
						ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; <)  //start with latest
						For ($j; 1; $numJIC)
							If ($aNetChg{$i}>0)
								$allowable:=[Job_Forms_Items_Costs:92]AllocatedQuantity:14-[Job_Forms_Items_Costs:92]RemainingQuantity:15
								If ($allowable>0)
									$oldValue:=$oldValue+[Job_Forms_Items_Costs:92]RemainingTotal:12
									Case of 
										: ($allowable>=$aNetChg{$i})
											$newValue:=$newValue+JIC_RemainingAddTo([Job_Forms_Items_Costs:92]Jobit:3; $aNetChg{$i})
											$aNetChg{$i}:=0
										: ($allowable<$aNetChg{$i})
											$newValue:=$newValue+JIC_RemainingAddTo([Job_Forms_Items_Costs:92]Jobit:3; $allowable)
											$aNetChg{$i}:=$aNetChg{$i}-$allowable
									End case 
								End if 
							End if 
							NEXT RECORD:C51([Job_Forms_Items_Costs:92])
						End for 
						
					Else   //relieve inventory
						ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; <)  //start with earliest
						For ($j; 1; $numJIC)
							If ($aNetChg{$i}>0)
								If ([Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
									$oldValue:=$oldValue+[Job_Forms_Items_Costs:92]RemainingTotal:12
									Case of 
										: ([Job_Forms_Items_Costs:92]RemainingQuantity:15>=Abs:C99($aNetChg{$i}))
											$newValue:=$newValue+JIC_RemainingAddTo([Job_Forms_Items_Costs:92]Jobit:3; $aNetChg{$i})
											$aNetChg{$i}:=0
										: ([Job_Forms_Items_Costs:92]RemainingQuantity:15<Abs:C99($aNetChg{$i}))
											$aNetChg{$i}:=$aNetChg{$i}+[Job_Forms_Items_Costs:92]RemainingQuantity:15
											$newValue:=$newValue+JIC_RemainingAddTo([Job_Forms_Items_Costs:92]Jobit:3; -[Job_Forms_Items_Costs:92]RemainingQuantity:15)
									End case 
								End if 
							End if 
							NEXT RECORD:C51([Job_Forms_Items_Costs:92])
						End for 
					End if 
					
				End if 
			End for 
			
			FLUSH CACHE:C297
			$dollarChg:=$newValue-$oldValue
			QM_Sender("FIFONetChg $"+String:C10($dollarChg); ""; $cpnsConsidered; distributionList)
			//ALERT("Net $ Change: "+String($dollarChg))
		End if 
		
		$err:=Batch_RunDate("Set"; "JIC_NetChg"; ->dDateEnd; ->iEndAt)  //set the date for next time
	End if 
End if 