
Case of 
	: (Form event code:C388=On Load:K2:1)
		C_OBJECT:C1216(rm)
		rm2:=New object:C1471
		rm2:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; Form:C1466.ent.Raw_Matl_Code).first()
		
		
End case 
