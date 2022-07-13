$text:=" "
For ($i; 1; Size of array:C274(aOutlineNum))
	$text:=$text+aOutlineNum{$i}+" - "+String:C10(aNumberUp{$i})+" up, "
End for 
[Job_DieBoards:152]SpecialRequirements:15:=[Job_DieBoards:152]SpecialRequirements:15+$text