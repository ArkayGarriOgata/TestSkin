tText:=""

For ($i; 1; Size of array:C274(aOutlineNum))
	tText:=tText+aOutlineNum{$i}+"     "+String:C10(aNumberUp{$i})+" up "+Char:C90(13)
End for 

SAVE RECORD:C53([Job_Forms:42])
SAVE RECORD:C53([Job_DieBoards:152])
FORM SET OUTPUT:C54([Job_Forms:42]; "Die_CounterRpt")

PRINT RECORD:C71([Job_Forms:42])
FORM SET OUTPUT:C54([Job_Forms:42]; "List")
[Job_Forms:42]zCount:12:=1  //trigger the validate phase