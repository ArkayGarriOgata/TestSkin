//%attributes = {"publishedWeb":true}
//(p) uChangeField
//Generic procedure to locate a group of records and then change
//some field value in those records, while handling the possblity of
//locked records
//ASSUMES: an open window for display of waiting message
//$1 - pointer - Field to use for search
//$2 - Pointer - value to locate
//$3 - pointer - field to change
//$4 - Pointer - new value
//• 4/16/97 cs created upr 1794
C_POINTER:C301($1; $File; $FindField; $3; $ChangeField; $2; $FindValue; $4; $NewValue)
C_BOOLEAN:C305($Locked)
C_LONGINT:C283($WaitTime; $Process)
C_TEXT:C284($User; $Machine; $ProcName)
C_TEXT:C284($Text)
MESSAGES OFF:C175
$ChangeField:=$3
$NewValue:=$4
$FindValue:=$2
$File:=Table:C252(Table:C252($1))
$FindField:=$1
$WaitTime:=30*60
$Locked:=False:C215
READ WRITE:C146($File->)

Repeat 
	If (Not:C34($Locked))
		QUERY:C277($File->; $FindField->=$FindValue->)
	Else 
		USE SET:C118("LockedSet")
	End if 
	MESSAGE:C88("  Applying Change to '"+Table name:C256($File)+"'..."+Char:C90(13))
	APPLY TO SELECTION:C70($File->; $ChangeField->:=$NewValue->)
	
	If (Records in set:C195("LockedSet")#0)
		USE SET:C118("LockedSet")
		FIRST RECORD:C50($File->)
		LOAD RECORD:C52($File->)
		LOCKED BY:C353($Process; $User; $Machine; $ProcName)
		$Text:="  Waiting for Locked Record(s) in File: '"+Table name:C256($File)+"'"+Char:C90(13)
		$Text:=$Text+"  Process,User,Machine;ProcessName: "+String:C10($Process)+";"+$User+";"+$Machine+";"+$ProcName+Char:C90(13)
		$Text:=$Text+"  ...Delaying 30 seconds"+Char:C90(13)
		MESSAGE:C88($Text)
		DELAY PROCESS:C323(Current process:C322; $WaitTime)
		$Locked:=True:C214
	End if 
Until (Records in set:C195("LockedSet")=0)
//