//%attributes = {}
READ ONLY:C145([Finished_Goods:26])
$numFG:=qryFinishedGood($1; $2)
If ($numFG=1)
	$0:=[Finished_Goods:26]OriginalOrRepeat:71
Else 
	$0:="n/f"
End if 