//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 09/12/13, 10:51:55
// ----------------------------------------------------
// Method: PSG_WIP
// Description:
// Using the glueschedule arrays priviously loaded sum the qty 
// remaining to glue for all that have been die cut, subtotal 
// flat pack v regular
// ----------------------------------------------------
// Modified by: Mel Bohince (2/28/14) rename variables for readibility, reset $qty_already_glued at top of loop, add thermomter, forget about aPrinted{$i}="Yes"
// Modified by: Mel Bohince (10/21/14) exclude items set to gluer 9xx
C_LONGINT:C283($i; $qty_total_glue_n_flat; $qty_to_flat_pack; $qty_to_glue; $qty_already_glued; $qty_remaining_to_produce; $numRecs)

$qty_total_glue_n_flat:=0
$qty_to_flat_pack:=0
$xlQtyTotal:=0
$qty_already_glued:=0
$numRecs:=Size of array:C274(aJobit)
uThermoInit($numRecs; "Analyzing Records")
For ($i; 1; $numRecs)
	If (aGluer{$i}#"9xx")  // Modified by: Mel Bohince (10/21/14) exclude items set to gluer 9xx
		If (aDieCut{$i}="Yes")  //((aPrinted{$i}="Yes") & 
			//Now find any planned quanties scanned into CC:R
			$qty_already_glued:=0  // Modified by: Mel Bohince (2/28/14) 
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=aJobit{$i}; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="CC:R@")
			If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
				$qty_already_glued:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			End if 
			
			$qty_remaining_to_produce:=aQtyPlnd{$i}-$qty_already_glued
			$qty_total_glue_n_flat:=$qty_total_glue_n_flat+$qty_remaining_to_produce
			
			If (aGluer{$i}="493")  //Flat Pack
				$qty_to_flat_pack:=$qty_to_flat_pack+$qty_remaining_to_produce
			Else   //normal gluer
				$qty_to_glue:=$qty_to_glue+$qty_remaining_to_produce
			End if 
		End if 
		
	Else 
		//skip
	End if 
	
	uThermoUpdate($i)
End for   //each jobform sequence
uThermoClose

t1:="Roanoke WIP Report for "+String:C10(Current date:C33)+<>CR+<>CR+<>CR
t1:=t1+"Ready to glue: "+String:C10($qty_to_glue; "###,###,###")+<>CR
If ($qty_to_flat_pack>0)
	t1:=t1+"Ready to flat pack: "+String:C10($qty_to_flat_pack; "###,###,###")+<>CR+<>CR
Else 
	t1:=t1+<>CR
End if 

t1:=t1+"Total: "+String:C10($qty_total_glue_n_flat; "###,###,###")+" ctns."+<>CR+<>CR+<>CR
//t1:=t1+"Gluers included in report: "+<>CR
//t1:=t1+Choose(cb1=1;"All, ";"")
//t1:=t1+Choose(cb2=1;"Un-Assigned, ";"")
//t1:=t1+Choose(cb3=1;"476 (Int'l), ";"")
//t1:=t1+Choose(cb5=1;"478 (Bobst), ";"")
//t1:=t1+Choose(cb6=1;"480 (Alpina 75), ";"")
//t1:=t1+Choose(cb4=1;"481 (Bobst), ";"")
//t1:=t1+Choose(cb10=1;"482 (Heidelberg), ";"")
//t1:=t1+Choose(cb10=1;"483 (Heidelberg), ";"")  // Added by: Mark Zinke (1/13/14) 
//t1:=t1+Choose(cb8=1;"484 (Bobst 110), ";"")
//t1:=t1+Choose(cb7=1;"485 (Alpina 110), ";"")
//t1:=t1+Choose(cb11=1;"493 (Flat Pack), ";"")
//t1:=t1+Choose(cb9=1;"9xx (O/S Glue), ";"")

//t1:=Substring(t1;1;Length(t1)-2)+"."  //Replace the last comma with a period.

CenterWindow(725; 480; 0; "Roanoke WIP Report "+String:C10(Current date:C33))
DIALOG:C40([zz_control:1]; "text2_dio")
CLOSE WINDOW:C154