//%attributes = {"publishedWeb":true}
$value:=Substring:C12([WMS_SerializedShippingLabels:96]HumanReadable:5; 1; 19)
$chkMod10:=fBarCodeMod10Digit($value)
[WMS_SerializedShippingLabels:96]HumanReadable:5:=$value+$chkMod10
[WMS_SerializedShippingLabels:96]ShippingUnitSerialNumber:1:=fBarCodeSym(128; [WMS_SerializedShippingLabels:96]HumanReadable:5)