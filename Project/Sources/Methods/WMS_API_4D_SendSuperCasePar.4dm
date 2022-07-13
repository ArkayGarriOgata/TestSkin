//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSuperCasePar - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($1; $4; $6; $7; $10; $11; $12)
C_TEXT:C284($ttCaseID; $ttJobit; $ttAMSLocation; $ttBinID; $ttInits; $ttWarehouse; $ttSkidNum; $ttSQL; $ttInsert; $ttUpdate)
C_DATE:C307($2; $8; $9; $dGlueDate; $dInsert; $dUpdate)
C_LONGINT:C283($3; $5; $xlQtyInCase; $xlCaseStatCode)
$ttCaseID:=$1
$dGlueDate:=$2
$xlQtyInCase:=$3
$ttJobit:=$4
$xlCaseStatCode:=$5
$ttAMSLocation:=$6
$ttBinID:=$7
$dInsert:=$8
$dUpdate:=$9
$ttInits:=$10
$ttWarehouse:=$11

$ttUpdate:=String:C10(Year of:C25($dUpdate))+"-"+String:C10(Month of:C24($dUpdate))+"-"+String:C10(Day of:C23($dUpdate))+" "+String:C10(4d_Current_time; HH MM SS:K7:1)
$ttInsert:=String:C10(Year of:C25($dInsert))+"-"+String:C10(Month of:C24($dInsert))+"-"+String:C10(Day of:C23($dInsert))+" "+String:C10(4d_Current_time; HH MM SS:K7:1)

SQL SET PARAMETER:C823($ttCaseID; SQL param in:K49:1)
SQL SET PARAMETER:C823($dGlueDate; SQL param in:K49:1)
SQL SET PARAMETER:C823($xlQtyInCase; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttJobit; SQL param in:K49:1)
SQL SET PARAMETER:C823($xlCaseStatCode; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttAMSLocation; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttBinID; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttInsert; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttUpdate; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttInits; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttWarehouse; SQL param in:K49:1)

