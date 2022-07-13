//bMatch
PSpecEstimateLd("Machines"; "Materials")
SELECTION TO ARRAY:C260([Process_Specs_Machines:28]Seq_Num:3; $OpSeq; [Process_Specs_Machines:28]CostCenterID:4; $OpCC)
SORT ARRAY:C229($OpSeq; $OpCC; >)
SELECTION TO ARRAY:C260([Process_Specs_Materials:56]Sequence:4; $MatSeq; [Process_Specs_Materials:56]CostCtrID:3; $MatCC)
For ($i; 1; Size of array:C274($MatSeq))
	$hit:=Find in array:C230($OpCC; $MatCC{$i})
	If ($hit#-1)
		$MatSeq{$i}:=$OpSeq{$hit}
	End if 
End for 
ARRAY TO SELECTION:C261($MatSeq; [Process_Specs_Materials:56]Sequence:4)
ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Sequence:4; >)
ORDER BY:C49([Process_Specs_Machines:28]; [Process_Specs_Machines:28]Seq_Num:3; >)
//MESSAGES ON