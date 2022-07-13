//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/26/05, 16:45:42
// ----------------------------------------------------
// Method: eCatch
// Description
// see eTry
// ----------------------------------------------------

C_BOOLEAN:C305($0)
C_LONGINT:C283($1)

ON ERR CALL:C155(<>lastOnErrorMethod)

If (Error=0)
	If (Count parameters:C259>0)
		If ((Character code:C91(String:C10($1))<48) & (Character code:C91(String:C10($1))#45)) | (Character code:C91(String:C10($1))>57) | (Length:C16(String:C10($1))=0)
			$0:=True:C214
			Error:=99999
		Else 
			$0:=False:C215
		End if 
	Else 
		$0:=False:C215
	End if 
Else 
	$0:=True:C214
End if 