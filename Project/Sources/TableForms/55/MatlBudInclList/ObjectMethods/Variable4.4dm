//(S)[Material_Job]aCode
//Upr 0235 Cs - 12/4/96 - Chargecode Change

[Job_Forms_Materials:55]Commodity_Key:12:=Substring:C12(aCode; Position:C15(" - "; aCode)+3)
gFindMatl([Job_Forms_Materials:55]Commodity_Key:12)
If (zzDESC="")
	aMatlDesc:=""
	aCode:=""
	aGroup:=""
	
	//Upr 0235 
	// [Material_Job]ChargeCode:=""
	[Job_Forms_Materials:55]CompanyId:23:=""
	[Job_Forms_Materials:55]DepartmentID:24:=""
	[Job_Forms_Materials:55]ExpenseCode:25:=""
	//end Upr 0235    
	
	ALERT:C41("Invalid Material Code - Please try again!!!")
	REJECT:C38
Else 
	aMatlDesc:=zzDESC
	//[Material_Job]RMName:=zzDesc
	aGroup:=String:C10(zzGroup)
	aCode:=zzCode
	//[Material_Job]Commodity_Key:=◊ayComm_Key
End if 
//EOS
