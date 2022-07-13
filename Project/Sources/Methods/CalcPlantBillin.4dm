//%attributes = {"publishedWeb":true}
//Procedure: CalcPlantBillin(from;to;»4 element result array)  120397  MLB
//calculate the billings and their cost for a time period and save to an array
//first, get all the billings by job for the month
//next, get the actual costs for these jobs
//then, find the cost allocation factor for each MachineTicket
//finally, tally the results by plant
//•011298  MLB  UPR 1914

C_LONGINT:C283($i; $numRecs; $0)
C_DATE:C307($1; $2; $dateFrom; $dateTo)
C_TEXT:C284($cr)

$cr:=Char:C90(13)

If (Count parameters:C259=2)
	$dateFrom:=$1
	$dateTo:=$2
	
	//*Calculate Billings by Plant
	//*   Query Shippments to get billing totals
	READ ONLY:C145([Finished_Goods_Transactions:33])
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)  //10/11/94 upr 1269
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=$dateFrom; *)
	//SEARCH([FG_Transactions]; & [FG_Transactions]JobForm=("763@");*)  `••••••
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=$dateTo)
	
	ARRAY TEXT:C222($aFGXtype; 0)
	ARRAY TEXT:C222($aFGXjf; 0)
	ARRAY REAL:C219($aFGXvalue; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionType:2; $aFGXtype; [Finished_Goods_Transactions:33]JobForm:5; $aFGXjf; [Finished_Goods_Transactions:33]ExtendedPrice:20; $aFGXvalue)
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	//*   Roll-up billings by job
	$numRecs:=Size of array:C274($aFGXtype)
	Job_Form("init"; "0")
	Job_Form("init"; String:C10($numRecs))
	CREATE EMPTY SET:C140([Job_Forms_Machine_Tickets:61]; "allJobs")  //gather all machine tickets as you go
	
	For ($i; 1; $numRecs)
		If (Position:C15(".sb"; $aFGXjf{$i})=0)  //skip the special billings
			If ($aFGXtype{$i}#"Ship")
				$aFGXvalue{$i}:=$aFGXvalue{$i}*-1
			End if 
			Job_Form("Bill"; $aFGXjf{$i}; $aFGXvalue{$i})  //accum the revenue and gather mach ticks if first time
		End if 
	End for 
	ARRAY TEXT:C222($aFGXtype; 0)  //clear
	ARRAY TEXT:C222($aFGXjf; 0)  //clear
	ARRAY REAL:C219($aFGXvalue; 0)  //clear
	Job_Form("pack")
	Job_Form("sort")
	$0:=Size of array:C274(aJob)
	
Else 
	$0:=-3
End if 