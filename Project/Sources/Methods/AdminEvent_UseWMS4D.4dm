//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: AdminEvent_UseWMS4D - Created v0.1.0-JJG (05/04/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $xlFormEvent)
C_BOOLEAN:C305($2; $fClickValue)
$xlFormEvent:=$1
$fClickValue:=$2

Case of 
	: ($xlFormEvent=On Load:K2:1)
		ar1:=Num:C11(Not:C34([zz_control:1]wms_connection_Use4D:66))
		ar2:=Num:C11([zz_control:1]wms_connection_Use4D:66)
		
	: ($xlFormEvent=On Clicked:K2:4)
		[zz_control:1]wms_connection_Use4D:66:=$fClickValue
		ar1:=Num:C11(Not:C34($fClickValue))
		ar2:=Num:C11($fClickValue)
End case 