//%attributes = {"publishedWeb":true}
//Procedure: rptWIPfgXfer(($jobForm;»resultArray)  091098  MLB
//calc the cost transfered out of wip
//•121498  Systems G3  make sensitive to date range of report
// Modified by: MelvinBohince (4/6/22) chg to CSV

C_TEXT:C284($t; $cr)

$t:=","  ///Char(9)
$cr:=Char:C90(13)

READ ONLY:C145([Finished_Goods_Transactions:33])

//Get WIP relief
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$1; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
	
	If (Count parameters:C259>2)  //•121498  Systems G3  make sensitive to date range of report
		If ($3#!00-00-00!)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=$3)
		End if 
	End if 
	
Else 
	
	
	If (Count parameters:C259>2)  //•121498  Systems G3  make sensitive to date range of report
		If ($3#!00-00-00!)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=$3; *)
		End if 
	End if 
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$1; *)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
	
End if   // END 4D Professional Services : January 2019 query selection

ARRAY REAL:C219($2->; 0)
ARRAY REAL:C219($2->; 3)
ARRAY TEXT:C222($aJF; 0)
ARRAY INTEGER:C220($aItem; 0)
ARRAY LONGINT:C221($arQtyAct; 0)
ARRAY DATE:C224($aDate; 0)
SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]JobForm:5; $aJF; [Finished_Goods_Transactions:33]JobFormItem:30; $aItem; [Finished_Goods_Transactions:33]Qty:6; $arQtyAct; [Finished_Goods_Transactions:33]XactionDate:3; $aDate)
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
SORT ARRAY:C229($aDate; $aJF; $aItem; $arQtyAct; >)

$prodValue:=0
$priorFG:=0
$toFG:=0

For ($k; 1; Size of array:C274($arQtyAct))
	$hit:=Find in array:C230(aJobIt; ($aJF{$k}+"."+String:C10($aItem{$k}; "00")))
	If ($hit>-1)
		$perM:=aStdCost{$hit}
		// $wantQty:=$aQtyWant{$hit}
	Else 
		$perM:=0
		// $wantQty:=0
	End if 
	
	//$prodQty:=$prodQty+$arQtyAct{$k}
	$prodValue:=$prodValue+($arQtyAct{$k}/1000*$perM)
	If ($aDate{$k}<beginDate)
		//$priorFGqty:=$priorFGqty+$arQtyAct{$k}
		$priorFG:=$priorFG+($arQtyAct{$k}/1000*$perM)
	Else 
		//$toFGqty:=$toFGqty+$arQtyAct{$k}
		$toFG:=$toFG+($arQtyAct{$k}/1000*$perM)
	End if 
End for 

$2->{1}:=$prodValue
$2->{2}:=$priorFG
$2->{3}:=$toFG

ARRAY TEXT:C222($aJF; 0)
ARRAY INTEGER:C220($aItem; 0)
ARRAY LONGINT:C221($arQtyAct; 0)
ARRAY DATE:C224($aDate; 0)