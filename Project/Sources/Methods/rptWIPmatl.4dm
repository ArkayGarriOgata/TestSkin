//%attributes = {"publishedWeb":true}
//Procedure: rptWIPmatl($jobForm;»resultArray)  091098  MLB
//get the material usage for a jobform
//•121598  Systems G3  UPR mke date sensitive
//•051799  mlb  chg BB from <=beginDate to <beginDate
// • mel (5/12/05, 10:14:39) summarize budgeted materials
// Modified by: MelvinBohince (4/6/22) chg to CSV

C_TEXT:C284($1)  //jobform
C_TEXT:C284($t; $cr)
C_DATE:C307($3)  //end date optional`•121598  Systems G3  UPR mke date sensitive
ARRAY REAL:C219($2->; 0)
ARRAY REAL:C219($2->; 3)

READ ONLY:C145([Raw_Materials_Transactions:23])

$t:=","  ///Char(9)
$cr:=Char:C90(13)

If (prnCostCard)
	rCostCardAppend(rCostCardHdrs(5))
End if 
//*Get the Issues
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=$1)
	//SORT SELECTION([RM_XFER];[RM_XFER]XferDate;>)
	//
	If (Count parameters:C259>2)  //•121598  Systems G3  UPR mke date sensitive
		If ($3#!00-00-00!)
			QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3<=$3)
		End if 
	End if 
	
Else 
	
	
	If (Count parameters:C259>2)  //•121598  Systems G3  UPR mke date sensitive
		If ($3#!00-00-00!)
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3<=$3; *)
		End if 
	End if 
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$1)
	
End if   // END 4D Professional Services : January 2019 query selection

READ ONLY:C145([Job_Forms_Materials:55])
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1)
SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $budCom; [Job_Forms_Materials:55]Planned_Qty:6; $budQty; [Job_Forms_Materials:55]Planned_Cost:8; $budCost)
SORT ARRAY:C229($budCom; $budQty; $budCost; >)
$numBud:=Size of array:C274($budCom)
ARRAY TEXT:C222($aBudCom; $numBud)
ARRAY REAL:C219($aBudQty; $numBud)
ARRAY REAL:C219($aBudCost; $numBud)
For ($seq; 1; $numBud)  //init the arrays
	$aBudCom{$seq}:=""
	$aBudQty{$seq}:=0
	$aBudCost{$seq}:=0
End for 

$cursor:=0
$totBudMatl:=0
For ($seq; 1; $numBud)
	$hit:=Find in array:C230($aBudCom; $budCom{$seq})
	If ($hit=-1)
		$cursor:=$cursor+1
		$hit:=$cursor
		$aBudCom{$hit}:=$budCom{$seq}
	End if 
	$aBudQty{$hit}:=$aBudQty{$hit}+$budQty{$seq}
	$aBudCost{$hit}:=$aBudCost{$hit}+$budCost{$seq}
	$totBudMatl:=$totBudMatl+$budCost{$seq}
End for 
If ($cursor>=Size of array:C274($aBudCom))
	$cursor:=Size of array:C274($aBudCom)+1
	ARRAY TEXT:C222($aBudCom; $cursor)
	ARRAY REAL:C219($aBudQty; $cursor)
	ARRAY REAL:C219($aBudCost; $cursor)
End if 

$aBudCom{$cursor}:="TOTAL MATL BUD"
$aBudQty{$cursor}:=0
$aBudCost{$cursor}:=$totBudMatl

ARRAY DATE:C224($aDate; 0)
ARRAY REAL:C219($aMatl; 0)
ARRAY REAL:C219($issQty; 0)
ARRAY TEXT:C222($aRM; 0)
ARRAY TEXT:C222($aComm; 0)
$ccMatl:=0
$beginBal:=0
$matl:=0
SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate; [Raw_Materials_Transactions:23]ActExtCost:10; $aMatl; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; $aRM; [Raw_Materials_Transactions:23]Qty:6; $issQty; [Raw_Materials_Transactions:23]Commodity_Key:22; $aComm)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
If (Size of array:C274($aDate)>0)
	SORT ARRAY:C229($aDate; $aMatl; $aRM; $issQty; $aComm; >)
	firstMatl:=$aDate{1}
End if 
SORT ARRAY:C229($aComm; $aDate; $aMatl; $aRM; $issQty; >)

For ($k; 1; Size of array:C274($aDate))
	$ccMatl:=$ccMatl+($aMatl{$k}*-1)
	If ($aDate{$k}<beginDate)
		$beginBal:=$beginBal+($aMatl{$k}*-1)
	Else 
		$matl:=$matl+($aMatl{$k}*-1)
	End if 
	If (prnCostCard)
		rCostCardAppend(String:C10($aDate{$k}; <>MIDDATE)+$t+txt_quote($aComm{$k})+$t+$aRM{$k}+$t+String:C10(-1*$issQty{$k})+$t+String:C10(-1*$aMatl{$k})+$t+$t)
		If ($k<=Size of array:C274($aBudCom))
			If (Length:C16($aBudCom{$k})>0)
				rCostCardAppend(txt_quote($aBudCom{$k})+$t+String:C10($aBudQty{$k})+$t+String:C10($aBudCost{$k})+$cr)
			Else 
				rCostCardAppend($cr)
			End if 
		Else 
			rCostCardAppend($cr)
		End if 
	End if 
End for 

$2->{1}:=$ccMatl
$2->{2}:=$beginBal
$2->{3}:=$matl
ARRAY REAL:C219($aMatl; 0)
ARRAY DATE:C224($aDate; 0)
ARRAY REAL:C219($issQty; 0)
ARRAY TEXT:C222($aRM; 0)
ARRAY TEXT:C222($aComm; 0)