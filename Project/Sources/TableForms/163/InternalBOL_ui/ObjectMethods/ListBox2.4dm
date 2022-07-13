
Case of 
	: (Form event code:C388=On Clicked:K2:4) | (Form event code:C388=On Selection Change:K2:29)
		$sscc:=Substring:C12(aSkidNumbers{aSkidNumbers}; 1; 3)+"080829200"+Substring:C12(aSkidNumbers{aSkidNumbers}; 7)
		QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$sscc)
		
End case 
