//%attributes = {"publishedWeb":true}
//PM: eBag_SetView() ->
//@author mlb - 5/30/02  11:16
//calkiiiiiiiii[led by tab control on diolog
//• mlb - 10/30/02  11:1
// Modified by: Mel Bohince (5/1/19)
// Modified by: Mel Bohince (6/9/21) Use Storage
// Modified by: Mel Bohince (7/23/21) cold foil button visability
// Modified by: Garri Ogata (8/25/21) cold foil listbox visability
// Modified by: Garri Ogata (9/9/21) cold foil listbox tab fill
// Modified by: Garri Ogata (3/9/21) Window use gluers tab

zwStatusMsg("Find Seq"; "Please Wait...")

C_LONGINT:C283($1; $tabNumber; $itemRef; lastTab)
C_TEXT:C284($itemText)
$lastSequenceTab:=Count list items:C380(ieBagTabs)  // Modified by: Mel Bohince (10/12/17)

If (Count parameters:C259=1)
	$tabNumber:=$1
Else 
	$tabNumber:=Selected list items:C379(ieBagTabs)
End if 

If ([Job_Forms:42]JobFormID:5#sCriterion1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sCriterion1)
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
End if 

GET LIST ITEM:C378(ieBagTabs; $tabNumber; $itemRef; $itemText)
If ($itemRef>=0)
	C_TEXT:C284($description; $department)  // Modified by: Mel Bohince (6/9/21) Use Storage
	C_DATE:C307($effective)
	$description:=""
	$department:=""
	$effective:=!00-00-00!
	$cc:=CostCtrCurrent("Desc"; Substring:C12($itemText; 5; 3); ->$description)
	$cc:=CostCtrCurrent("dept"; Substring:C12($itemText; 5; 3); ->$department)
	$cc:=CostCtrCurrent("dated"; Substring:C12($itemText; 5; 3); ->$effective)
	xText:=$description+"             Effectivity: "+String:C10($effective; System date short:K1:1)
	//xText:=aCostCtrDes{$cc}+"             Effectivity: "+String(aCostCtrEff{$cc};System date short)
	sDepartment:=$department  //aCostCtrDept{$cc}
	
	GOTO RECORD:C242([Job_Forms_Machines:43]; $itemRef)
	eBag_SetFlexFields
	USE SET:C118("materials")
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
	ORDER BY FORMULA:C300([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Alpha20_2:21; >; [Job_Forms_Materials:55]Real2:18; >; Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2); >)
	
	USE SET:C118("machinetickets")
	$seq:=Num:C11(Substring:C12($itemText; 1; 3))
	If ($seq>0)
		QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3=$seq)
		If (User in group:C338(Current user:C182; "RoleLineManager")) | (User in group:C338(Current user:C182; "DataCollection"))  // Modified by: Mel Bohince (6/11/14) protect and defend
			OBJECT SET ENABLED:C1123(*; "MachTick@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "MachTick@"; False:C215)
		End if 
		
	Else 
		QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=sCriterion1)
		OBJECT SET ENABLED:C1123(*; "MachTick@"; False:C215)
	End if 
	
	If (<>PHYSICAL_INVENORY_IN_PROGRESS)  // Modified by: Mel Bohince (12/18/19)
		OBJECT SET ENABLED:C1123(*; "MachTick@"; False:C215)
	End if 
	
	ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]P_C:10; <)
	
	If ([Job_Forms:42]Status:6="Closed")
		OBJECT SET ENABLED:C1123(*; "MachTick@"; False:C215)
	End if 
	
	$costcenter:=Substring:C12($itemText; 5; 3)
	OBJECT SET VISIBLE:C603(*; "load_@"; True:C214)  // Modified by: Mel Bohince (5/1/19)
	Case of 
			
		: ((Position:C15($costcenter; <>GLUERS)>0) | (Position:C15($costcenter; "472")>0))  //Modified by: Garri Ogata (Window act like gluers)
			
			//$lastListItem:=Count list items(ieBagTabs)
			FORM GOTO PAGE:C247(3)  //was 3 $tabNumber
			OBJECT SET VISIBLE:C603(*; "load_@"; False:C215)  // Modified by: Mel Bohince (5/1/19)
			SELECT LIST ITEMS BY REFERENCE:C630(ieBagTabs; $itemRef)
			
		: (Position:C15($costcenter; <>SHEETERS)>0)
			FORM GOTO PAGE:C247(4)
			SELECT LIST ITEMS BY REFERENCE:C630(ieBagTabs; $itemRef)
			
		Else 
			If (Size of array:C274(aSubform)>0)
				For ($i; 1; Size of array:C274(aSubform))
					aSubformQty{$i}:=Round:C94(aRatio{$i}*[Job_Forms_Machines:43]Planned_Qty:10; 0)
				End for 
			End if 
			FORM GOTO PAGE:C247(2)
			
			If (Position:C15($costcenter; <>PRESSES)>0)  // Modified by: Mel Bohince (7/23/21)
				OBJECT SET VISIBLE:C603(*; "ColdFoil@"; True:C214)  // Modified by: Garri Ogata (8/25/21)
				$t:=[Job_Forms:42]JobNo:2
				
				RM_ColdFoilFill(CorektPhaseAssignVariable; $tabNumber)  // Modified by: Garri Ogata (9/9/21)
				
			Else 
				OBJECT SET VISIBLE:C603(*; "ColdFoil@"; False:C215)
				RM_ColdFoilFill(CorektPhaseClear)
			End if 
			
			SELECT LIST ITEMS BY REFERENCE:C630(ieBagTabs; $itemRef)
	End case 
	
	$recNum:=Job_ProdHistory("find"; ([Jobs:15]CustID:2+":"+[Job_Forms:42]ProcessSpec:46); sDepartment)
	
	zwStatusMsg("SEQ"; $itemText)
	
Else 
	sDepartment:=$itemText
	JBNSubFormRatio  //reset net qty
	$recNum:=Job_ProdHistory("find"; ([Jobs:15]CustID:2+":"+[Job_Forms:42]ProcessSpec:46); sDepartment)
	FORM GOTO PAGE:C247($itemRef*-1)
	
	OBJECT SET ENABLED:C1123(*; "MachTick@"; False:C215)
	USE SET:C118("machinetickets")
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=sCriterion1)
	ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]P_C:10; <)
	
	zwStatusMsg("INFO"; $itemText)
End if 

lastTab:=$tabNumber