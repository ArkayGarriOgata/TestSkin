//t1:=fBarCode128mix ("91"+Substring([SerializedShippingLabels]CPN;1;8);"37"+String([SerializedShippingLabels]Quantity))  `
//t1:=BarCode_128C ("91"+Substring([WMS_SerializedShippingLabels]CPN;1;8);"37"+String([WMS_SerializedShippingLabels]Quantity))
$human:="91"+Substring:C12([WMS_SerializedShippingLabels:96]CPN:2; 1; 8)+Char:C90(util_ConvertAscii(202))+"37"+String:C10([WMS_SerializedShippingLabels:96]Quantity:4)
$chkMod10:=fBarCodeMod10Digit($human)
t1:=fBarCodeSym(129; $human)  //+$chkMod10)