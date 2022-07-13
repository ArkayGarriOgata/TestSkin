//%attributes = {}
//Method:  RM_ColdFoilFill(tPhase{;nTabNumber})
//Description:  This method will handle the cold foil listbox

If (True:C214)  //Intitialize
	
	C_TEXT:C284($1; $tPhase)
	C_LONGINT:C283($2; $nTabNumber)
	
	C_LONGINT:C283($nItemRef)
	C_LONGINT:C283($nCommodityCode)
	
	C_TEXT:C284($tItemText)
	C_LONGINT:C283($nSequence)
	C_TEXT:C284($tXter_Type)
	
	C_OBJECT:C1216(esRawMaterialsTransactions)  //Properties of ListBox
	C_OBJECT:C1216(eRawMatlTrns)
	C_LONGINT:C283(nRawMatlTrns)
	C_OBJECT:C1216(eRawMatlTrnsSlct)
	
	$tPhase:=$1
	
	$nTabNumber:=Selected list items:C379(ieBagTabs)
	
	If (Count parameters:C259>=2)
		$nTabNumber:=$2
	End if 
	
	GET LIST ITEM:C378(ieBagTabs; $nTabNumber; $nItemRef; $tItemText)
	$nSequence:=Num:C11(Substring:C12($tItemText; 1; 3))
	
	$nCommodityCode:=9  //9
	$tXter_Type:="Issue"  //"Issue"
	
	esRawMaterialsTransactions:=New object:C1471()
	eRawMatlTrns:=New object:C1471()
	nRawMatlTrns:=0
	eRawMatlTrnsSlct:=New object:C1471()
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseClear)
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		esRawMaterialsTransactions:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Sequence = :2 and CommodityCode = :3 and Xfer_Type = :4"; sCriterion1; $nSequence; $nCommodityCode; $tXter_Type)
		
End case   //Done phase
