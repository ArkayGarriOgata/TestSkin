//bMatch
//PSpecEstimateLd ("Machines";"Materials")
SELECTION TO ARRAY:C260([Estimates_Machines:20]Sequence:5; $OpSeq; [Estimates_Machines:20]CostCtrID:4; $OpCC)
SORT ARRAY:C229($OpSeq; $OpCC; >)
SELECTION TO ARRAY:C260([Estimates_Materials:29]Sequence:12; $MatSeq; [Estimates_Materials:29]CostCtrID:2; $MatCC)
For ($i; 1; Size of array:C274($MatSeq))
	$hit:=Find in array:C230($OpCC; $MatCC{$i})
	If ($hit#-1)
		$MatSeq{$i}:=$OpSeq{$hit}
	End if 
End for 
ARRAY TO SELECTION:C261($MatSeq; [Estimates_Materials:29]Sequence:12)
ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
//MESSAGES ON