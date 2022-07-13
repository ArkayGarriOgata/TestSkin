//%attributes = {}
//Method:  BOL_Rprt_Analyze
//Description:  This method will explain how to analyze the data to create
//   the report.

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cCarrier)
	
	C_OBJECT:C1216($esTrip)
	C_OBJECT:C1216($esTripAll)
	C_OBJECT:C1216($esTripOcean)
	C_OBJECT:C1216($esTripAir)
	C_OBJECT:C1216($esTripRoad)
	
	C_OBJECT:C1216($esCarrier)
	C_OBJECT:C1216($eCarrier)
	C_OBJECT:C1216($eTripRoad)
	
	ARRAY TEXT:C222($atCarrier; 0)
	ARRAY TEXT:C222($atShipTo; 0)
	ARRAY TEXT:C222($atTotal; 0)
	
	ARRAY TEXT:C222($atAddressID; 0)
	ARRAY TEXT:C222($atName; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->$atCarrier)
	APPEND TO ARRAY:C911($apColumn; ->$atShipTo)
	APPEND TO ARRAY:C911($apColumn; ->$atTotal)
	
	$cCarrier:=New collection:C1472()
	
	$esTrip:=New object:C1471()
	$esTripAll:=New object:C1471()
	$esTripOcean:=New object:C1471()
	$esTripAir:=New object:C1471()
	$esTripRoad:=New object:C1471()
	
	$esCarrier:=New object:C1471()
	$eCarrier:=New object:C1471()
	$eTripRoad:=New object:C1471()
	
	$esTripRoad:=Core_EnSl_CreateEmptyO(->[Customers_Bills_of_Lading:49])
	
	APPEND TO ARRAY:C911($atCarrier; "Carrier")
	APPEND TO ARRAY:C911($atShipTo; "# Ship Tos")
	APPEND TO ARRAY:C911($atTotal; "Total")
	
End if   //Done initialize

Case of   //Trip carriers
	: (False:C215)  //All (3912) 
		
		$esTripAll:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2)"; \
			!2021-01-01!; !2021-12-31!)
		
		$cAddressID:=$esTripAll.distinct("ShipTo")
		
		COLLECTION TO ARRAY:C1562($cAddressID; $atAddressID)
		
		$nNumberOfAddresses:=Size of array:C274($atAddressID)
		
		For ($nAddress; 1; $nNumberOfAddresses)
			
			$esAddress:=ds:C1482.Addresses.query("ID = :1"; $atAddressID{$nAddress})
			
			$tName:=CorektBlank
			
			If ($esAddress.length=1)
				
				$eAddress:=$esAddress.first()
				
				$tName:=$eAddress.Name
				
			End if 
			
			APPEND TO ARRAY:C911($atName; $tName)
			
		End for 
		
		ARRAY POINTER:C280($apColumn; 0)
		
		APPEND TO ARRAY:C911($apColumn; ->$atAddressID)
		APPEND TO ARRAY:C911($apColumn; ->$atName)
		
	: (False:C215)  //Air (388)
		
		$esTripAir:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4)"; \
			!2021-01-01!; !2021-12-31!; "@air@"; "@next day@")
		
		$cCarrier:=$esTripAir.distinct("Carrier")
		
		For ($nCarrier; 0; ($cCarrier.length-1))  //Carrier
			
			$esCarrier:=$esTripAir.query("Carrier = :1"; $cCarrier[$nCarrier])
			$nCarrierTotal:=$esCarrier.length
			
			$cShipTo:=$esCarrier.distinct("ShipTo")
			$nShipTo:=$cShipTo.length
			
			APPEND TO ARRAY:C911($atCarrier; $cCarrier[$nCarrier])
			APPEND TO ARRAY:C911($atTotal; String:C10($nCarrierTotal))
			APPEND TO ARRAY:C911($atShipTo; String:C10($nShipTo))
			
		End for   //Done carrier
		
	: (False:C215)  //Ocean (709)
		
		$esTripOcean:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4)"; \
			!2021-01-01!; !2021-12-31!; "@ocean@"; "@sea@")
		
		$cCarrier:=$esTripOcean.distinct("Carrier")
		
		For ($nCarrier; 0; ($cCarrier.length-1))  //Carrier
			
			$esCarrier:=$esTripOcean.query("Carrier = :1"; $cCarrier[$nCarrier])
			$nCarrierTotal:=$esCarrier.length
			
			$cShipTo:=$esCarrier.distinct("ShipTo")
			$nShipTo:=$cShipTo.length
			
			APPEND TO ARRAY:C911($atCarrier; $cCarrier[$nCarrier])
			APPEND TO ARRAY:C911($atTotal; String:C10($nCarrierTotal))
			APPEND TO ARRAY:C911($atShipTo; String:C10($nShipTo))
			
		End for   //Done carrier
		
	: (False:C215)  //Road (2816)
		
		$esAll:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2)"; \
			!2021-01-01!; !2021-12-31!)
		
		For each ($eTripRoad; $esAll)  //Road
			
			Case of   //Filter
					
				: ($eTripRoad.Mode="@air@")
					
				: ($eTripRoad.Mode="@next day@")
					
				: ($eTripRoad.Mode="@ocean@")
					
				: ($eTripRoad.Mode="@sea@")
					
				Else 
					
					$esTripRoad.add($eTripRoad)
					
			End case   //Done filter
			
		End for each   //Done road
		
		$cCarrier:=$esTripRoad.distinct("Carrier")
		
		For ($nCarrier; 0; ($cCarrier.length-1))  //Carrier
			
			$esCarrier:=$esTripRoad.query("Carrier = :1"; $cCarrier[$nCarrier])
			
			$nCarrierTotal:=$esCarrier.length
			
			$cShipTo:=$esCarrier.distinct("ShipTo")
			$nShipTo:=$cShipTo.length
			
			APPEND TO ARRAY:C911($atCarrier; $cCarrier[$nCarrier])
			APPEND TO ARRAY:C911($atTotal; String:C10($nCarrierTotal))
			APPEND TO ARRAY:C911($atShipTo; String:C10($nShipTo))
			
		End for   //Done carrier
		
		
