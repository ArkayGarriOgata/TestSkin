C_DATE:C307(dDateBegin; dDateEnd)
dDateBegin:=4D_Current_date
dDateEnd:=dDateBegin+1
C_LONGINT:C283(iPage)
C_TEXT:C284(t1; t2; t3; t4; t5; t6; t7; t8)
If (aQAid#0)
	t1:=aQAid{aQAid}
	t2:=aQATopic{aQAid}+" Rev. "+aQAVersion{aQAid}
	t3:=""  //aQAVersion{aQAid}
	t4:=""
Else 
	t1:=""
	t2:=""
	t3:=""
	t4:=""
End if 

If (aQASectionId#0)
	t5:=aQASectionId{aQASectionId}
	t6:=aQASectionTopic{aQASectionId}+" Rev. "+aQASectionVersion{aQASectionId}
	t7:=""
	t8:=""
Else 
	t5:=""
	t6:=""
	t7:=""
	t8:=""
End if 

util_PAGE_SETUP(->[QA_Procedures:108]; "PrintPage")
FORM SET OUTPUT:C54([QA_Procedures:108]; "PrintPage")
PRINT RECORD:C71([QA_Procedures:108]; *)
FORM SET OUTPUT:C54([QA_Procedures:108]; "List")
//