//%attributes = {}
// -------
// Method: PF_JobFormItem   ( ) ->
// By: Mel Bohince @ 09/05/17, 11:55:10
// Description
// return a complete task node
// ----------------------------------------------------

// -------
// based on: PF_JobFormTask   ( ) ->
// By: Mel Bohince @ 09/01/17, 11:49:57
// Description

// ----------------------------------------------------
// <Task Action="Create" Code="2" Description="Press" CostCenterCode="210" SetupMinutes="20" RunMinutes="120" Status="Available"
//<Task Action="Create"Code="1"Description="Files In"CostCenterCode="100"RunMinutes="60"Status="Complete"TaskNote="strTaskNote"ProblemDescription=
//          "strProblemDescription"TodoAction="strTaskTodoAction"ActionSender="strTaskActionSender"LockedBy="strTaskLockedBy"AssignedTo="strTaskAssignedTo">
//  <Properties>
//    <Property Name="Task character Property"Value="Task Value"/>
//    <Property Name="Task integer Property"Value="10"/>
//  </Properties>
//</Task>
// Modified by: Mel Bohince (3/19/18) eliminate subform reference as it is meaningless in datacollection

READ ONLY:C145([Cost_Centers:27])
READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
// Modified by: Mel Bohince (3/19/18) 
C_LONGINT:C283($hit; $numItems)
ARRAY TEXT:C222($aJobit; 0)
ARRAY TEXT:C222($aItemNum; 0)
ARRAY LONGINT:C221($aQtyYield; 0)
ARRAY LONGINT:C221($aQtyActual; 0)
ARRAY LONGINT:C221($aQtyWant; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aCustID; 0)
ARRAY TEXT:C222($aOutline; 0)
ARRAY TEXT:C222($aStyle; 0)
ARRAY DATE:C224($aHRD; 0)
ARRAY BOOLEAN:C223($aCases; 0)
ARRAY TEXT:C222($aSeparated; 0)

