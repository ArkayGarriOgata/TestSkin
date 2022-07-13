
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/24/18, 17:21:37
// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].List.PrintSSCC1
// Description
// so we can pre print candidtate REVLON sscc labels that have been lost
//
// Parameters
// ----------------------------------------------------


COPY SET:C600("UserSet"; "UserSelected")
$selected:=Records in set:C195("UserSelected")

uConfirm("Print "+String:C10($selected)+" SSCC's?"; "Print"; "Cancel")
If (ok=1)
	CUT NAMED SELECTION:C334([WMS_SerializedShippingLabels:96]; "before")
	USE SET:C118("UserSelected")
	CLEAR SET:C117("UserSelected")
	
	ORDER BY:C49([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]Jobit:3; >; [WMS_SerializedShippingLabels:96]HumanReadable:5; >)
	
	FORM SET OUTPUT:C54([WMS_SerializedShippingLabels:96]; "SSCC_Arkay")
	PRINT SELECTION:C60([WMS_SerializedShippingLabels:96])
	
	//While (Not(End selection([WMS_SerializedShippingLabels])))
	
	//NEXT RECORD([WMS_SerializedShippingLabels])
	//End while
	
	USE NAMED SELECTION:C332("before")
	
End if 