//%attributes = {}
// Method: wms_printManifest () -> 
// ----------------------------------------------------
// by: mel: 02/16/05, 18:20:31
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
//build a packing slip

$container:=[WMS_ItemMasters:123]Skidid:1
$chkMod10:=fBarCodeMod10Digit(sArkayUCCid+$serialnumber)
t1:=sArkayUCCid+$serialnumber+$chkMod10  //human readable
t2:=fBarCodeSym(128; sArkayUCCid+$serialnumber+$chkMod10)

util_PAGE_SETUP(->[WMS_ItemMasters:123]; "SkidLabel_Laser")
PDF_setUp($serialnumber+".pdf")
Print form:C5([WMS_ItemMasters:123]; "SkidLabel_Laser")
PAGE BREAK:C6
USE NAMED SELECTION:C332("beforeLabel")