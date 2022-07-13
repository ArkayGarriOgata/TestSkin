//%attributes = {}
//Method:  Core_NmKy_Option
//Description: This method will ask to save the values in the arrays
//  This can later be brought up as needed

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oValidValue)
	C_OBJECT:C1216($oCoreValidValue)
	C_OBJECT:C1216($oAsk)
	
	C_LONGINT:C283($nRequestButton)
	
	C_TEXT:C284($tBlank)
	
	$oValidValue:=New object:C1471()
	$oCoreValidValue:=New object:C1471()
	$oAsk:=New object:C1471()
	
	$oAsk.tMessage:="What would you like to name this?"
	
	$tBlank:=CorektBlank
	
End if   //Done initialize

$nRequestButton:=Core_Dialog_RequestN($oAsk)

Case of   //Save
		
	: ($nRequestButton=CoreknCancel)
	: ($oAsk.tValue=CorektBlank)
		
	Else   //Save it
		
		Core_Array_Remove(->Core_atNmKy_Name; ->$tBlank)
		Core_Array_Remove(->Core_atNmKy_NameValue; ->$tBlank)
		Core_Array_Remove(->Core_atNmKy_Key; ->$tBlank)
		Core_Array_Remove(->Core_atNmKy_KeyValue; ->$tBlank)
		
		If (Size of array:C274(Core_atNmKy_Name)>0)
			
			OB SET ARRAY:C1227($oValidValue; "Name"; Core_atNmKy_Name)
			
		End if 
		
		If (Size of array:C274(Core_atNmKy_NameValue)>0)
			
			OB SET ARRAY:C1227($oValidValue; "NameValue"; Core_atNmKy_NameValue)
			
		End if 
		
		If (Size of array:C274(Core_atNmKy_Key)>0)
			
			OB SET ARRAY:C1227($oValidValue; "Key"; Core_atNmKy_Key)
			
		End if 
		
		If (Size of array:C274(Core_atNmKy_KeyValue)>0)
			
			OB SET ARRAY:C1227($oValidValue; "KeyValue"; Core_atNmKy_KeyValue)
			
		End if 
		
		$oCoreValidValue.Identifier:=$oAsk.tValue
		$oCoreValidValue.Category:="Core_NmKy"
		$oCoreValidValue.ValidValue:=$oValidValue
		
		Core_VdVl_Commit($oCoreValidValue)
		
End case   //Done save
