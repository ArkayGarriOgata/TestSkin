//%attributes = {"publishedWeb":true}
//PM:  JIC_CloseOutRegenmi set)  072102  mlb
//recalc items that were just closed out
//use the list of jobs to get a list of cpn
//then call the regenerate

C_LONGINT:C283($numFG; $item; $cursor; $jmi)
ARRAY TEXT:C222($aCustId; 0)
ARRAY TEXT:C222($aCPN; 0)

USE SET:C118($1)  //[JobMakesItem] that were touched
SELECTION TO ARRAY:C260([Job_Forms_Items:44]CustId:15; $aCustId; [Job_Forms_Items:44]ProductCode:3; $aCPN)
$numFG:=Size of array:C274($aCustId)
ARRAY TEXT:C222($aFGKey; $numFG)
$cursor:=0

For ($jmi; 1; $numFG)
	$fg:=$aCustId{$jmi}+":"+$aCPN{$jmi}
	$hit:=Find in array:C230($aFGKey; $fg)
	If ($hit=-1)
		$cursor:=$cursor+1
		$aFGKey{$cursor}:=$fg
	End if 
End for 
ARRAY TEXT:C222($aFGKey; $cursor)
ARRAY TEXT:C222($aCustId; 0)
ARRAY TEXT:C222($aCPN; 0)

$numFG:=$cursor

NewWindow(170; 50; 0; 1)
GOTO XY:C161(1; 1)
MESSAGE:C88("FIFO Regeneration")
For ($item; 1; $numFG)
	$doingFG:=Change string:C234((" "*30); $aFGKey{$item}; 3)
	GOTO XY:C161(3; 2)
	MESSAGE:C88(String:C10($item; "^^^,^^^")+" of "+String:C10($numFG)+$doingFG)
	JIC_Regenerate($aFGKey{$item})
End for 

CLOSE WINDOW:C154