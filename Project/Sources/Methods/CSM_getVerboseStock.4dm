//%attributes = {}
// Method: CSM_getVerboseStock () -> 
// ----------------------------------------------------
// by: mel: 10/25/03, 09:43:18
// ----------------------------------------------------
// Description:
// make a text description of stock specs on ColorMasterSpec
// ----------------------------------------------------

C_POINTER:C301($1)
C_LONGINT:C283($0)
C_TEXT:C284($t)

$t:=", "  //Char(9)

C_TEXT:C284($text)
$text:=""
$text:=[Finished_Goods_Color_SpecMaster:128]stockType:5+$t+String:C10([Finished_Goods_Color_SpecMaster:128]stockCaliper:6; "0.000###")+$t+[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8+"; "
$text:=Replace string:C233($text; " None "; "")
$text:=Replace string:C233($text; $t+$t; "")
$1->:=$1->+$text
$0:=Length:C16($text)