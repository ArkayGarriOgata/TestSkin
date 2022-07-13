//%attributes = {}
// _______
// Method: e_ExeOnServerError   ( ) ->
// By: Mel Bohince @ 12/11/20, 15:11:08
// Description
// //trap a errors to prevent an EOS method from throw rt dialog on server
// ----------------------------------------------------

C_LONGINT:C283(Error)

utl_Logfile("ExeOnServerError.log"; "Error "+String:C10(Error)+" occurred in a method set to execute on server")