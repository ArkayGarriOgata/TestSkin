//%attributes = {"publishedWeb":true}
//Method: Batch_SnapShotInventory()  022499  MLB
//capture the current FG inventory balance and summarize the transactions since
//the last running of this method
//decided not to do it all in ram since selection may get large and this 
//should only run once a month
//•030399  MLB  change behavior on initial running to only get bin info
//•5/07/99  MLB  UPR 2032 adjustments are wrong, picking up BH's
//•072099  mlb  UPR 2056 improper xaction sets
// • mel (6/6/05, 11:06:06) exclude b&h in scraps

C_DATE:C307(dDateBegin; dDateEnd)
C_TIME:C306(tTimeBegin; tTimeEnd)
C_LONGINT:C283(iBeginAt; iEndAt; $numJMI; $hit; $i; $err; $numFound)
C_BOOLEAN:C305($continue)

READ WRITE:C146([Finished_Goods_Inv_Summaries:64])

$continue:=False:C215

//*Determine date to assign to this invocation
iEndAt:=TSTimeStamp
//dDateEnd:=TS2Date (iEndAt)
TS2DateTime(iEndAt; ->dDateEnd; ->tTimeEnd)  //•110899  mlb get time boundary on upside

//*Determine the date of the last run,
$err:=Batch_RunDate("Get"; "SnapShot"; ->dDateBegin; ->iBeginAt)
If ($err=0)
	$continue:=True:C214
	If (iBeginAt=0)  //if can not determine, go with the end date, therefore no transacitons
		iBeginAt:=iEndAt
	End if 
	TS2DateTime(iBeginAt; ->dDateBegin; ->tTimeBegin)
End if 

