//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/26/05, 16:42:40
// ----------------------------------------------------
// Method: eTry
// Description
// install an empty error handler so err can be handled by the calling methd
// see also e_Catch
//sample:
//  e_Try 
//   x:=12/0`  do something that may cause error
//  If (e_Catch(x) )
//  `recover from error
//  End if 

C_TEXT:C284(<>lastOnErrorMethod)

<>lastOnErrorMethod:=Method called on error:C704
ON ERR CALL:C155("e_EmptyErrorMethod")
Error:=0