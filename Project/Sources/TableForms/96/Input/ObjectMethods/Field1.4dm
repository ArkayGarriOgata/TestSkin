sArkayUCCid:="0010808292"  //sscc app code+containerType+UCCregistration#
If (Substring:C12([WMS_SerializedShippingLabels:96]HumanReadable:5; 1; 10)#sArkayUCCid)
	uConfirm(sArkayUCCid+" is the proper AI and Arkay UCC registration number."; "Fix"; "Ignor")
	If (ok=1)
		[WMS_SerializedShippingLabels:96]HumanReadable:5:=sArkayUCCid+Substring:C12([WMS_SerializedShippingLabels:96]HumanReadable:5; 11)
	End if 
End if 

uConfirm("Do you want the Mod10 check digit to be appended to your entry?"; "Yes"; "No")
If (ok=1)
	$chkMod10:=fBarCodeMod10Digit([WMS_SerializedShippingLabels:96]HumanReadable:5)
	[WMS_SerializedShippingLabels:96]HumanReadable:5:=[WMS_SerializedShippingLabels:96]HumanReadable:5+$chkMod10
Else 
	$chkMod10:=""
End if 

[WMS_SerializedShippingLabels:96]ShippingUnitSerialNumber:1:=fBarCodeSym(129; [WMS_SerializedShippingLabels:96]HumanReadable:5)