//%attributes = {}
//Method: Core_Method_BlockCommentHeader
//Description:  This method will run thru all the methods and change the header comments
//   to new v18 block comments

If (True:C214)  //Initialize
	
	C_TEXT:C284($tBlockCommentHeader)
	C_TEXT:C284($tMethodCode)
	C_TEXT:C284($t4DMethodHeader)
	
	C_LONGINT:C283($nMethod; $nNumberOfMethods)
	C_BOOLEAN:C305($bFirstOccurence)
	
	C_OBJECT:C1216($oProgress)
	
	ARRAY TEXT:C222($atMethodPath; 0)
	
	METHOD GET PATHS:C1163(Path project method:K72:1; $atMethodPath)
	
	$nNumberOfMethods:=Size of array:C274($atMethodPath)
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfMethods
	$oProgress.tTitle:="Processing Methods..."
	
End if   //Done initialize

For ($nMethod; 1; $nNumberOfMethods)  //Run thru all the methods
	
	If (Prgr_ContinueB($oProgress))  //Continue processing methods
		
		$tMethodCode:=CorektBlank
		$bFirstOccurence:=True:C214
		
		$tMethodPath:=CorektBlank
		$tMethodCode:=CorektBlank
		
		$tMethodPath:=$atMethodPath{$nMethod}
		
		$oProgress.nLoop:=$nMethod
		$oProgress.tMessage:="Processing method:  "+$tMethodPath
		
		Prgr_Message($oProgress)
		
		METHOD GET CODE:C1190($tMethodPath; $tMethodCode)  //Copy method to text
		
		$tMethodCode:=Core_Text_RemoveLineT($tMethodCode; ->$t4DMethodHeader)
		
		While (Core_Method_BlockCommentIncldB(->$tMethodCode; ->$tLine))  //Include line
			
			If ($bFirstOccurence)  //First occurrence
				
				$tLine:="/*"+$tLine  //Add /*
				
				$bFirstOccurence:=False:C215
				
			End if   //Done first occurrence
			
			$tBlockCommentHeader:=$tBlockCommentHeader+$tLine  //Add line to $tBlockCommentHeader text
			
		End while   //Done include line
		
		$tBlockCommentHeader:=$tBlockCommentHeader+"*/"+CorektCR  //Add ending */ to $tBlockCommentHeader
		
		$tMethodCode:=$t4DMethodHeader+$tBlockCommentHeader+$tMethodCode  //Append block comments to top of method
		
		METHOD SET CODE:C1194($tMethodPath; $tMethodCode)  //Rewrite method
		
	Else   //User stopped processing methods
		
		$nMethod:=$nNumberOfMethods+1  //Terminate
		
	End if   //Done continue processing methods
	
End for   //Done running thru all the methods

Prgr_Quit($oProgress)

