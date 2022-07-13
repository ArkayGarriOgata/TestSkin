//%attributes = {}
// Method: Fifo_CalcItem(cpn;->value;->qty) ->error
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/10/08, 18:19:57
// ----------------------------------------------------
// Description
// calculate the fifo value of a FinishedGood
// See also JIC_Regenerate
// ----------------------------------------------------

If (Count parameters:C259>0)
	$cpn:=$1
Else 
	$cpn:="31KL-01-0114"
End if 

$over_run_allowed:=1  //.1  `allow 10% over want
$error:=0
$value:=0
$qty:=0
$excess:=0
$costedQty:=0
uConfirm("Use GoodQty when available?"; "Good"; "Actual")
If (OK=1)
	$useGood:=True:C214
Else 
	$useGood:=False:C215
End if 
//get the remaining inventory
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$cpn)
//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"BH@")
If (Records in selection:C76([Finished_Goods_Locations:35])>0)
	$qty:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)-iBillAndHoldQty
	//get all the jobs that made this item in the past 9mth, older are not valued anyway
	$nineMths:=Add to date:C393(4D_Current_date; 0; -9; 0)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$cpn; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33>$nineMths)
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aJobits)  //going to roll up qty and set variables
	$numJobits:=Size of array:C274($aJobits)
	ARRAY LONGINT:C221($aQtyCosted; $numJobits)
	ARRAY LONGINT:C221($aQtyExcess; $numJobits)
	ARRAY DATE:C224($aGlued; $numJobits)
	ARRAY REAL:C219($aCost_M; $numJobits)
	
	For ($i; 1; $numJobits)
		If (JMI_TestForValue($aJobits{$i}))  //ignor obsolete or over 9months
			
			If ((qryJMI($aJobits{$i}))>0)
				$aGlued{$i}:=JMI_getGlueDate($aJobits{$i})
				
				//JMI_getCostPerM()
				If ([Job_Forms_Items:44]FormClosed:5)
					$aCost_M{$i}:=[Job_Forms_Items:44]ActCost_M:27
				Else 
					$aCost_M{$i}:=[Job_Forms_Items:44]PldCostTotal:21
				End if 
				
				//JMI_getCostedQty()
				$wantQty:=(Sum:C1([Job_Forms_Items:44]Qty_Want:24))*$over_run_allowed
				If ($useGood)
					$actQty:=Sum:C1([Job_Forms_Items:44]Qty_Good:10)  //use good qty if available
				Else 
					$actQty:=0
				End if 
				If ($actQty=0)
					$actQty:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
				End if 
				
				If ($wantQty<$actQty)  //use lower of want or good
					$aQtyCosted{$i}:=$wantQty
					$aQtyExcess{$i}:=$actQty-$wantQty
					
				Else 
					$aQtyCosted{$i}:=$actQty
					$aQtyExcess{$i}:=0
				End if 
				
			Else 
				$error:=-2
			End if 
		End if 
	End for 
	
	If ($error=0) & (Size of array:C274($aJobits)>0)
		//allocate qty from newest to oldest
		utl_LogIt("init")
		utl_LogIt($cpn+" on-hand= "+String:C10($qty)+" allowing "+String:C10(($over_run_allowed-1)*100)+" % over run per job")
		If (iBillAndHoldQty>0)
			utl_LogIt(" Bill and Hold =  "+String:C10(iBillAndHoldQty))
		End if 
		utl_LogIt("====== ")
		SORT ARRAY:C229($aGlued; $aJobits; $aQtyCosted; $aCost_M; <)
		For ($i; 1; $numJobits)
			utl_LogIt("  "+$aJobits{$i})
			If ($aQtyExcess{$i}<$qty)
				$qty:=$qty-$aQtyExcess{$i}  //skim off the excess
				utl_LogIt("     Remove "+String:C10($aQtyExcess{$i})+" Excess from onhand qty")
			Else 
				$qty:=0
			End if 
			
			If ($qty<=$aQtyCosted{$i})  //this job claims it all
				$costedQty:=$costedQty+$qty
				$value:=$value+($qty*$aCost_M{$i}/1000)
				utl_LogIt("     Cost "+String:C10($qty)+" @ "+String:C10(Round:C94($aCost_M{$i}; 2))+" /M")
				$qty:=0
				
			Else   //partial amount of qty valued at this job level
				$costedQty:=$costedQty+$aQtyCosted{$i}
				$value:=$value+($aQtyCosted{$i}*$aCost_M{$i}/1000)
				$qty:=$qty-$aQtyCosted{$i}
				utl_LogIt("     Cost "+String:C10($aQtyCosted{$i})+" @ "+String:C10(Round:C94($aCost_M{$i}; 2))+" /M")
				//If ($qty<=$aQtyExcess{$i})
				//$qty:=0
				//Else 
				//$qty:=$qty-$aQtyExcess{$i}
				//End if 
			End if 
			utl_LogIt("     Carry "+String:C10($qty)+" to next jobit ")
			utl_LogIt("------ ")
			If ($qty<=0)  //nothing left to value
				$i:=$numJobits+1  //break
			End if 
		End for 
		
		$excess:=$qty
	End if   //no error
	utl_LogIt("Value= "+String:C10(Round:C94($value; 2))+"   Costed Qty= "+String:C10($costedQty))
	utl_LogIt("show")
	//If (Count parameters=3)
	//$2->:=Round($value;2)
	//$3->:=$costedQty
	//End if 
	
Else 
	utl_LogIt("init")
	utl_LogIt($cpn+" on-hand= 0")
	utl_LogIt("====== ")
	utl_LogIt("Value= 0"+"   Costed Qty= 0")
	utl_LogIt("show")
End if 
$0:=$error