//%attributes = {}
// Method: FG_CalcInventory (cpn) -> text
// ----------------------------------------------------
// by: mel: 02/26/04, 14:52:30
// ----------------------------------------------------
// Modified by: Mel Bohince (1/30/18) lose the tabs

C_TEXT:C284($1)
//C_TEXT($0)
C_LONGINT:C283($i; $onhandFG; $0)
//C_BOOLEAN($haup;$roan)
ARRAY TEXT:C222($aBins; 0)
ARRAY LONGINT:C221($aQty; 0)

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$1; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"FG:AV@")
SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aBins; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
//$haup:=False
//$roan:=False
//sState:=""
$onhandFG:=0
//r3:=0

For ($i; 1; Size of array:C274($aBins))
	If (Substring:C12($aBins{$i}; 1; 2)="FG")
		//r3:=r3+$aQty{$i}
		//Else 
		$onhandFG:=$onhandFG+$aQty{$i}
	End if 
	//If (Position("R";Substring($aBins{$i};1;4))>0)
	//$roan:=True
	//Else 
	//$haup:=True
	//End if 
End for 

//sState:=("H"*Num($haup))+("R"*Num($roan))

//$0:=sState+Char(9)+String(r2)+Char(9)+"non:"+Char(9)+String(r3)
$0:=$onhandFG  // Modified by: Mel Bohince (1/30/18) 

