//%attributes = {"publishedWeb":true}
//uGetJobCosts(»real;»real;»real;»real;»real)  
//10/11/94
//12/8/94 use var openDemand set by calling proc to determine value
//here begins the new stuff
//   find the current demand for this item to pass this into the uGetJobCost to 
//    decide if valued or excess
C_POINTER:C301($1; $2; $3; $4; $5; $6; $7; $8; $9; $10)
C_LONGINT:C283($openDemand; $numRecs; $i; $active)
C_REAL:C285($thousand)
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)  //switch to fg_key
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
$numRecs:=qryOpenOrdLines(""; "*")  //•021596  MLB  ks said to ignor closed
ARRAY LONGINT:C221($aOpen; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY REAL:C219($aOR; 0)
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $aOpen; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]OverRun:25; $aOR)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
$openDemand:=0
For ($i; 1; $numRecs)
	$openDemand:=$openDemand+($aOpen{$i}+($aQty{$i}*($aOR{$i}/100)))
End for 
ARRAY LONGINT:C221($aOpen; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY REAL:C219($aOR; 0)

ARRAY TEXT:C222($aJF; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aCust; 0)
SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $aJF; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
SORT ARRAY:C229($aJF; $aCPN; $aCust; $aQty; >)

$numRecs:=Size of array:C274($aJF)
$supply:=0
For ($i; 1; $numRecs)
	$supply:=$supply+$aQty{$i}
End for 

If ($supply>$openDemand)  //is there excess to report?
	$active:=Find in array:C230(aCPN; [Finished_Goods:26]ProductCode:1)
	
	For ($i; 1; $numRecs)
		Case of 
			: ($openDemand>=$aQty{$i})  //all of this bin is valued, leave it alone
				$openDemand:=$openDemand-$aQty{$i}
				
			: ($openDemand<$aQty{$i})  //some of this bin is valued
				$aQty{$i}:=$aQty{$i}-$openDemand  //dump the valued portion
				If (([Job_Forms_Items:44]JobForm:1#$aJF{$i}) | ([Job_Forms_Items:44]ProductCode:3#$aCPN{$i}) | ([Job_Forms_Items:44]CustId:15#$aCust{$i}))
					qryJMI($aJF{$i}; 0; $aCPN{$i})
					t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
				End if 
				$thousand:=$aQty{$i}/1000
				If ($active>-1)
					$1->:=$1->+$aQty{$i}
					$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
					$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
					$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				Else 
					$6->:=$6->+$aQty{$i}
					$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
					$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
					$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				End if 
				$openDemand:=$openDemand-$aQty{$i}
				
			: ($openDemand<=0)  //none of this bin is valued
				If (([Job_Forms_Items:44]JobForm:1#$aJF{$i}) | ([Job_Forms_Items:44]ProductCode:3#$aCPN{$i}) | ([Job_Forms_Items:44]CustId:15#$aCust{$i}))
					qryJMI($aJF{$i}; 0; $aCPN{$i})
					t3a:=t3a+"  "+[Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
				End if 
				$thousand:=$aQty{$i}/1000
				If ($active>-1)
					$1->:=$1->+$aQty{$i}
					$2->:=$2->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
					$3->:=$3->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
					$4->:=$4->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				Else 
					$6->:=$6->+$aQty{$i}
					$7->:=$7->+Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 0)
					$8->:=$8->+Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 0)
					$9->:=$9->+Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 0)
				End if 
				$openDemand:=$openDemand-$aQty{$i}
				
			Else 
				BEEP:C151
				ALERT:C41("Error called by uGetJobCosts, $openDemand test failed.")
		End case 
	End for 
End if   //there is excess

$5->:=$5->+Round:C94($2->+$3->+$4->; 0)

If (Count parameters:C259>5)
	$10->:=$10->+Round:C94($7->+$8->+$9->; 0)
End if 
//