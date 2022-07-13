//%attributes = {"publishedWeb":true}
//PM: PItagSortReport() -> 
//@author mlb - 4/20/01  14:35

C_LONGINT:C283($lastTag; $thisTag; $i)
C_TEXT:C284($t; $cr)

$t:="     "  //Char(9)
$cr:=Char:C90(13)

NewWindow(250; 120; 6; Modal dialog:K27:2)
DIALOG:C40([zz_control:1]; "DateRangeAndPlant")
CLOSE WINDOW:C154

If (OK=1)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Adjust"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Reason:26="Tag@")
	If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Reason:26; >)
		xTitle:="Sorted by Tag Number, <<<< indicates a break in the sequence"
		xText:="TagNumber"+$t+"Skip"+$t+"JobIt"+$t+"Location"+$cr
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Reason:26; $tag; [Finished_Goods_Transactions:33]Location:9; $loc; [Finished_Goods_Transactions:33]Jobit:31; $jobit)
		$numTrans:=Size of array:C274($tag)
		ARRAY TEXT:C222($missing; $numTrans)
		$lastTag:=Num:C11($tag{1})-1
		For ($i; 1; $numTrans)
			$thisTag:=Num:C11($tag{$i})
			If ($thisTag#($lastTag+1))
				$missing{$i}:="<<<<"
			Else 
				$missing{$i}:="    "
			End if 
			$lastTag:=$thisTag
		End for 
		
		For ($i; 1; $numTrans)
			xText:=xText+$tag{$i}+$t+$missing{$i}+$t+$jobit{$i}+$t+$loc{$i}+$cr
		End for 
		rPrintText
		xTitle:=""
		xText:=""
	Else 
		BEEP:C151
		ALERT:C41("No transactions were found.")
	End if 
End if 