//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getRecon_DoJobit - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($1; $2; $3; $ttWMSJobit; $ttScope; $ttAreaToOverlay; $ttAMSJobit; $ttSQL)
C_LONGINT:C283($i; $xlNumLocations)
ARRAY TEXT:C222($st3CaseBinID; 0)
ARRAY LONGINT:C221($sxlCaseQty; 0)
ARRAY TEXT:C222($st3SkidNumber; 0)
ARRAY LONGINT:C221($sxlNumCases; 0)
$ttWMSJobit:=$1
If (Count parameters:C259>1)
	$ttScope:=$2  //ALL, Racks-Only, Single-Area
Else 
	$ttScope:="ALL"
End if 
If (Count parameters:C259>2)
	$ttAreaToOverlay:=$3
End if 
$ttAMSJobit:=JMI_makeJobIt($ttWMSJobit)

If (WMS_API_4D_getRecon_DoJobitSQL($ttWMSJobit; ->$st3CaseBinID; ->$sxlCaseQty; ->$st3SkidNumber; ->$sxlNumCases))
	$xlNumLocations:=Size of array:C274($st3CaseBinID)
	
	For ($i; 1; $xlNumLocations)
		Case of 
			: ($ttScope="Racks-Only")
				WMS_API_4D_getRecon_DoRacks($ttAMSJobit; $st3CaseBinID{$i}; $sxlCaseQty{$i}; $st3SkidNumber{$i}; $sxlNumCases{$i})
				
			: ($ttScope="Single-Area")
				WMS_API_4D_getRecon_DoOneArea($ttAreaToOverlay; $ttAMSJobit; $st3CaseBinID{$i}; $sxlCaseQty{$i}; $st3SkidNumber{$i}; $sxlNumCases{$i})
				
			Else 
				WMS_API_4D_getRecon_DoBin($ttAMSJobit; $st3CaseBinID{$i}; $sxlCaseQty{$i}; $st3SkidNumber{$i}; $sxlNumCases{$i})
				
		End case 
	End for 
End if 
