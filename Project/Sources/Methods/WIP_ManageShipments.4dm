//%attributes = {}
// Method: WIP_ManageShipments () -> 
// ----------------------------------------------------
// by: mel: 07/11/05, 15:27:05
// ----------------------------------------------------
// Description:
// entry point for creating new labels ([SerializedShippingLabels] records) or modifing existing ones
// ----------------------------------------------------

C_LONGINT:C283(<>pid_WIPmgmt; $winRef; $numContainers; $qtyPer; $numLabels)
C_TEXT:C284($jobit)
C_TEXT:C284($1)

Case of 
	: (Count parameters:C259=0)
		<>pid_WIPmgmt:=New process:C317("WIP_ManageShipments"; <>lMinMemPart; "WIP_ManageShipments"; "init")
		If (False:C215)
			WIP_ManageShipments
		End if 
		
	: (Count parameters:C259=1)
		<>iMode:=2
		<>filePtr:=->[WMS_SerializedShippingLabels:96]
		uSetUp(1; 1)
		CONFIRM:C162("Create new SSCC labels or update existing labels?"; "New"; "Update")
		If (ok=1)
			WIP_TransitLabels
		Else 
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5="000@"; *)
				QUERY:C277([WMS_SerializedShippingLabels:96];  & ; [WMS_SerializedShippingLabels:96]Arrived:16=!00-00-00!)
				If (Records in selection:C76([WMS_SerializedShippingLabels:96])=0)
					QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5="000@")
				End if 
				CREATE SET:C116([WMS_SerializedShippingLabels:96]; "◊PassThroughSet")
				
				
			Else 
				
				SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
				QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5="000@"; *)
				QUERY:C277([WMS_SerializedShippingLabels:96];  & ; [WMS_SerializedShippingLabels:96]Arrived:16=!00-00-00!)
				If (Records in set:C195("◊PassThroughSet")=0)
					QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5="000@")
				End if 
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				
			End if   // END 4D Professional Services : January 2019
			<>PassThrough:=True:C214
			ViewSetter(2; ->[WMS_SerializedShippingLabels:96])
		End if 
		
		<>pid_WIPmgmt:=0
		
	: (Count parameters:C259>=2)
		Case of 
			: ($2="containerLabels")
				$pid:=New process:C317("WIP_TransitLabels"; <>lMinMemPart; "WIP_TransitLabels"; $jobit; $numContainers; $qtyPer; $numLabels)
				
			: ($2="packingSlip")
				
			: ($2="shipmentReceived")
				
			: ($2="goodCounts")
				
		End case 
		
End case 