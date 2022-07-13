<>BOL:=Num:C11(Request:C163("Enter Shipper's Number: (BOL#)"; ""; "Search"; "Cancel"))
If (<>BOL>0) & (ok=1)
	CUT NAMED SELECTION:C334([WMS_SerializedShippingLabels:96]; "beforeRec")
	QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]ShippersNumber:14=<>BOL)
	zwStatusMsg("BOL="+String:C10(<>BOL); String:C10(Records in selection:C76([WMS_SerializedShippingLabels:96]))+" container SSCC's found.")
	$succeed:=True:C214
	START TRANSACTION:C239
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
		
		
	Else 
		
		// you don't need it you have query on line 4
		
	End if   // END 4D Professional Services : January 2019 First record
	For ($i; 1; Records in selection:C76([WMS_SerializedShippingLabels:96]))
		If (fLockNLoad(->[WMS_SerializedShippingLabels:96]))
			[WMS_SerializedShippingLabels:96]Arrived:16:=4D_Current_date
			SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
		Else 
			$succeed:=False:C215
			BEEP:C151
			ALERT:C41([WMS_SerializedShippingLabels:96]HumanReadable:5+" could not be marked as Arrived.")
		End if 
		NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
	End for 
	
	If ($succeed)
		VALIDATE TRANSACTION:C240
	Else 
		CANCEL TRANSACTION:C241
		BEEP:C151
		ALERT:C41(String:C10(<>BOL)+" could not be marked as Arrived.")
	End if 
	
	USE NAMED SELECTION:C332("beforeRec")
Else 
	BEEP:C151
	BEEP:C151
End if 