If ($continue)
	$err:=Batch_RunDate("Set"; "SnapShot"; ->dDateEnd; ->iEndAt)  //set the date for next time
	If ($err=0)
		//*Gather the current inventory balances and store them
		READ ONLY:C145([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")  //exclude the bill and holds
		
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)  //load the table into memory, consolidate by jobit
			//uRelateSelect (»[JobMakesItem]JobForm;»[FG_Locations]JobForm)
			//SELECTION TO ARRAY()
			ARRAY TEXT:C222($aCPN; 0)
			ARRAY LONGINT:C221($aQty; 0)
			ARRAY TEXT:C222($aCust; 0)
			ARRAY TEXT:C222($aJF; 0)
			ARRAY INTEGER:C220($aItem; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]JobForm:19; $aJF; [Finished_Goods_Locations:35]JobFormItem:32; $aItem)
			//build a sort key for the arrays
			ARRAY TEXT:C222($aJobit; Size of array:C274($aCPN))
			For ($i; 1; Size of array:C274($aCPN))
				$aJobit{$i}:=$aJF{$i}+"."+String:C10($aItem{$i}; "00")
			End for 
			SORT ARRAY:C229($aJobit; $aCPN; $aQty; $aCust; $aJF; $aItem; >)
			
			REDUCE SELECTION:C351([Finished_Goods_Inv_Summaries:64]; 0)
			$lastJobit:=""
			uThermoInit(Size of array:C274($aCPN); "Consolidating FG Locations")
			For ($i; 1; Size of array:C274($aCPN))  //tally every bin record found by jobit number
				If ($lastJobit#$aJobit{$i})  //create  an new element
					$lastJobit:=$aJobit{$i}
					If (Record number:C243([Finished_Goods_Inv_Summaries:64])=-3)  //save last record
						SAVE RECORD:C53([Finished_Goods_Inv_Summaries:64])
						uThermoUpdate($i)
					End if 
					
					CREATE RECORD:C68([Finished_Goods_Inv_Summaries:64])
					[Finished_Goods_Inv_Summaries:64]FGkey:1:=$aCust{$i}+":"+$aCPN{$i}
					[Finished_Goods_Inv_Summaries:64]Jobit:2:=$aJobit{$i}
					$numFound:=fGetJobCost($aJobit{$i}; "Planned"; ->[Finished_Goods_Inv_Summaries:64]CostMaterial:4; ->[Finished_Goods_Inv_Summaries:64]CostLabor:5; ->[Finished_Goods_Inv_Summaries:64]CostBurden:6)
					[Finished_Goods_Inv_Summaries:64]CostTotal:7:=[Finished_Goods_Inv_Summaries:64]CostMaterial:4+[Finished_Goods_Inv_Summaries:64]CostLabor:5+[Finished_Goods_Inv_Summaries:64]CostBurden:6
					[Finished_Goods_Inv_Summaries:64]DateFrozen:8:=dDateEnd
					[Finished_Goods_Inv_Summaries:64]z_Group:10:="_~BAL"
					[Finished_Goods_Inv_Summaries:64]ColumnName:9:=fYYMMDD([Finished_Goods_Inv_Summaries:64]DateFrozen:8; 4)+[Finished_Goods_Inv_Summaries:64]z_Group:10
					[Finished_Goods_Inv_Summaries:64]ProductCode:11:=$aCPN{$i}
					[Finished_Goods_Inv_Summaries:64]CustID:12:=$aCust{$i}
					[Finished_Goods_Inv_Summaries:64]FrozenAt:13:=iEndAt
				End if   //next jobit
				
				[Finished_Goods_Inv_Summaries:64]Quantity:3:=[Finished_Goods_Inv_Summaries:64]Quantity:3+$aQty{$i}  //accumulate the qty
			End for 
			SAVE RECORD:C53([Finished_Goods_Inv_Summaries:64])  //save last
			uThermoClose
		End if   //some inventory
		
		//*---
		//*Summarize the periods transactions that would supply or relieve inventory
		ARRAY TEXT:C222($aGroup; 3)
		$aGroup{1}:="_IN__"
		$aGroup{2}:="_OUT_"
		$aGroup{3}:="_ADJ_"
		//ARRAY TEXT($aTransType;7)
		//$aTransType{1}:="Scrap"  `-
		//$aTransType{2}:="RevShip"  `+
		//$aTransType{3}:="B&H@"  `-
		//$aTransType{4}:="Return"  `+
		//$aTransType{5}:="Adjust"  `+
		//$aTransType{6}:="Ship"  `-
		//$aTransType{7}:="Receipt"  `+
		//ARRAY LONGINT($aSign;7)
		//$aSign{1}:=-1
		//$aSign{2}:=1
		//$aSign{3}:=-1
		//$aSign{4}:=1
		//$aSign{5}:=1
		//$aSign{6}:=-1
		//$aSign{7}:=1
		
		//Remove the transaction that are obviously not wanted
		//SET QUERY DESTINATION(Into set;"Candidates")`•072099  mlb  UPR 2056 improper xac
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5#"@.sb"; *)  //dont want special billings
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2#"MOVE"; *)  //don't want move transactions
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]JobForm:5#"Price@"; *)  //don't want price changes
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin)  //not the day before
			CREATE SET:C116([Finished_Goods_Transactions:33]; "Candidates")  //•072099  mlb  UPR 2056 improper xaction sets
			//remove the trans prior to last TIME
			//SET QUERY DESTINATION(Into set;"beforeLast")`•072099  mlb  UPR 2056 improper xac
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=dDateBegin; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionTime:13<tTimeBegin)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "beforeLast")  //•072099  mlb  UPR 2056 improper xaction sets
			
			DIFFERENCE:C122("Candidates"; "beforeLast"; "Candidates")
			CLEAR SET:C117("beforeLast")
			
			//•110899  mlb  take care of back dated transactions
			USE SET:C118("Candidates")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=dDateEnd; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionTime:13>tTimeEnd)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "afterNow")
			DIFFERENCE:C122("Candidates"; "afterNow"; "Candidates")
			CLEAR SET:C117("afterNow")
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "Candidates")
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
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
				#\
				(\
				([Finished_Goods_Transactions:33]XactionDate:3=dDateEnd)\
				 & ([Finished_Goods_Transactions:33]XactionTime:13>tTimeEnd)\
				)\
				)
			
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		//SET QUERY DESTINATION(Into current selection)`•072099  mlb  UPR 2056 improper xa
		
		For ($type; 1; Size of array:C274($aGroup))
			USE SET:C118("Candidates")
			//      Query SELECTION([FG_Transactions];[FG_Transactions]XactionType=$aTransTyp
			Case of 
				: (Position:C15("IN"; $aGroup{$type})>0)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
					
				: (Position:C15("ADJ"; $aGroup{$type})>0)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"BH@"; *)  //don't want bill and hold bin adjustments         
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Adjust")
					
				Else 
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap"; *)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="B&H@"; *)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
					QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9#"BH@")  // • mel (6/6/05, 11:15:23) don't show bh scraps
			End case 
			
			If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
				ARRAY TEXT:C222($aCPN; 0)
				ARRAY LONGINT:C221($aQty; 0)  //not used here
				ARRAY TEXT:C222($aCust; 0)
				ARRAY TEXT:C222($aJF; 0)
				ARRAY INTEGER:C220($aItem; 0)
				ARRAY TEXT:C222($aXtype; 0)
				ARRAY TEXT:C222($aReason; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ProductCode:1; $aCPN; [Finished_Goods_Transactions:33]JobForm:5; $aJF; [Finished_Goods_Transactions:33]Qty:6; $aQty; [Finished_Goods_Transactions:33]CustID:12; $aCust; [Finished_Goods_Transactions:33]JobFormItem:30; $aItem; [Finished_Goods_Transactions:33]XactionType:2; $aXtype; [Finished_Goods_Transactions:33]Reason:26; $aReason)
				REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
				//build a sort key for the arrays
				ARRAY TEXT:C222($aJobit; Size of array:C274($aCPN))
				For ($i; 1; Size of array:C274($aCPN))
					$aJobit{$i}:=$aJF{$i}+"."+String:C10($aItem{$i}; "00")
					If ($aReason{$i}="Overshipment")  //these are already counted in the orig shipment
						$aQty{$i}:=0
					End if 
				End for 
				ARRAY TEXT:C222($aReason; 0)
				SORT ARRAY:C229($aJobit; $aCPN; $aQty; $aCust; $aJF; $aItem; $aXtype; >)
				
				REDUCE SELECTION:C351([Finished_Goods_Inv_Summaries:64]; 0)
				$lastJobit:=""
				uThermoInit(Size of array:C274($aCPN); "Consolidating FG "+$aGroup{$type}+" Transactions, "+String:C10($type)+"/"+String:C10(Size of array:C274($aGroup)))
				For ($i; 1; Size of array:C274($aCPN))
					If ($lastJobit#$aJobit{$i})  //create  an new element
						$lastJobit:=$aJobit{$i}
						If (Record number:C243([Finished_Goods_Inv_Summaries:64])=-3)  //save last record
							SAVE RECORD:C53([Finished_Goods_Inv_Summaries:64])
							uThermoUpdate($i)
						End if 
						
						CREATE RECORD:C68([Finished_Goods_Inv_Summaries:64])
						[Finished_Goods_Inv_Summaries:64]FGkey:1:=$aCust{$i}+":"+$aCPN{$i}
						[Finished_Goods_Inv_Summaries:64]Jobit:2:=$aJobit{$i}
						$numFound:=fGetJobCost($aJobit{$i}; "Planned"; ->[Finished_Goods_Inv_Summaries:64]CostMaterial:4; ->[Finished_Goods_Inv_Summaries:64]CostLabor:5; ->[Finished_Goods_Inv_Summaries:64]CostBurden:6)
						[Finished_Goods_Inv_Summaries:64]CostTotal:7:=[Finished_Goods_Inv_Summaries:64]CostMaterial:4+[Finished_Goods_Inv_Summaries:64]CostLabor:5+[Finished_Goods_Inv_Summaries:64]CostBurden:6
						[Finished_Goods_Inv_Summaries:64]DateFrozen:8:=dDateEnd
						//If (Position($aXtype{$i};" Receipt Return RevShip Adjust ")>0)
						//«  `($aSign{$type}>0)
						[Finished_Goods_Inv_Summaries:64]z_Group:10:=$aGroup{$type}  //+$aTransType{$type}
						//Else 
						//[FG_Inventory_Summary]Group:="_OUT_"  `+$aTransType{$type}
						//End if 
						[Finished_Goods_Inv_Summaries:64]ColumnName:9:=fYYMMDD([Finished_Goods_Inv_Summaries:64]DateFrozen:8; 4)+[Finished_Goods_Inv_Summaries:64]z_Group:10
						[Finished_Goods_Inv_Summaries:64]ProductCode:11:=$aCPN{$i}
						[Finished_Goods_Inv_Summaries:64]CustID:12:=$aCust{$i}
						[Finished_Goods_Inv_Summaries:64]FrozenAt:13:=iEndAt
					End if 
					
					[Finished_Goods_Inv_Summaries:64]Quantity:3:=[Finished_Goods_Inv_Summaries:64]Quantity:3+$aQty{$i}  //($aSign{$type}*$aQty{$i})  `accumulate the qty
				End for 
				SAVE RECORD:C53([Finished_Goods_Inv_Summaries:64])  //save last
				uThermoClose
			End if 
		End for 
		
		CLEAR SET:C117("Candidates")
	End if 
End if 