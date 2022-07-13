//%attributes = {}
// Method: wms_locationIsValid () -> 
// ----------------------------------------------------
// by: mel: 03/03/05, 10:25:31
// ----------------------------------------------------
// Description:
// get with the naming convention

// Updates:

// ----------------------------------------------------
C_POINTER:C301($1)
C_BOOLEAN:C305($0)  //rtn true if its a valide location
$0:=sVerifyLocation($1)
