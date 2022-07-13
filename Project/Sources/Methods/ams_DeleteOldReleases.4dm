//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/01/07, 14:51:58
// ----------------------------------------------------
// Method: ams_DeleteOldReleases
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_DATE:C307($cutOffDate; $1)
$cutOffDate:=$1

READ WRITE:C146([Customers_ReleaseSchedules:46])

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7<$cutOffDate; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
util_DeleteSelection(->[Customers_ReleaseSchedules:46])

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5=!00-00-00!; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"Rtn@"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Qty:6=0)
util_DeleteSelection(->[Customers_ReleaseSchedules:46])