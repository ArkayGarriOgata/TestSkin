//%attributes = {}
// -------
// Method: Zebra_Style_Revlon   ( ) ->
// By: Mel Bohince @ 05/02/18, 14:57:30
// Description
// long 8" label, non-WMS conformant
// Modified by: Garri Ogata (8/4/21) added RwMt_SetFSCCodeB this is prep for FSC change it returns false for now
// ----------------------------------------------------


//*Init vars
C_TEXT:C284($lableDef; $0)
C_TEXT:C284($s; $e; $cr; $startLabel; $endLabel; $home; $printQty; $speed)
$cr:=Char:C90(13)+Char:C90(10)  //Linefeed and carriage return
$b:="^FD"  //begin data
$e:="^FS"+$cr  //end data
$startLabel:="^XA"
$endLabel:="^XZ"
$speed:="^PR"+sCriterion1

$home:="^LH"+sCriterion2+","+sCriterion3

Zebra_dpiScaling(lValue1)

C_LONGINT:C283($col1; $col2; $col3; $col4)
$col1:=2
$col2:=18
$col3:=63
$col4:=72
$col5:=85
$col6:=90
$col7:=103
$col8:=107
$col9:=120

//rows, starting from the bottom of the label viewed in landscape
C_LONGINT:C283($row1; $row2; $row3; $row4; $row5; $row6; $row7; $row8)
$row1:=3
$row1_5:=11
$row2:=20
$row3:=30
$row4:=39
$row5:=43
$row6:=51
$row7:=53
$row8:=56

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:revlon.ZPL^FS"+$cr  //give the template a name


//Labels--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1_5; $col1)
$labelDef:=$labelDef+zFont12+$b+"Box Qty:"+$e

If (RwMt_SetFSCCodeB)
	$labelDef:=$labelDef+ZebraLabelGrid("at"; $row2; $col1)
	$labelDef:=$labelDef+zFont12+$b+" FSC#: BV-COC-070906  FSC Mix Credit"+$e
End if 

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row3; $col1)
$labelDef:=$labelDef+zFont12+$b+"PO Nbr:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row7; $col1)
$labelDef:=$labelDef+zFont24+$b+"REVLON"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col3)
$labelDef:=$labelDef+zFont18+$b+"ARKAY PACKAGING"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col5)
$labelDef:=$labelDef+zFont12+$b+"Contains:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col8)
$labelDef:=$labelDef+zFont12+$b+"Each"+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1_5; $col2)  //qty bc
$labelDef:=$labelDef+zBcode128+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row3; $col2)  //po
$labelDef:=$labelDef+zFont12+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col1)  //desc
$labelDef:=$labelDef+zFont12+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row5; $col1)  //cpn
$labelDef:=$labelDef+zFont18+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col7; 0; -40)  //qty human
$labelDef:=$labelDef+zFont12+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1; $col4)  //dom bc
$labelDef:=$labelDef+zBcode128rotated+"^FN6"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1_5; $col5)  //dom coded
$labelDef:=$labelDef+zFont14rotated+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1; $col6)  //alias bc - sap#
$labelDef:=$labelDef+zBcode128rotated+"^FN8"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1_5; $col7)  //alias - sap#
$labelDef:=$labelDef+zFont14rotated+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1; $col8)  //lot bc
$labelDef:=$labelDef+zBcode128rotated+"^FN10"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1_5; $col9)  //lot
$labelDef:=$labelDef+zFont14rotated+"^FN11"+$e


$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)