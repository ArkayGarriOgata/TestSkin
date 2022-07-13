//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/16/12, 09:56:38
// ----------------------------------------------------
// Method: Rama_Load_Inventory
// Description
// fill the arrays that are in the listbox of [FGL]SimpleInventory; the state column is
//     used to control the UI buttons so that wip can be converted to fg
// ----------------------------------------------------
// Modified by: Mel Bohince (6/27/13) annotate Sleeves in the Status column so they can be converted (tagged) by Rama, or not

C_LONGINT:C283($bin; $numBin)
ARRAY LONGINT:C221(aRecNo; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY TEXT:C222(aBin; 0)
ARRAY LONGINT:C221(aQtyOnHand; 0)
ARRAY TEXT:C222(aPallet; 0)
ARRAY TEXT:C222(aState; 0)
ARRAY LONGINT:C221(aPicked; 0)
ARRAY DATE:C224(aDateOfMfg; 0)
ARRAY TEXT:C222(aJobit; 0)

SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]; aRecNo; [Finished_Goods_Locations:35]ProductCode:1; aCPN; [Finished_Goods_Locations:35]Location:2; aBin; [Finished_Goods_Locations:35]QtyOH:9; aQtyOnHand; [Finished_Goods_Locations:35]skid_number:43; aPallet; [Finished_Goods_Locations:35]Jobit:33; aJobit; [Finished_Goods_Locations:35]OrigDate:27; aDateOfMfg)
$numBin:=Size of array:C274(aRecNo)
ARRAY TEXT:C222(aState; $numBin)
ARRAY LONGINT:C221(aPicked; $numBin)
//ARRAY DATE(aDateOfMfg;$numBin)

For ($bin; 1; $numBin)
	Case of 
			//: (Position("FG:AV-";aBin{$bin})>0)
			//aState{$bin}:="Transit"
			
		: (aQtyOnHand{$bin}<=0)
			aState{$bin}:="EMPTY"
			
		: ((Find in array:C230(<>aSleeves; aCPN{$bin}))>-1)  // Modified by: Mel Bohince (6/27/13) if its a sleeve, see Rama_Find_CPNs
			aState{$bin}:="SLEEVE"
			
		: (Position:C15("808292"; aPallet{$bin})=0)  //not an sscc
			aState{$bin}:="CASE"
			
		: (Substring:C12(aPallet{$bin}; 1; 3)="000")  //wip
			aState{$bin}:="GAYLORD"
			
		: (Substring:C12(aPallet{$bin}; 1; 3)="001")  //wip
			aState{$bin}:="PALLET"
			
		Else 
			aState{$bin}:="UNKNOWN"
	End case 
	
	//aDateOfMfg{$bin}:=JMI_getGlueDate (aJobit{$bin};"*")
	
End for 