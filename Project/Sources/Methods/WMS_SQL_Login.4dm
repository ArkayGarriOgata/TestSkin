//%attributes = {}
// -------
// Method: WMS_SQL_Login   ( ) ->
// By: Mel Bohince @ 05/24/18, 09:34:30
// Description
// based on WMS_API_4D_DoLogin
// ----------------------------------------------------

SQL LOGIN:C817("IP:"+WMS_API_4D_GetLoginHost+":"+WMS_API_4D_GetLoginPort; WMS_API_4D_GetLoginUser; WMS_API_4D_GetLoginPassword; *)
$loggedIn:=(ok=1)
If (Not:C34($loggedIn))
	uConfirm("WMS not responding to login request.")
End if 
$0:=$loggedIn
