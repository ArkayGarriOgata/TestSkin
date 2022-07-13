//%attributes = {}

// Method: ams_DeleteOldSSCC ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/04/15, 15:09:28
// ----------------------------------------------------
// Description
// keep x years of SSCC
//
// ----------------------------------------------------

C_LONGINT:C283($yearsToKeep; $1)
C_DATE:C307($date)

$yearsToKeep:=$1
$year:=Year of:C25(Current date:C33)-$yearsToKeep  //going after a complete fiscal year boundary
$date:=Date:C102("01/01/"+String:C10($year))

READ WRITE:C146([WMS_SerializedShippingLabels:96])

QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]CreateDate:9<$date)

util_DeleteSelection(->[WMS_SerializedShippingLabels:96])