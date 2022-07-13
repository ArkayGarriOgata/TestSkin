//%attributes = {}
//Method: Core_PlugIn_Access(oAccess)
//Description:  This method is called from a form that uses PlugIn areas.
// It will verify that a licenses is available for the PlugIn

//See Core_PlugIn_AccessSetB for more information

// How to use Core_PlugIn_Access:
//.  1.  In Form:Property List:Events check the following:
//.         On Load, On Activate, On Deactivate and On Close Box
//.  2.  Add Core_PlugIn_Access to the form method 

//.     C_OBJECT($oAccess)
//.     $oAccess:=New object()
//.     $oAccess.nPlugIn:=4D View license

//.     Core_PlugIn_Access(oAccess)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAccess)
	
	C_BOOLEAN:C305($bContinue)
	
	C_LONGINT:C283($nPlugIn; $nFormEventCode)
	
	C_OBJECT:C1216($oAccessSet)
	
	$oAccess:=New object:C1471()
	
	If (Count parameters:C259>=1)
		$oAccess:=$1
	End if 
	
	$nPlugIn:=4D View license:K44:4
	
	If (OB Is defined:C1231($oAccess; "nPlugIn"))
		$nPlugIn:=$oAccess.nPlugIn
	End if 
	
	$oAccessSet:=New object:C1471()
	
	$oAccessSet.tCategory:="PlugIn"
	$oAccessSet.tIdentifier:=Core_PlugIn_GetNameT($nPlugIn)
	
	$nFormEventCode:=Form event code:C388
	
End if   //Done initialize

Case of   //Form event
		
	: ($nFormEventCode=On Load:K2:1)  //Loading Form
		
		$oAccessSet.tOld:="Available"
		$oAccessSet.tNew:=CorektBlank
		
		$bContinue:=Core_PlugIn_AccessSetB($oAccessSet)
		
	: ($nFormEventCode=On Close Box:K2:21)  //Closing form 
		
		$oAccessSet.tOld:=Current user:C182(4D user account:K5:54)
		$oAccessSet.tNew:="Available"
		
		$bContinue:=Core_PlugIn_AccessSetB($oAccessSet)
		
End case   //Done form event
