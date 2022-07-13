//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/23/10, 12:15:27
// ----------------------------------------------------
// Method: util_array_load(->array) [not a local variable pointer
// Description
// load array saved by util_array_save
//
// Parameters
// ----------------------------------------------------

C_POINTER:C301($1)
C_BLOB:C604($vxArrayData)
C_TIME:C306($docRef)

$docRef:=Open document:C264("")
CLOSE DOCUMENT:C267($docRef)

DOCUMENT TO BLOB:C525(document; $vxArrayData)  // Load the BLOB from the disk
EXPAND BLOB:C535($vxArrayData)  // Expand the BLOB
BLOB TO VARIABLE:C533($vxArrayData; $1->)  // Retrieve the array from the BLOB;$1->
