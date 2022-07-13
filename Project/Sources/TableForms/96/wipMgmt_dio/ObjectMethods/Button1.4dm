
CONFIRM:C162("Create a new SSCC labels or update an existing one?"; "New"; "Update")
If (ok=1)
	WIP_TransitLabels
Else 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5="000@"; *)
		QUERY:C277([WMS_SerializedShippingLabels:96];  & ; [WMS_SerializedShippingLabels:96]Arrived:16=!00-00-00!)
		CREATE SET:C116([WMS_SerializedShippingLabels:96]; "◊PassThroughSet")
		
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
		QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5="000@"; *)
		QUERY:C277([WMS_SerializedShippingLabels:96];  & ; [WMS_SerializedShippingLabels:96]Arrived:16=!00-00-00!)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
	End if   // END 4D Professional Services : January 2019 
	<>PassThrough:=True:C214
	ViewSetter(2; ->[WMS_SerializedShippingLabels:96])
End if 
//EOS