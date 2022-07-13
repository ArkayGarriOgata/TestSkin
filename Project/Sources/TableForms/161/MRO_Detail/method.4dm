
Case of 
	: (Form event code:C388=On Load:K2:1)
		C_OBJECT:C1216(rm)
		rm:=New object:C1471
		rm:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; Form:C1466.ent.PartNumber).first()
		
		
End case 
