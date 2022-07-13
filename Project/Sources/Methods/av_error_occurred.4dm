//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/30/13, 11:53:11
// ----------------------------------------------------
// Method: av_error_occurred
// Description
// abort accounts/receivable sync'g
// ----------------------------------------------------

C_LONGINT:C283(Error)
av_error:=Error

utl_Logfile("AR.Log"; "Error "+String:C10(Error)+" occurred.")