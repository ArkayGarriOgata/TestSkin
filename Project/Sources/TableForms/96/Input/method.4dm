Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Length:C16([WMS_SerializedShippingLabels:96]HumanReadable:5)>0)
			$sscc:=BarCode_HumanReadableSSCC([WMS_SerializedShippingLabels:96]HumanReadable:5)
			$sscc:=[WMS_SerializedShippingLabels:96]ContainerType:13+": "+$sscc
		Else 
			$sscc:="Create New SSCC"
		End if 
		wWindowTitle("push"; $sscc)
		
	: (Form event code:C388=On Validate:K2:3)
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
