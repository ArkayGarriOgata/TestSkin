//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/29/08, 15:34:35
// ----------------------------------------------------
// Method: eShippingErrorHandler
// ----------------------------------------------------

shipping_error:=error

BEEP:C151
utl_Logfile("server.log"; "ERROR CODE "+String:C10(error)+" ENCOUNTERED by 4D")
ALERT:C41(String:C10(shipping_error)+" has been trapped")