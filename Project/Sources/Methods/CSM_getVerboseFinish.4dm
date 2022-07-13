//%attributes = {}
// Method: CSM_getVerboseFinish () -> 
// ----------------------------------------------------
// by: mel: 10/25/03, 09:46:30
// ----------------------------------------------------
// Description:
// make a text description of fisish specs on ColorMasterSpec
// ----------------------------------------------------

C_POINTER:C301($1)
C_LONGINT:C283($0)
C_TEXT:C284($t)

$t:=", "  //Char(9)

C_TEXT:C284($text)
$text:=""
$text:=[Finished_Goods_Color_SpecMaster:128]finishType:11+$t+[Finished_Goods_Color_SpecMaster:128]finishProcess:12+$t+[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13+$t+[Finished_Goods_Color_SpecMaster:128]finishStamps:14+$t
$text:=$text+[Finished_Goods_Color_SpecMaster:128]finishLaminationRMcode:15+$t+[Finished_Goods_Color_SpecMaster:128]finishLaminationRMcode:15+"."
$text:=Replace string:C233($text; " None "; "")
$text:=Replace string:C233($text; $t+$t; "")
$1->:=$1->+$text

$0:=Length:C16($text)