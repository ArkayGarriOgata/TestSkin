
$barcodeValue:=WMS_SkidId(""; "set"; "2"; wmsSkidNumber)
SSCC_HumanReadable:=WMS_SkidId($barcodeValue; "human")
SSCC_Barcode:=WMS_SkidId(SSCC_HumanReadable; "barcode")