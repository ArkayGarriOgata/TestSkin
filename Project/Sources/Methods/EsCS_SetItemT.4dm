//%attributes = {}
// Method: EsCS_SetItemT(vItem)=>tItem
// Description:  This is used to set the Item 
//   Because we are get Items that contain 00
//    and that should not happen
// User name (OS): Garri Ogata
// Date and time: 09/20/21, 11:57:28

If (False:C215)  //Data
	
	C_COLLECTION:C1488($cItem)
	
	$cItem:=New collection:C1472()
	
	$cItem:=ds:C1482.Estimates_Carton_Specs.all().distinct("Item")  //"<<" (14,115) and "00" (128)
	
	$cItem:=ds:C1482.Estimates_FormCartons.all().distinct("ItemNumber")  //0 (150)
	
	$cItem:=ds:C1482.Job_Forms_Items.all().distinct("ItemNumber")  //0 (150)
	
End if   //Done data

If (True:C214)  //Initialize
	
	C_VARIANT:C1683($1; $vItem)
	C_TEXT:C284($0; $tItem)
	
	C_LONGINT:C283($nValueType)
	C_OBJECT:C1216($oAlert)
	
	$vItem:=$1
	$tItem:="00"  //Default as an issue
	
	$nValueType:=Value type:C1509($vItem)
	
	$oAlert:=New object:C1471()
	
	$oAlert.tMessage:="Please contact amshelp@arkay.com. Tell them the item number was added as 00."
	//We need help identifying what is causing the item number to be 00.
	
End if   //Done initialize

Case of   //ValueType
		
	: ($nValueType=Is text:K8:3)
		
		If (($vItem="00") | ($vItem="0"))  //Not valid
			
			Core_Dialog_Alert($oAlert)
			
		Else   //valid
			
			$tItem:=$vItem
			
		End if   //Done not valid
		
	: (($nValueType=Is longint:K8:6) | ($nValueType=Is real:K8:4))
		
		If ($vItem>0)  //Valid
			
			$tItem:=String:C10($vItem; "00")
			
		Else   //Not valid
			
			Core_Dialog_Alert($oAlert)
			
		End if   //Done valid
		
End case   //Done ValueType

$0:=$tItem