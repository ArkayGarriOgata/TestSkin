//%attributes = {"publishedWeb":true}
//PM: PSPEC_getDetails() -> 
//@author mlb - 6/18/02  14:35

C_TEXT:C284($t)
C_TEXT:C284($detail; $0)

$t:=Char:C90(9)
$detail:=""
$detail:=$detail+[Process_Specs:18]Stock:7+" "+String:C10([Process_Specs:18]Caliper:8)+$t+[Process_Specs:18]FoilType:9+" "+String:C10([Process_Specs:18]FoilGauge:10)+$t
$detail:=$detail+[Process_Specs:18]FilmLaminate:11+" "+String:C10([Process_Specs:18]FilmLamGauge:12)+$t
$detail:=$detail+[Process_Specs:18]Stamp1:41+"-"+[Process_Specs:18]LeafColor1:44+$t+[Process_Specs:18]Stamp2:42+"-"+[Process_Specs:18]LeafColor2:45+$t+[Process_Specs:18]Stamp3:43+"-"+[Process_Specs:18]LeafColor3:46+$t
$detail:=$detail+[Process_Specs:18]Coat1Type:13+"-"+[Process_Specs:18]Coat1Matl:14+$t+[Process_Specs:18]Coat2Type:15+"-"+[Process_Specs:18]Coat2Matl:16+$t+[Process_Specs:18]iCoat3Type:23+"-"+[Process_Specs:18]iCoat3Matl:24+$t
$detail:=$detail+String:C10(Num:C11([Process_Specs:18]Embossing:77))+$t+String:C10(Num:C11([Process_Specs:18]Embossing2:89))+$t

$0:=$detail