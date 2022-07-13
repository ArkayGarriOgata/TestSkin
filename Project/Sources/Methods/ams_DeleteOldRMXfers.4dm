//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/01/07, 15:12:22
// ----------------------------------------------------
// Method: ams_DeleteOldRMXfers
// ----------------------------------------------------

C_DATE:C307($cutOff; $1)

$cutOff:=$1  //!04/01/01!
$cutOff:=Add to date:C393($cutOff; 1; 0; 0)

READ WRITE:C146([Raw_Materials_Transactions:23])
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3<$cutOff)

util_DeleteSelection(->[Raw_Materials_Transactions:23])