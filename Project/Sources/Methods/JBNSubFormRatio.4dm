//%attributes = {"publishedWeb":true}
//(p) JBNSubformRatio
//see also Job_SubformBreakDown, Est_SubformBreakDown
//calulate the ratio of sheets for a subform
//this is used at the material level to determine how many
//sheets need to exit a cost center for a subform.
//assumes -- needed records are in selection of JMI
//• 2/2/98 cs created
// Modified by: Mel Bohince (10/13/15) re-rite, simplify and verify net sheets of sf are consistent

C_LONGINT:C283($i; $hit)  //$Count;$size;$YieldSum;$NumUpSum)

//calc arrays
ARRAY LONGINT:C221($Yield; 0)
ARRAY LONGINT:C221($NumUp; 0)
ARRAY LONGINT:C221($ItemSubForm; 0)
ARRAY LONGINT:C221($netSheets; 0)

//displayed arrays
ARRAY LONGINT:C221(aSubForm; 0)
ARRAY LONGINT:C221(aSubFormQty; 0)  // set in eBag_SetView when tab control script runs
ARRAY REAL:C219(aRatio; 0)

SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $Yield; [Job_Forms_Items:44]NumberUp:8; $NumUp; [Job_Forms_Items:44]SubFormNumber:32; $ItemSubForm)
SORT ARRAY:C229($ItemSubForm; $Yield; $NumUp; >)
ARRAY LONGINT:C221($netSheets; Size of array:C274($Yield))  //calc based on numup and yield qty

//check each subform for consistency and build the display arrays
For ($i; 1; Size of array:C274($Yield))
	$netSheets{$i}:=$Yield{$i}/$NumUp{$i}  //should match the netsheets entered in the estimate but not transfered here unfortunately
	$hit:=Find in array:C230(aSubForm; $ItemSubForm{$i})  //add to subform table if first encounter
	If ($hit=-1)  //new subform encountered
		APPEND TO ARRAY:C911(aSubForm; $ItemSubForm{$i})
		APPEND TO ARRAY:C911(aSubFormQty; $netSheets{$i})
		APPEND TO ARRAY:C911(aRatio; ($netSheets{$i}/[Job_Forms:42]EstNetSheets:28))
	Else   //check that net sheets are consistent
		If (aSubFormQty{$hit}#$netSheets{$i})
			ALERT:C41("Planned net sheets looks wrong on subform "+String:C10($ItemSubForm{$i}))
		End if 
	End if 
End for 


ARRAY BOOLEAN:C223(ListBox2; Size of array:C274(aSubForm))  //a selection array in hte listbox

