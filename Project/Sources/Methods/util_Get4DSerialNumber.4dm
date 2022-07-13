//%attributes = {}
// Method: util_Get4DSerialNumber () -> 
// ----------------------------------------------------
// by: mel: 12/14/04, 11:50:56
// ----------------------------------------------------
// Description:
// run the "GET SERIAL INFORMATION" command to get component coupling to key
// ----------------------------------------------------
C_LONGINT:C283($key; $connected; $maxUser)
C_TEXT:C284($user; $company)
GET SERIAL INFORMATION:C696($key; $user; $company; $connected; $maxUser)
utl_LogIt("init")
utl_LogIt("key = "+String:C10($key))
utl_LogIt("user = "+$user)
utl_LogIt("company = "+$company)
utl_LogIt("connected = "+String:C10($connected))
utl_LogIt("maxUser = "+String:C10($maxUser))
utl_LogIt("show")
utl_LogIt("init")