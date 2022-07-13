//%attributes = {}
// Method: FG_LaunchItem () -> 
// ----------------------------------------------------
// by: mel: 04/27/04, 11:00:30
// • mel (6/1/04, 10:45:31) init in own process to protect selection
// ----------------------------------------------------
// Description:
// cache spl items so they can be hilited

C_TEXT:C284($1; $2)
C_BOOLEAN:C305($0)
C_LONGINT:C283($hit)

$0:=False:C215

Case of 
	: ($1="is")
		$hit:=Find in array:C230(<>FGLaunchItem; $2)
		If ($hit>-1)
			$0:=True:C214
		End if 
		
	: ($1="hold")
		$hit:=Find in array:C230(<>FGLaunchItemHold; $2)
		If ($hit>-1)
			$0:=True:C214
		End if 
		
	: ($1="init")
		FG_LaunchItemInit
		
End case 