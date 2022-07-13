//%attributes = {}
//Method:  Core_Prompt_ButtonManager
//Description:  This method will assign button text appropriately

If (True:C214)  //Initialize
	
	C_TEXT:C284($tDefault)
	C_TEXT:C284($tCancel)
	C_TEXT:C284($tNonDefault)
	
	C_LONGINT:C283($nLeft; $nTop; $nRight; $nBottom)
	
	C_LONGINT:C283($nBestWidth; $nBestHeight)
	
	C_LONGINT:C283($nPadding)
	
	ARRAY TEXT:C222($atProperty; 0)
	ARRAY LONGINT:C221($anType; 0)
	
	OB GET PROPERTY NAMES:C1232(Form:C1466; $atProperty; $anType)
	
	$tDefault:=Choose:C955(\
		(Find in array:C230($atProperty; "tDefault")>0); \
		Form:C1466.tDefault; \
		"OK")
	
	$tCancel:=Choose:C955(\
		(Find in array:C230($atProperty; "tCancel")>0); \
		Form:C1466.tCancel; \
		"Cancel")
	
	$tNonDefault:=Choose:C955(\
		(Find in array:C230($atProperty; "tNonDefault")>0); \
		Form:C1466.tNonDefault; \
		CorektBlank)
	
	$nPadding:=-8
	
End if   //Done Initialize

If (Form:C1466.tPromptType=CorektAlert)
	$tCancel:=CorektBlank
End if 

OBJECT SET TITLE:C194(Core_nPrompt_Default; $tDefault)
OBJECT SET TITLE:C194(Core_nPrompt_Cancel; $tCancel)
OBJECT SET TITLE:C194(Core_nPrompt_NonDefault; $tNonDefault)

//Resize buttons to fit

OBJECT GET COORDINATES:C663(Core_nPrompt_Default; $nLeft; $nTop; $nRight; $nBottom)
OBJECT GET BEST SIZE:C717(Core_nPrompt_Default; $nBestWidth; $nBestHeight)
$nMoveLeft:=($nRight-$nLeft)-$nBestWidth

If ($nMoveLeft<0)  //Default
	
	$nMoveLeft:=$nMoveLeft+$nPadding
	
	OBJECT SET COORDINATES:C1248(Core_nPrompt_Default; $nLeft+$nMoveLeft; $nTop; $nRight; $nBottom)  //Resize 
	OBJECT MOVE:C664(Core_nPrompt_Cancel; $nMoveLeft; 0)
	OBJECT MOVE:C664(Core_nPrompt_NonDefault; $nMoveLeft; 0)
	
End if   //Done default

OBJECT GET COORDINATES:C663(Core_nPrompt_Cancel; $nLeft; $nTop; $nRight; $nBottom)
OBJECT GET BEST SIZE:C717(Core_nPrompt_Cancel; $nBestWidth; $nBestHeight)
$nMoveLeft:=($nRight-$nLeft)-$nBestWidth

If ($nMoveLeft<0)  //Cancel
	
	$nMoveLeft:=$nMoveLeft+$nPadding
	
	OBJECT SET COORDINATES:C1248(Core_nPrompt_Cancel; $nLeft+$nMoveLeft; $nTop; $nRight; $nBottom)  //Resize 
	OBJECT MOVE:C664(Core_nPrompt_NonDefault; $nMoveLeft; 0)
	
End if   //Done cancel

OBJECT GET COORDINATES:C663(Core_nPrompt_NonDefault; $nLeft; $nTop; $nRight; $nBottom)
OBJECT GET BEST SIZE:C717(Core_nPrompt_NonDefault; $nBestWidth; $nBestHeight)
$nMoveLeft:=($nRight-$nLeft)-$nBestWidth

If ($nMoveLeft<0)  //Non-Default
	
	$nMoveLeft:=$nMoveLeft+$nPadding
	
	OBJECT SET COORDINATES:C1248(Core_nPrompt_NonDefault; $nLeft+$nMoveLeft; $nTop; $nRight; $nBottom)  //Resize 
	
End if   //Done non-default

//Done resize buttons to fit

Core_Prompt_ButtonOrder($tCancel; $tNonDefault)  //Rearrange button order based on OS and using Non-default
