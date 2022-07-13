//%attributes = {"publishedWeb":true}
//Procedure: uSpawnPalette("procedure";"$title")  090195  MLB
//unify the palettes and make local process with stacked windows
// Modified by: Mel Bohince (4/3/16) add memory parameter
// Modified by: Mel Bohince (3/21/17) respect <>lMinMemPart

C_TEXT:C284($1; $2)
C_LONGINT:C283($0; $id; $3)  //0 = success

$0:=0
$id:=uProcessID($2)
If (Count parameters:C259=2)
	$mem:=<>lMinMemPart
Else 
	If ($3><>lMinMemPart)
		$mem:=$3
	Else 
		$mem:=<>lMinMemPart
	End if 
End if 

If ($id=-1)
	$id:=New process:C317($1; $mem; $2)
	//app_Log_Usage ("log";"Palette Open";$2)
	If ($id=0)
		BEEP:C151
		ALERT:C41("Not enough memory to perform the action. "+"Try closing windows to make more memory available.")
		$0:=-1
	End if 
	
	
	If (<>PrcsListPr>0)  //• 8/4/97 cs don't make a call to -1
		POST OUTSIDE CALL:C329(<>PrcsListPr)  //update process list  
	Else 
		uProcessLookup
	End if 
	
Else 
	BRING TO FRONT:C326($id)
	SHOW PROCESS:C325($id)  // Added by: Mark Zinke (1/11/13)
End if 

$0:=$id  // Added by: Mark Zinke (1/10/13)