//%attributes = {"publishedWeb":true}
//(P) gFindMatl
//  $1 = Material Code to Lookup
//1/10/95
//Upr 0235 Cs - 12/4/96 - Chargecode Change

C_TEXT:C284($1)

$CommKey:=$1  //done for search below

QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$CommKey)
If (Records in selection:C76([Raw_Materials_Groups:22])>0)
	ORDER BY:C49([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]EffectivityDate:15; <)
	// zzDESC:=Substring([RM_GROUP]SubGroup;11)  `1/10/95
	zzDESC:=[Raw_Materials_Groups:22]Commodity_Key:3  //1/10/95
	zzGroup:=[Raw_Materials_Groups:22]Commodity_Code:1
	
	//Upr 0235
	//zzCode:=[RM_GROUP]ChargeCode
	zzCode:=[Raw_Materials_Groups:22]CompanyID:21+[Raw_Materials_Groups:22]DepartmentID:22+[Raw_Materials_Groups:22]GL_Expense_Code:25
	//end upr 0235
Else 
	zzDesc:=""
	zzGroup:=Num:C11("")
	zzCode:=""
End if 