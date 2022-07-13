//(LP) [Material_Job];"MatlBudInclList"
//Upr 0235 Cs - 12/4/96 - Chargecode Change

Case of 
	: (Form event code:C388=On Load:K2:1)
		[Job_Forms_Materials:55]JobForm:1:=[Job_Forms:42]JobFormID:5
		aMatlDesc:=""
		aCode:=""
		
		//Upr 0235 
		// [Material_Job]ChargeCode:=""
		[Job_Forms_Materials:55]CompanyId:23:=""
		[Job_Forms_Materials:55]DepartmentID:24:=""
		[Job_Forms_Materials:55]ExpenseCode:25:=""
		
		
	: (Form event code:C388=On Display Detail:K2:22)
		gFindMatl([Job_Forms_Materials:55]Commodity_Key:12)
		aMatlDesc:=zzDESC
		//[Material_Job]RMName:=zzDesc
		aGroup:=String:C10(zzGroup)
		aCode:=zzCode
		//aGroup:=Substring([Material_Job]Commodity_Key;1;2)
		//aCode:=Substring([Material_Job]Commodity_Key;4;20)
End case 
//ELOP