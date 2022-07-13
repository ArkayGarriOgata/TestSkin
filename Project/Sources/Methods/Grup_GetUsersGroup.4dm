//%attributes = {}
//Method:  Grup_GetUsersGroup(patGroup;{tUserName})
//Description:  This method 

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patGroup)
	C_TEXT:C284($2; $tUserName)
	
	ARRAY TEXT:C222($atRole; 0)
	ARRAY TEXT:C222($atGroup; 0)
	
	C_LONGINT:C283($nRole; $nNumberOfRoles)
	C_BOOLEAN:C305($bAddDevelopment; $bAddSales; $bAddAccounting)
	C_BOOLEAN:C305($bAddProduction; $bAddQualityAssurance)
	C_BOOLEAN:C305($bAddCustomerService)
	
	C_LONGINT:C283($nNumberOfParameters)
	$nNumberOfParameters:=Count parameters:C259
	
	$patGroup:=$1
	
	$tUserName:=Current user:C182
	
	If ($nNumberOfParameters>=2)
		$tUserName:=$2
	End if 
	
	$bAddDevelopment:=True:C214
	$bAddSales:=True:C214
	$bAddAccounting:=True:C214
	$bAddProduction:=True:C214
	$bAddQualityAssurance:=True:C214
	$bAddCustomerService:=True:C214
	
	//If you modify $atGroup make sure to update comments(#-#) and Group case statement in Role loop
	
	APPEND TO ARRAY:C911($atGroup; "RoleSuperUser")  //GrupktDevelopment (1)
	
	APPEND TO ARRAY:C911($atGroup; "RoleEstimator")  //GrupktSale (2-5)
	APPEND TO ARRAY:C911($atGroup; "RolePlanner")
	APPEND TO ARRAY:C911($atGroup; "RoleSalesman")
	APPEND TO ARRAY:C911($atGroup; "RoleBuyer")
	
	APPEND TO ARRAY:C911($atGroup; "RoleAccounting")  //GrupktAccounting (6-8)
	APPEND TO ARRAY:C911($atGroup; "RoleCostAccountant")
	APPEND TO ARRAY:C911($atGroup; "AccountManager")
	
	APPEND TO ARRAY:C911($atGroup; "RoleDataEntry")  //GrupktProduction (9-11)
	APPEND TO ARRAY:C911($atGroup; "RoleMaterialHandler")
	APPEND TO ARRAY:C911($atGroup; "RoleProduction")
	
	APPEND TO ARRAY:C911($atGroup; "RoleQA")  //GrupktQualityAssurance (12-14)
	APPEND TO ARRAY:C911($atGroup; "RoleQA_Certification")
	APPEND TO ARRAY:C911($atGroup; "RoleQA_Mgr")
	
	APPEND TO ARRAY:C911($atGroup; "RoleCustomerService")  //GrupktCustomerService (15)
	
End if   //Done Initialize

$tGroups:=Core_User_GetGroupsT($tUserName; ->$atRole)

$nNumberOfRoles:=Size of array:C274($atRole)

For ($nRole; 1; $nNumberOfRoles)  //Role
	
	$nRoleLocation:=Find in array:C230($atGroup; $atRole{$nRole})
	
	Case of   //Group
			
		: ($nRoleLocation=CoreknNoMatchFound)  //Ignore these roles
			
		: (($nRoleLocation=1) & $bAddDevelopment)
			
			APPEND TO ARRAY:C911($patGroup->; GrupktDevelopment)
			$bAddDevelopment:=False:C215
			
		: ((($nRoleLocation>=2) & ($nRoleLocation<=5)) & $bAddSales)
			
			APPEND TO ARRAY:C911($patGroup->; GrupktSale)
			$bAddSales:=False:C215
			
		: ((($nRoleLocation>=6) & ($nRoleLocation<=8)) & $bAddAccounting)
			
			APPEND TO ARRAY:C911($patGroup->; GrupktAccounting)
			$bAddAccounting:=False:C215
			
		: ((($nRoleLocation>=9) & ($nRoleLocation<=11)) & $bAddProduction)
			
			APPEND TO ARRAY:C911($patGroup->; GrupktProduction)
			$bAddProduction:=False:C215
			
		: ((($nRoleLocation>=12) & ($nRoleLocation<=14)) & $bAddQualityAssurance)
			
			APPEND TO ARRAY:C911($patGroup->; GrupktQualityAssurance)
			$bAddQualityAssurance:=False:C215
			
		: (($nRoleLocation=15) & $bAddCustomerService)
			
			APPEND TO ARRAY:C911($patGroup->; GrupktCustomerService)
			$bAddCustomerService:=False:C215
			
	End case   //Done group
	
End for   //Done role
