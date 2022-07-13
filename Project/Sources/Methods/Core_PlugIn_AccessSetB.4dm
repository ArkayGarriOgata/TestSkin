//%attributes = {}
//Method: Core_PlugIn_AccessSetB(oAccessSet)=>bSet
//Description:  This method will manage the plugins licenses that are used
// Its main purpose is to update [Core_ValidValue]ValidValue with the user assigned
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAccessSet)  //.tCategory .tIdentifier .tOld  .tNew
	C_BOOLEAN:C305($0; $bSet)
	
	C_LONGINT:C283($nAvailable; $nCheck)
	C_LONGINT:C283($nOneSecond)
	
	C_OBJECT:C1216($oNotAvailable; $oTryLater)
	C_OBJECT:C1216($oValidValue)
	
	C_TEXT:C284($tPlugIn)
	
	ARRAY TEXT:C222($atUserName; 0)
	
	$oAccessSet:=$1
	$bSet:=False:C215
	
	$nCheck:=0
	$nOneSecond:=60
	
	$oNotAvailable:=New object:C1471()
	$oNotAvailable.tMessage:="All the licenses are used."+CorektSpace+ArkyktAmsHelpEmail
	
	$oTryLater:=New object:C1471()
	$oTryLater.tMessage:="Could not access licenses."+CorektSpace+ArkyktAmsHelpEmail
	
	$nPlugIn:=Num:C11(Core_PlugIn_GetNameT($oAccessSet.tIdentifier))
	
End if   //Done initialize

Case of   //License
		
	: (Get plugin access:C846($nPlugIn)=CorektBlank)  //Plugin is not associated to a group
		
	: (Not:C34(Is license available:C714($nPlugIn)))  //No license
		
	Else   //Assign group
		
		Repeat   //Check
			
			If (Not:C34(Semaphore:C143(Current method name:C684)))  //Free
				
				$oValidValue:=Core_VdVl_GetValidValueO($oAccessSet.tCategory; $oAccessSet.tIdentifier)
				
				OB GET ARRAY:C1229($oValidValue; "UserName"; $atUserName)
				
				$nUserName:=Find in array:C230($atUserName; $oAccessSet.tOld)
				
				If ($nUserName#CoreknNoMatchFound)  //Available
					
					If ($oAccessSet.tNew=CorektBlank)  //Assign
						
						$oAccessSet.tNew:=\
							Current user:C182(4D user account:K5:54)+CorektPipe+\
							String:C10(Current date:C33(*))+CorektPipe+\
							String:C10(Current time:C178(*))
						
					End if   //Done assign
					
					$atUserName{$nUserName}:=$oAccessSet.tNew
					
					OB SET ARRAY:C1227($oValidValue; "UserName"; $atUserName)
					
					Core_VdVl_SetValidValue($oAccessSet.tCategory; $oAccessSet.tIdentifier; $oValidValue)
					
				Else   //Not available
					
					Core_Dialog_Alert($oNotAvailable)
					
				End if   //Done available
				
				CLEAR SEMAPHORE:C144(Current method name:C684)
				
				$bSet:=True:C214
				
			Else   //Used
				
				$nCheck:=$nCheck+1
				
				If ($nCheck<=3)  //Try
					
					DELAY PROCESS:C323(Current process:C322; $nOneSecond)
					
				Else   //Too many tries
					
					Core_Dialog_Alert($oTryLater)
					
					$bSet:=True:C214
					
				End if   //Done try
				
			End if   //Done free
			
		Until ($bSet)  //Done check
		
End case   //Done license

$0:=$bSet