$ttlMR:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
$ttlRun:=[Job_Forms_Machines:43]Planned_RunHrs:37
$ttlQty:=[Job_Forms_Machines:43]Planned_Qty:10

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Machines:43]JobForm:1)
DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $aJobit)
$numItems:=Size of array:C274($aJobit)
ARRAY TEXT:C222($aItemNum; $numItems)
ARRAY LONGINT:C221($aQtyYield; $numItems)
ARRAY LONGINT:C221($aQtyActual; $numItems)
ARRAY LONGINT:C221($aQtyWant; $numItems)
ARRAY TEXT:C222($aCPN; $numItems)
ARRAY TEXT:C222($aCustID; $numItems)
ARRAY TEXT:C222($aOutline; $numItems)
ARRAY TEXT:C222($aStyle; $numItems)
ARRAY DATE:C224($aHRD; $numItems)
ARRAY BOOLEAN:C223($aCases; $numItems)
ARRAY TEXT:C222($aSeparated; $numItems)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	While (Not:C34(End selection:C36([Job_Forms_Items:44])))
		$hit:=Find in array:C230($aJobit; [Job_Forms_Items:44]Jobit:4)
		If ($hit>-1)  //how could it not?
			$aItemNum{$hit}:=String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
			$aCPN{$hit}:=[Job_Forms_Items:44]ProductCode:3
			$aCustID{$hit}:=[Job_Forms_Items:44]CustId:15
			$aOutline{$hit}:=[Job_Forms_Items:44]OutlineNumber:43
			If (Length:C16([Job_Forms_Items:44]GlueStyle:51)>0)
				$aStyle{$hit}:=[Job_Forms_Items:44]GlueStyle:51
			Else 
				$aStyle{$hit}:=FG_getStyle([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
			End if 
			If ([Job_Forms_Items:44]MAD:37#!00-00-00!)
				$aHRD{$hit}:=[Job_Forms_Items:44]MAD:37
			End if 
			$aQtyYield{$hit}:=$aQtyYield{$hit}+[Job_Forms_Items:44]Qty_Yield:9
			$aQtyActual{$hit}:=$aQtyActual{$hit}+[Job_Forms_Items:44]Qty_Actual:11
			$aQtyWant{$hit}:=$aQtyWant{$hit}+[Job_Forms_Items:44]Qty_Want:24
			$aCases{$hit}:=[Job_Forms_Items:44]Cases:44
			$aSeparated{$hit}:=[Job_Forms_Items:44]Separate:49
		Else 
			BEEP:C151
		End if 
		
		NEXT RECORD:C51([Job_Forms_Items:44])
	End while 
	
Else 
	
	ARRAY TEXT:C222($_Jobit; 0)
	ARRAY LONGINT:C221($_ItemNumber; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY TEXT:C222($_CustId; 0)
	ARRAY TEXT:C222($_OutlineNumber; 0)
	ARRAY DATE:C224($_MAD; 0)
	ARRAY LONGINT:C221($_Qty_Yield; 0)
	ARRAY LONGINT:C221($_Qty_Actual; 0)
	ARRAY LONGINT:C221($_Qty_Want; 0)
	ARRAY BOOLEAN:C223($_Cases; 0)
	ARRAY TEXT:C222($_Separate; 0)
	ARRAY TEXT:C222($_GlueStyle; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; [Job_Forms_Items:44]ItemNumber:7; $_ItemNumber; [Job_Forms_Items:44]ProductCode:3; $_ProductCode; [Job_Forms_Items:44]CustId:15; $_CustId; [Job_Forms_Items:44]OutlineNumber:43; $_OutlineNumber; [Job_Forms_Items:44]MAD:37; $_MAD; [Job_Forms_Items:44]Qty_Yield:9; $_Qty_Yield; [Job_Forms_Items:44]Qty_Actual:11; $_Qty_Actual; [Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; [Job_Forms_Items:44]Cases:44; $_Cases; [Job_Forms_Items:44]Separate:49; $_Separate; [Job_Forms_Items:44]GlueStyle:51; $_GlueStyle)
	
	For ($Iter; 1; Size of array:C274($_Separate); 1)
		$hit:=Find in array:C230($aJobit; $_Jobit{$Iter})
		If ($hit>-1)  //how could it not?
			$aItemNum{$hit}:=String:C10($_ItemNumber{$Iter}; "00")
			$aCPN{$hit}:=$_ProductCode{$Iter}
			$aCustID{$hit}:=$_CustId{$Iter}
			$aOutline{$hit}:=$_OutlineNumber{$Iter}
			If (Length:C16($_GlueStyle{$Iter})>0)
				$aStyle{$hit}:=$_GlueStyle{$Iter}
			Else 
				$aStyle{$hit}:=FG_getStyle($_CustId{$Iter}; $_ProductCode{$Iter})
			End if 
			If ($_MAD{$Iter}#!00-00-00!)
				$aHRD{$hit}:=$_MAD{$Iter}
			End if 
			$aQtyYield{$hit}:=$aQtyYield{$hit}+$_Qty_Yield{$Iter}
			$aQtyActual{$hit}:=$aQtyActual{$hit}+$_Qty_Actual{$Iter}
			$aQtyWant{$hit}:=$aQtyWant{$hit}+$_Qty_Want{$Iter}
			$aCases{$hit}:=$_Cases{$Iter}
			$aSeparated{$hit}:=$_Separate{$Iter}
		Else 
			BEEP:C151
		End if 
		
	End for 
End if   // END 4D Professional Services : January 2019 query selection

// Modified by: Mel Bohince (3/19/18) change to arrays above
//QUERY([Job_Forms_Items];[Job_Forms_Items]JobForm=[Job_Forms_Machines]JobForm)
//ORDER BY([Job_Forms_Items];[Job_Forms_Items]ItemNumber;>)

For ($hit; 1; $numItems)  //$aJobit
	C_TEXT:C284($formref; $1)
	$formref:=$1
	C_BOOLEAN:C305($sendProperties)
	$sendProperties:=$2
	
	$jobformSeqItem:=Substring:C12([Job_Forms_Machines:43]JobSequence:8; 10)+"."+$aItemNum{$hit}  //+"."+String([Job_Forms_Items]SubFormNumber;"0")
	APPEND TO ARRAY:C911(aTaskChain; $jobformSeqItem)
	
	$allocPct:=$aQtyYield{$hit}/$ttlQty  //[Job_Forms_Items]Qty_Yield
	
	$taskref:=DOM Append XML child node:C1080($formref; XML ELEMENT:K45:20; "<Task></Task>")
	
	ARRAY TEXT:C222($AttrName; 0)
	ARRAY TEXT:C222($AttrVal; 0)
	
	APPEND TO ARRAY:C911($AttrName; "Code")
	APPEND TO ARRAY:C911($AttrVal; $jobformSeqItem)
	
	
	APPEND TO ARRAY:C911($AttrName; "Action")
	APPEND TO ARRAY:C911($AttrVal; "Create")
	
	APPEND TO ARRAY:C911($AttrName; "Description")
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Job_Forms_Machines:43]CostCenterID:4)
	APPEND TO ARRAY:C911($AttrVal; Substring:C12([Cost_Centers:27]cc_Group:2; 4))
	
	APPEND TO ARRAY:C911($AttrName; "CostCenterCode")
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Job_Forms_Machines:43]CostCenterID:4)
	APPEND TO ARRAY:C911($AttrVal; String:C10(Num:C11(Substring:C12([Cost_Centers:27]cc_Group:2; 1; 2)); "000"))  //[Job_Forms_Machines]CostCenterID)
	
	APPEND TO ARRAY:C911($AttrName; "PlannedTotalQuantity")  // Modified by: Mel Bohince (11/9/17) 
	APPEND TO ARRAY:C911($AttrVal; String:C10($aQtyWant{$hit}))  //+[Job_Forms_Machines]Planned_Waste
	
	APPEND TO ARRAY:C911($AttrName; "Status")
	If ($aQtyActual{$hit}>0) & ($aQtyWant{$hit}>0)
		APPEND TO ARRAY:C911($AttrVal; String:C10(Round:C94($aQtyActual{$hit}/$aQtyWant{$hit}*100; 0))+"%")
	Else 
		APPEND TO ARRAY:C911($AttrVal; "Waiting")
	End if 
	
	$mr:=Round:C94(($allocPct*[Job_Forms_Machines:43]Planned_MR_Hrs:15)*60; 0)
	
	APPEND TO ARRAY:C911($AttrName; "RunMinutes")
	$run:=Round:C94(($allocPct*[Job_Forms_Machines:43]Planned_RunHrs:37)*60; 0)+$mr
	APPEND TO ARRAY:C911($AttrVal; String:C10($run))
	
	DOM SET XML ATTRIBUTE:C866($taskref; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2}; $AttrName{3}; $AttrVal{3}; $AttrName{4}; $AttrVal{4}; $AttrName{5}; $AttrVal{5}; $AttrName{6}; $AttrVal{6}; $AttrName{7}; $AttrVal{7})  //;$AttrName{8};$AttrVal{8})  //;$AttrName{9};$AttrVal{9})
	
	If ($sendProperties)
		$propref:=DOM Append XML child node:C1080($taskref; XML ELEMENT:K45:20; "<Properties></Properties>")
		//PROPERTIES:
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$aOutline{$hit})
		PF_AddProperty($propref; "item-dimensions"; [Finished_Goods_SizeAndStyles:132]Dim_A:17+" x "+[Finished_Goods_SizeAndStyles:132]Dim_B:18+" x "+[Finished_Goods_SizeAndStyles:132]Dim_Ht:19)
		PF_AddProperty($propref; "item-HRD"; PF_util_FormatDate(->$aHRD{$hit}))
		PF_AddProperty($propref; "item-Jobit"; $aJobit{$hit})
		PF_AddProperty($propref; "item-outline"; $aOutline{$hit})
		PF_AddProperty($propref; "item-ProductCode"; $aCPN{$hit})
		PF_AddProperty($propref; "item-style"; $aStyle{$hit})
		PF_AddProperty($propref; "item-want-qty"; String:C10($aQtyWant{$hit}))
		//RESOURCES:
		PF_AddProperty($propref; "Cases"; PF_BooleanToYesNo($aCases{$hit}))
		PF_AddProperty($propref; "Die Cut"; PF_DateToYesNo([Job_Forms_Master_Schedule:67]GlueReady:28))
		PF_AddProperty($propref; "Separated"; $aSeparated{$hit})
	End if 
	
End for 

