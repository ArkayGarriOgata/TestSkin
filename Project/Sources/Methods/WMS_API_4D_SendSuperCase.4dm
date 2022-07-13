//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SuperCase - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
C_TEXT:C284($1; $2; $5; $7; $8; $11; $12; $13; $ttCommand)
C_DATE:C307($3; $9; $10)
C_LONGINT:C283($4; $6)
$ttCommand:=$1
$fSuccess:=False:C215

Case of 
	: (($ttCommand="init") | ($ttCommand="initCase"))
		//SQL LOGIN("IP:"+WMS_API_4D_GetLoginHost +":"+WMS_API_4D_GetLoginPort ;WMS_API_4D_GetLoginUser ;WMS_API_4D_GetLoginPassword ;*)
		$fSuccess:=WMS_API_4D_DoLogin
		
	: ($ttCommand="insert")
		$fSuccess:=WMS_API_4D_SendSuperCaseDo($2; $3; $4; $5; $6; $7; $8; $9; $10; $11; $12; $13)
		
	: ($ttCommand="insertCase")
		$fSuccess:=WMS_API_4D_SendSuperCaseDo($2; $3; $4; $5; $6; $7; $8; $9; $10; $11; $12)
		
	: ($ttCommand="kill")
		WMS_API_4D_DoLogout
		$fSuccess:=(OK=1)
		
		
End case 

$0:=$fSuccess