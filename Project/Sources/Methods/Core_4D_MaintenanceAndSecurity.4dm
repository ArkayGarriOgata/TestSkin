//%attributes = {}
//Method:  Core_4D_MaintenanceAndSecurity ({tSetting})
//Description:  This method gets called from a button on a form it will bring
// up the 4D window 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tSetting)
	
	C_LONGINT:C283($nNumberOfParameters)
	$nNumberOfParameters:=Count parameters:C259
	
	$tSetting:=CorektBlank
	
	If ($nNumberOfParameters>=1)  //Parameters
		$tSetting:=$1
	End if   //Done parameters
	
End if   //Done Initialize

Case of 
		
	: ($tSetting="SettingsWindow")
		
		OPEN SETTINGS WINDOW:C903("/")
		
	: ($tSetting="VerifyDataFile")
		
		//VERIFY DATA FILE
		
	: ($tSetting="AdministrationWindow")
		
		OPEN ADMINISTRATION WINDOW:C1047
		
	: ((Application type:C494=4D Local mode:K5:1) | (Application type:C494=4D Server:K5:6))
		
		OPEN SECURITY CENTER:C1018
		
	: (Application type:C494=4D Remote mode:K5:5)
		
		OPEN ADMINISTRATION WINDOW:C1047
		
End case 
