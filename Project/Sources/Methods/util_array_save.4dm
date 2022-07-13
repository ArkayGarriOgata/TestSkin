//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/23/10, 12:15:13
// ----------------------------------------------------
// Method: util_array_save(->array)
// Description
// save an array to disk,  reload with util_array_load
//
// Parameters
// ----------------------------------------------------
C_POINTER:C301($1)
C_BLOB:C604($vxArrayData)
VARIABLE TO BLOB:C532($1->; $vxArrayData)  // Store the array into the BLOB
COMPRESS BLOB:C534($vxArrayData)  // Compress the BLOB

C_TEXT:C284(docName)
C_TIME:C306($docRef)
docName:="saved_array_"+String:C10(TSTimeStamp)+".blob"
$docRef:=util_putFileName(->docName)
CLOSE DOCUMENT:C267($docRef)
BLOB TO DOCUMENT:C526(docName; $vxArrayData)  // Save the BLOB on disk
