t10:="Ordering: "
If ([Job_DieBoards:152]OrderBlanker:9)
	t10:=t10+"Blanker"
End if 

If ([Job_DieBoards:152]OrderFSB:10)
	If (Length:C16(t10)>10)  //already got blanker
		t10:=t10+" and "
	End if 
	t10:=t10+"FSB"
End if 

If ([Job_DieBoards:152]OrderDie:11)
	If (Position:C15(" and "; t10)>10)  //already blanker and fsb
		t10:=Replace string:C233(t10; " and "; ", ")  //blanker, fsb
	End if 
	
	If (Length:C16(t10)>10)  //either  `blanker, fsb  or fsb
		t10:=t10+" and "
	End if 
	
	t10:=t10+"Die"
End if 

SAVE RECORD:C53([Job_Forms:42])
SAVE RECORD:C53([Job_DieBoards:152])
FORM SET OUTPUT:C54([Job_Forms:42]; "Die_RequisitionRpt")


PRINT RECORD:C71([Job_Forms:42])
FORM SET OUTPUT:C54([Job_Forms:42]; "List")
[Job_Forms:42]zCount:12:=1  //trigger the validate phase