End case   //Done trip carriers

Case of   //Specifics
		
	: (True:C214)  //Ocean Addresses
		
		ARRAY TEXT:C222($atShipTo; 0)
		
		ARRAY TEXT:C222($atName; 0)
		ARRAY TEXT:C222($atAddress1; 0)
		ARRAY TEXT:C222($atCity; 0)
		ARRAY TEXT:C222($atState; 0)
		ARRAY TEXT:C222($atZip; 0)
		ARRAY TEXT:C222($atCountry; 0)
		ARRAY TEXT:C222($atTrip; 0)
		
		ARRAY POINTER:C280($apColumn; 0)
		
		APPEND TO ARRAY:C911($apColumn; ->$atName)
		APPEND TO ARRAY:C911($apColumn; ->$atAddress1)
		APPEND TO ARRAY:C911($apColumn; ->$atCity)
		APPEND TO ARRAY:C911($apColumn; ->$atState)
		APPEND TO ARRAY:C911($apColumn; ->$atZip)
		APPEND TO ARRAY:C911($apColumn; ->$atCountry)
		APPEND TO ARRAY:C911($apColumn; ->$atTrip)
		
		$esTripOcean:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4) AND (Carrier = :5"; \
			!2021-01-01!; !2021-12-31!; "@ocean@"; "@sea@"; CorektBlank)
		
		$cShipTo:=$esTripOcean.distinct("ShipTo")
		
		COLLECTION TO ARRAY:C1562($cShipTo; $atShipTo)
		
		QUERY WITH ARRAY:C644([Addresses:30]ID:1; $atShipTo)
		
		SELECTION TO ARRAY:C260(\
			[Addresses:30]ID:1; $atID; \
			[Addresses:30]Name:2; $atName; \
			[Addresses:30]Address1:3; $atAddress1; \
			[Addresses:30]City:6; $atCity; \
			[Addresses:30]State:7; $atState; \
			[Addresses:30]Zip:8; $atZip; \
			[Addresses:30]Country:9; $atCountry)
		
		$nNumberOfIDs:=Size of array:C274($atID)
		
		For ($nID; 1; $nNumberOfIDs)  //Trips
			
			$nTrips:=$esTripOcean.query("ShipTo = :1"; $atID{$nID}).length
			
			APPEND TO ARRAY:C911($atTrip; String:C10($nTrips))
			
		End for   //Done trips
		
		SORT ARRAY:C229($atCountry; $atName; $atAddress1; $atCity; $atState; $atZip; $atTrip; >)
		
	: (False:C215)  //Air Addresses
		
		ARRAY TEXT:C222($atShipTo; 0)
		
		ARRAY TEXT:C222($atName; 0)
		ARRAY TEXT:C222($atAddress1; 0)
		ARRAY TEXT:C222($atCity; 0)
		ARRAY TEXT:C222($atState; 0)
		ARRAY TEXT:C222($atZip; 0)
		ARRAY TEXT:C222($atCountry; 0)
		
		ARRAY POINTER:C280($apColumn; 0)
		
		APPEND TO ARRAY:C911($apColumn; ->$atName)
		APPEND TO ARRAY:C911($apColumn; ->$atAddress1)
		APPEND TO ARRAY:C911($apColumn; ->$atCity)
		APPEND TO ARRAY:C911($apColumn; ->$atState)
		APPEND TO ARRAY:C911($apColumn; ->$atZip)
		APPEND TO ARRAY:C911($apColumn; ->$atCountry)
		
		//$esTripAir:=ds.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4) AND Carrier = :5";\
			!2021-01-01!;!2021-12-31!;"@air@";"@next day@";"Daybreak")
		
		$esTripAir:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4) AND Carrier = :5"; \
			!2021-01-01!; !2021-12-31!; "@air@"; "@next day@"; CorektBlank)
		
		$cShipTo:=$esTripAir.distinct("ShipTo")
		
		COLLECTION TO ARRAY:C1562($cShipTo; $atShipTo)
		
		QUERY WITH ARRAY:C644([Addresses:30]ID:1; $atShipTo)
		
		SORT ARRAY:C229($atCountry; $atName; $atAddress1; $atCity; $atState; $atZip; >)
		
		SELECTION TO ARRAY:C260(\
			[Addresses:30]Name:2; $atName; \
			[Addresses:30]Address1:3; $atAddress1; \
			[Addresses:30]City:6; $atCity; \
			[Addresses:30]State:7; $atState; \
			[Addresses:30]Zip:8; $atZip; \
			[Addresses:30]Country:9; $atCountry)
		
End case   //Done specifics

Core_Array_ToDocument(->$apColumn)