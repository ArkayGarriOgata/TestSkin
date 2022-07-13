//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_ExportMethod({tMethodName})
//Description:  This method will export a 4D method to a folder on the server
//    It can be used to keep track of changes to methods.
//    If no method name then This method will export all the methods to a text document

If (True:C214)  //Initialize
	
	C_TEXT:C284($tMethodName)
	C_TEXT:C284($tMethodCode; $tSourceCodeFolder; $tCarriageReturnLineFeed; $tDateTimeStamp)
	C_TIME:C306($hMethodDocumentReference)
	
	C_LONGINT:C283($nNextVersion)
	C_BOOLEAN:C305($bGoodDocument)
	C_TEXT:C284($tFullDocumentPath; $tMethodCodeHeader)
	
	$tCarriageReturnLineFeed:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
	
	$tSourceCodeFolder:=Get 4D folder:C485(Logs folder:K5:19; *)+"Method"  //Create a folder in the logs folder called Method this will be used to store method changes
	
	GET MACRO PARAMETER:C997(Full method text:K5:17; $tMethodCode)
	
	$tMethodName:=Core_Macro_GetMethodNameT($tMethodCode)
	
	$tDateTimeStamp:=String:C10(Current date:C33(*))+CorektSpace+String:C10(Current time:C178(*))
	
	$nNextVersion:=0
	
End if   //Done Initialize

Repeat   //Good Document
	
	$bGoodDocument:=True:C214
	
	$tFullDocumentPath:=Choose:C955(($nNextVersion=0); \
		$tSourceCodeFolder+Folder separator:K24:12+$tMethodName+".txt"; \
		$tSourceCodeFolder+Folder separator:K24:12+$tMethodName+String:C10($nNextVersion)+".txt")
	
	If (Test path name:C476($tFullDocumentPath)=Is a document:K24:1)
		
		$nNextVersion:=$nNextVersion+1
		$bGoodDocument:=False:C215
		
	End if 
	
Until ($bGoodDocument)  //Done good document

$hMethodDocumentReference:=Create document:C266($tFullDocumentPath)

If (OK=1)  //Document created
	
	$tMethodCodeHeader:="//  Saved on "+$tDateTimeStamp+"  By:  "+Current user:C182+CorektDoubleSpace
	
	$tMethodCode:=$tMethodCodeHeader+$tMethodCode
	
	SEND PACKET:C103($hMethodDocumentReference; Replace string:C233($tMethodCode; CorektCR; $tCarriageReturnLineFeed))
	
	CLOSE DOCUMENT:C267($hMethodDocumentReference)
	
End if   //Done document created

