//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/14/18, 10:06:31
// ----------------------------------------------------
// Method: eBag_selectSubform_SFO
// Description
// see also 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($sfNum)
C_LONGINT:C283($1; $2; $sf)  //subform number and sequence

zwStatusMsg("clicked"; "sf: "+String:C10($1)+" seq: "+String:C10($2))
$sf:=$1

For ($i; 1; Size of array:C274(aJFM_seq))
	aJFM_Hidden{$i}:=True:C214
	If (aJFM_seq{$i}=$2)
		
		If (Position:C15(","; aJFM_SF{$i})=0)  //only one subform
			If ($sf=Num:C11(aJFM_SF{$i}))
				aJFM_Hidden{$i}:=False:C215
			End if 
			
		Else   //used on many subforms
			$sfNum:=String:C10($1)
			
			$elements:=util_TextParser(10; aJFM_SF{$i}; Character code:C91(","); 13)
			If (Find in array:C230(aParseArray; $sfNum)>0)
				aJFM_Hidden{$i}:=False:C215
			End if 
			//If (Position($sfNum;aJFM_SF{$i})>0)
			//aJFM_Hidden{$i}:=False
			//End if 
		End if 
	End if 
End for 



For ($i; 1; Size of array:C274(aJMI_item))
	aJMI_Hidden{$i}:=True:C214
	If ($1=aJMI_SF{$i})
		aJMI_Hidden{$i}:=False:C215
	End if 
End for 