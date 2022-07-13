//%attributes = {}
//Method:  BOL_Rprt_Shipment(oBOL)
//Description:  This method will create a report of shipments

//Total mtCO2 is ((Total*.0211)/1000)

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cCarrier)
	
	C_OBJECT:C1216($esTripAll)
	
	C_OBJECT:C1216($esTripOcean)
	C_OBJECT:C1216($esTripAir)
	C_OBJECT:C1216($esTripRoad)
	C_OBJECT:C1216($esCarrier)
	
	C_OBJECT:C1216($eTripOcean)
	C_OBJECT:C1216($eTripAir)
	C_OBJECT:C1216($eTripRoad)
	C_OBJECT:C1216($eCarrier)
	
	C_OBJECT:C1216($oAddress)
	C_OBJECT:C1216($oAirport)
	C_OBJECT:C1216($oDockingport)
	
	ARRAY TEXT:C222($atName; 0)
	
	ARRAY TEXT:C222($atAddress1; 0)
	ARRAY TEXT:C222($atCity; 0)
	ARRAY TEXT:C222($atState; 0)
	ARRAY TEXT:C222($atZip; 0)
	ARRAY TEXT:C222($atCountry; 0)
	
	ARRAY TEXT:C222($atShipDate; 0)
	ARRAY TEXT:C222($atCarrier; 0)
	ARRAY TEXT:C222($atMileage; 0)
	ARRAY TEXT:C222($atWeight; 0)
	ARRAY TEXT:C222($atTonMile; 0)
	
	ARRAY TEXT:C222($atRoadName; 0)
	
	ARRAY TEXT:C222($atRoadAddress1; 0)
	ARRAY TEXT:C222($atRoadCity; 0)
	ARRAY TEXT:C222($atRoadState; 0)
	ARRAY TEXT:C222($atRoadZip; 0)
	ARRAY TEXT:C222($atRoadCountry; 0)
	
	ARRAY TEXT:C222($atRoadShipDate; 0)
	ARRAY TEXT:C222($atRoadCarrier; 0)
	ARRAY TEXT:C222($atRoadMileage; 0)
	ARRAY TEXT:C222($atRoadWeight; 0)
	ARRAY TEXT:C222($atRoadTonMile; 0)
	
	ARRAY TEXT:C222($atStripCharacter; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	$cCarrier:=New collection:C1472()
	
	$esTripAll:=New object:C1471()
	$esTripOcean:=New object:C1471()
	$esTripAir:=New object:C1471()
	$esTripRoad:=New object:C1471()
	
	$esCarrier:=New object:C1471()
	$eCarrier:=New object:C1471()
	$eTripRoad:=New object:C1471()
	
	$esTripRoad:=Core_EnSl_CreateEmptyO(->[Customers_Bills_of_Lading:49])
	
	$oAddress:=New object:C1471()
	$oAirport:=New object:C1471()
	$oDockingport:=New object:C1471()
	
	APPEND TO ARRAY:C911($apColumn; ->$atName)
	
	APPEND TO ARRAY:C911($apColumn; ->$atAddress1)
	APPEND TO ARRAY:C911($apColumn; ->$atCity)
	APPEND TO ARRAY:C911($apColumn; ->$atState)
	APPEND TO ARRAY:C911($apColumn; ->$atZip)
	APPEND TO ARRAY:C911($apColumn; ->$atCountry)
	
	APPEND TO ARRAY:C911($apColumn; ->$atShipDate)
	APPEND TO ARRAY:C911($apColumn; ->$atCarrier)
	APPEND TO ARRAY:C911($apColumn; ->$atMileage)
	APPEND TO ARRAY:C911($apColumn; ->$atWeight)
	APPEND TO ARRAY:C911($apColumn; ->$atTonMile)
	
	APPEND TO ARRAY:C911($atName; "Ship To")
	
	APPEND TO ARRAY:C911($atAddress1; "Address 1")
	APPEND TO ARRAY:C911($atCity; "City")
	APPEND TO ARRAY:C911($atState; "State")
	APPEND TO ARRAY:C911($atZip; "Zip Code")
	APPEND TO ARRAY:C911($atCountry; "Country")
	
	APPEND TO ARRAY:C911($atShipDate; "Ship Date")
	APPEND TO ARRAY:C911($atCarrier; "Carrier")
	APPEND TO ARRAY:C911($atMileage; "Mileage")
	APPEND TO ARRAY:C911($atWeight; "Weight")
	APPEND TO ARRAY:C911($atTonMile; "Ton/Mile")
	
	APPEND TO ARRAY:C911($atRoadAirport; "Airport")
	
	APPEND TO ARRAY:C911($atRoadName; "Name")
	
	APPEND TO ARRAY:C911($atRoadAddress1; "Address")
	APPEND TO ARRAY:C911($atRoadCity; "City")
	APPEND TO ARRAY:C911($atRoadState; "Province")
	APPEND TO ARRAY:C911($atRoadZip; "Code")
	APPEND TO ARRAY:C911($atRoadCountry; "Country")
	
	APPEND TO ARRAY:C911($atRoadShipDate; "Ship Date")
	APPEND TO ARRAY:C911($atRoadCarrier; "Carrier")
	APPEND TO ARRAY:C911($atRoadMileage; "Mileage")
	APPEND TO ARRAY:C911($atRoadWeight; "Weight (lbs)")
	APPEND TO ARRAY:C911($atRoadTonMile; "Ton Miles")
	
	APPEND TO ARRAY:C911($atStripCharacter; CorektSpace)
	APPEND TO ARRAY:C911($atStripCharacter; Char:C90(Line feed:K15:40))
	APPEND TO ARRAY:C911($atStripCharacter; CorektCR)
	
End if   //Done initialize

Case of   //Mileage
		
	: (False:C215)  //Ocean
		
		$esTripOcean:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4) AND (Carrier = :5 OR Carrier = :6"; \
			!2021-01-01!; !2021-12-31!; "@ocean@"; "@sea@"; "Daybreak"; CorektBlank)
		
		For each ($eTripOcean; $esTripOcean)  //Carrier
			
			$oAddress:=Adrs_GetAddressO($eTripOcean.ShipTo)
			
			If (Not:C34(OB Is empty:C1297($oAddress)))  //Address
				
				$bAddTrip:=True:C214
				
				Case of   //Tally
						
					: ($oAddress.Country="IT")
						
						$nOceanMiles:=4559
						$nRoadMiles:=525
						
						$oDockingport.Name:="Port of Gioia Tauro"
						$oDockingport.Address1:="89013 Gioia Tauro"
						$oDockingport.City:="Reggio"
						$oDockingport.State:="Calabria"
						$oDockingport.Zip:=CorektBlank
						$oDockingport.Country:="IT"
						
					: ($oAddress.Country="PL")
						
						$nOceanMiles:=4090
						$nRoadMiles:=211
						
						$oDockingport.Name:="Port of Gdynia"
						$oDockingport.Address1:="81-337 Gdynia"
						$oDockingport.City:="Porterdamska"
						$oDockingport.State:=CorektBlank
						$oDockingport.Zip:=CorektBlank
						$oDockingport.Country:="PL"
						
					: ($oAddress.Country="SP")
						
						$nOceanMiles:=3628
						$nRoadMiles:=651
						
						$oDockingport.Name:="Port of Algeciras"
						$oDockingport.Address1:="11201 Algeciras"
						$oDockingport.City:="Cadiz"
						$oDockingport.State:=CorektBlank
						$oDockingport.Zip:=CorektBlank
						$oDockingport.Country:="SP"
						
					: ($oAddress.Country="BE")
						
						$nAirMiles:=3647
						$nRoadMiles:=33
						
						$oDockingport.Name:="Antwerp International Airport"
						
						$oDockingport.Address1:="2100 Antwerpen"
						$oDockingport.City:="Luchthavenlei"
						$oDockingport.State:=CorektBlank
						$oDockingport.Zip:=CorektBlank
						$oDockingport.Country:="BE"
						
					: ($oAddress.Country="CH")
						
						$nAirMiles:=3918
						$nRoadMiles:=41
						
						$oDockingport.Name:="Zurich International Airport"
						
						$oDockingport.Address1:="8058 Kloten"
						$oDockingport.City:="Switzerland"
						$oDockingport.State:=CorektBlank
						$oDockingport.Zip:=CorektBlank
						$oDockingport.Country:="CH"
						
					: ($oAddress.Country="CN")
						
						$nAirMiles:=7366
						$nRoadMiles:=25
						
						$oDockingport.Name:="Sunan Shuofang International Airport"
						$oDockingport.Address1:="1 Airport Rd"
						$oDockingport.City:="Xinwu District"
						$oDockingport.State:="Jiangsu"
						$oDockingport.Zip:="214028"
						$oDockingport.Country:="CN"
						
					: ($oAddress.Country="GB")
						
						$nAirMiles:=3414
						$nRoadMiles:=1
						
						$oAddress.Name:="Southampton Airport"
						$oAddress.Address1:="SO18 2NL"
						$oAddress.City:="Southampton"
						$oAddress.State:=CorektBlank
						$oAddress.Zip:=CorektBlank
						$oAddress.Country:="GB"
						
					: ($oAddress.Country="JP")
						
						$nAirMiles:=6753
						$nRoadMiles:=3
						
						$oDockingport.Name:="Haneda Airport"
						$oDockingport.Address1:="8058 Kloten"
						$oDockingport.City:="Hanedakuko"
						$oDockingport.State:="Tokyo"
						$oDockingport.Zip:="144-0041"
						$oDockingport.Country:="JP"
						
					: ($oAddress.Country="KR")
						
						$nAirMiles:=6903
						$nRoadMiles:=7
						
						$oDockingport.Name:="Osan AMC Terminal"
						$oDockingport.Address1:="281 Jeokbong-ri,"
						$oDockingport.City:="Pyeongtaek-si"
						$oDockingport.State:="Gyeonggi-do"
						$oDockingport.Zip:=CorektBlank
						$oDockingport.Country:="KR"
						
					Else 
						
						$bAddTrip:=False:C215
						
				End case   //Done tally
				
				If ($bAddTrip)  //Add
					
					APPEND TO ARRAY:C911($atName; $oDockingport.Name)
					
					APPEND TO ARRAY:C911($atAddress1; $oDockingport.Address1)
					APPEND TO ARRAY:C911($atCity; $oDockingport.City)
					APPEND TO ARRAY:C911($atState; $oDockingport.State)
					APPEND TO ARRAY:C911($atZip; $oDockingport.Zip)
					APPEND TO ARRAY:C911($atCountry; $oDockingport.Country)
					
					APPEND TO ARRAY:C911($atShipDate; String:C10($eTripOcean.ShipDate))
					
					$tCarrier:=Choose:C955(($eTripOcean.Carrier="Daybreak"); \
						"DSV"; "NA")
					
					APPEND TO ARRAY:C911($atCarrier; $tCarrier)
					
					APPEND TO ARRAY:C911($atMileage; String:C10($nOceanMiles))
					APPEND TO ARRAY:C911($atWeight; String:C10($eTripOcean.Total_Wgt))
					APPEND TO ARRAY:C911($atTonMile; String:C10(($nAirMiles*$eTripOcean.Total_Wgt)/2000))
					
					//Road leg of the air trips
					
					APPEND TO ARRAY:C911($atRoadAirport; $oDockingport.Name)
					
					APPEND TO ARRAY:C911($atRoadName; $oAddress.Name)
					
					APPEND TO ARRAY:C911($atRoadAddress1; $oAddress.Address1)
					APPEND TO ARRAY:C911($atRoadCity; $oAddress.City)
					APPEND TO ARRAY:C911($atRoadState; $oAddress.State)
					APPEND TO ARRAY:C911($atRoadZip; $oAddress.Zip)
					APPEND TO ARRAY:C911($atRoadCountry; $oAddress.Country)
					
					APPEND TO ARRAY:C911($atRoadShipDate; String:C10($eTripOcean.ShipDate))
					
					APPEND TO ARRAY:C911($atRoadCarrier; "DSV")
					
					APPEND TO ARRAY:C911($atRoadMileage; String:C10($nRoadMiles+10))  //Add 10 to get to Newark
					APPEND TO ARRAY:C911($atRoadWeight; String:C10($eTripOcean.Total_Wgt))
					APPEND TO ARRAY:C911($atRoadTonMile; String:C10((($nRoadMiles+10)*$eTripOcean.Total_Wgt)/2000))
					
				End if   //Done add
				
			End if   //Done address
			
		End for each   //Done carrier
		
		ARRAY POINTER:C280($apRoad; 0)
		
		APPEND TO ARRAY:C911($apRoad; ->$atRoadName)
		
		APPEND TO ARRAY:C911($apRoad; ->$atRoadAddress1)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadCity)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadState)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadZip)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadCountry)
		
		APPEND TO ARRAY:C911($apRoad; ->$atRoadShipDate)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadCarrier)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadMileage)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadWeight)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadTonMile)
		
		Core_Array_ToDocument(->$apRoad)
		
	: (False:C215)  //Air
		
		$esTripAir:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND (Mode = :3 OR Mode = :4) And Carrier = :5"; \
			!2021-01-01!; !2021-12-31!; "@air@"; "@next day@"; "Daybreak")
		
		For each ($eTripAir; $esTripAir)  //Carrier
			
			$oAddress:=Adrs_GetAddressO($eTripAir.ShipTo)
			
			If (Not:C34(OB Is empty:C1297($oAddress)))  //Address
				
				$bAddTrip:=True:C214
				
				Case of   //Tally
						
					: ($oAddress.Country="BE")
						
						$nAirMiles:=3647
						$nRoadMiles:=33
						
						$oAirport.Name:="Brussels Airport"
						
						$oAirport.Address1:="1930 Zaventem"
						$oAirport.City:="Leopoldlaan"
						$oAirport.State:=CorektBlank
						$oAirport.Zip:=CorektBlank
						$oAirport.Country:="BE"
						
					: ($oAddress.Country="CH")
						
						$nAirMiles:=3918
						$nRoadMiles:=41
						
						$oAirport.Name:="Zurich Airport"
						
						$oAirport.Address1:="8058 Kloten"
						$oAirport.City:="Switzerland"
						$oAirport.State:=CorektBlank
						$oAirport.Zip:=CorektBlank
						$oAirport.Country:="CH"
						
					: ($oAddress.Country="CN")
						
						$nAirMiles:=7365
						$nRoadMiles:=25
						
						$oAirport.Name:="Pudong International Airport"
						
						$oAirport.Address1:="Yingbin Expy"
						$oAirport.City:="Pudong"
						$oAirport.State:="Shanghai"
						$oAirport.Zip:=CorektBlank
						$oAirport.Country:="CN"
						
					: ($oAddress.Country="GB")
						
						$nAirMiles:=3454
						$nRoadMiles:=57
						
						$oAddress.Name:="Heathrow Airport"
						$oAddress.Address1:="3 Manor Court"
						$oAddress.City:="Exeter"
						$oAddress.State:=CorektBlank
						$oAddress.Zip:=CorektBlank
						$oAddress.Country:="GB"
						
					: ($oAddress.Country="JP")
						
						$nAirMiles:=6712
						$nRoadMiles:=35
						
						$oAirport.Name:="Narita Airport"
						$oAirport.Address1:="1-1 Furugome"
						$oAirport.City:="Narita"
						$oAirport.State:="Chiba"
						$oAirport.Zip:="282-0004"
						$oAirport.Country:="JP"
						
					: ($oAddress.Country="KR")
						
						$nAirMiles:=6878
						$nRoadMiles:=28
						
						$oAirport.Name:="Incheon International Airport"
						$oAirport.Address1:="272 Gonghang-ro"
						$oAirport.City:="Jung-gu"
						$oAirport.State:="Incheon"
						$oAirport.Zip:=CorektBlank
						$oAirport.Country:="KR"
						
					Else 
						
						$bAddTrip:=False:C215
						
				End case   //Done tally
				
				If ($bAddTrip)  //Add
					
					APPEND TO ARRAY:C911($atName; $oAirport.Name)
					
					APPEND TO ARRAY:C911($atAddress1; $oAirport.Address1)
					APPEND TO ARRAY:C911($atCity; $oAirport.City)
					APPEND TO ARRAY:C911($atState; $oAirport.State)
					APPEND TO ARRAY:C911($atZip; $oAirport.Zip)
					APPEND TO ARRAY:C911($atCountry; $oAirport.Country)
					
					APPEND TO ARRAY:C911($atShipDate; String:C10($eTripAir.ShipDate))
					APPEND TO ARRAY:C911($atCarrier; "DSV")
					APPEND TO ARRAY:C911($atMileage; String:C10($nAirMiles))
					APPEND TO ARRAY:C911($atWeight; String:C10($eTripAir.Total_Wgt))
					APPEND TO ARRAY:C911($atTonMile; String:C10(($nAirMiles*$eTripAir.Total_Wgt)/2000))
					
					//Road leg of the air trips
					
					APPEND TO ARRAY:C911($atRoadAirport; $oAirport.Name)
					
					APPEND TO ARRAY:C911($atRoadName; $oAddress.Name)
					
					APPEND TO ARRAY:C911($atRoadAddress1; $oAddress.Address1)
					APPEND TO ARRAY:C911($atRoadCity; $oAddress.City)
					APPEND TO ARRAY:C911($atRoadState; $oAddress.State)
					APPEND TO ARRAY:C911($atRoadZip; $oAddress.Zip)
					APPEND TO ARRAY:C911($atRoadCountry; $oAddress.Country)
					
					APPEND TO ARRAY:C911($atRoadShipDate; String:C10($eTripAir.ShipDate))
					APPEND TO ARRAY:C911($atRoadCarrier; "DSV")
					APPEND TO ARRAY:C911($atRoadMileage; String:C10($nRoadMiles+10))  //Add 10 to get to Newark
					APPEND TO ARRAY:C911($atRoadWeight; String:C10($eTripAir.Total_Wgt))
					APPEND TO ARRAY:C911($atRoadTonMile; String:C10((($nRoadMiles+10)*$eTripAir.Total_Wgt)/2000))
					
				End if   //Done add
				
			End if   //Done address
			
		End for each   //Done carrier
		
		ARRAY POINTER:C280($apRoad; 0)
		
		APPEND TO ARRAY:C911($apRoad; ->$atRoadName)
		
		APPEND TO ARRAY:C911($apRoad; ->$atRoadAddress1)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadCity)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadState)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadZip)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadCountry)
		
		APPEND TO ARRAY:C911($apRoad; ->$atRoadShipDate)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadCarrier)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadMileage)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadWeight)
		APPEND TO ARRAY:C911($apRoad; ->$atRoadTonMile)
		
		Core_Array_ToDocument(->$apRoad)
		
	: (True:C214)  //Road
		
		$bFirst:=True:C214
		
		$esTripRoad:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND ShipTo # :3"; \
			!2021-01-01!; !2021-12-31!; CorektBlank).orderBy("ADDRESS_SHIPTO.Name asc")
		
		For each ($eTripRoad; $esTripRoad)  //Road
			
			$oAddress:=Adrs_GetAddressO($eTripRoad.ShipTo)
			
			If (Not:C34(OB Is empty:C1297($oAddress)))  //Address
				
				$bAddTrip:=True:C214
				
				Case of   //Foreign
					: ($oAddress.Country="US")
					: ($oAddress.Country="CA")
					: ($eTripRoad.Carrier="Daybreak")  //Daybreak ocean/air
						
						$oAddress.Name:="DSV"
						$oAddress.Address1:="1005 W Middlesex Avenue"
						$oAddress.City:="Port Reading"
						$oAddress.State:="NJ"
						$oAddress.Zip:="07064"
						$oAddress.Country:="US"
						
						$oAddress.MilesFromDeparture:=440
						
					Else   //Foreign
						
						$bAddTrip:=False:C215
						
				End case   //Done foreign
				
				If ($bAddTrip)  //Add
					
					APPEND TO ARRAY:C911($atName; $oAddress.Name)
					
					APPEND TO ARRAY:C911($atAddress1; $oAddress.Address1)
					APPEND TO ARRAY:C911($atCity; $oAddress.City)
					APPEND TO ARRAY:C911($atState; $oAddress.State)
					APPEND TO ARRAY:C911($atZip; $oAddress.Zip)
					APPEND TO ARRAY:C911($atCountry; $oAddress.Country)
					
					APPEND TO ARRAY:C911($atShipDate; String:C10($eTripRoad.ShipDate))
					APPEND TO ARRAY:C911($atCarrier; $eTripRoad.Carrier)
					APPEND TO ARRAY:C911($atMileage; String:C10($oAddress.MilesFromDeparture))
					APPEND TO ARRAY:C911($atWeight; String:C10($eTripRoad.Total_Wgt))
					APPEND TO ARRAY:C911($atTonMile; String:C10(($oAddress.MilesFromDeparture*$eTripRoad.Total_Wgt)/2000))
					
				End if   //Done add
			End if   //Done address
			
		End for each   //Done road
		
	: (False:C215)  //TruckLoad
		
		ARRAY TEXT:C222($atShipDate; 0)
		ARRAY TEXT:C222($atCarrier; 0)
		ARRAY TEXT:C222($atSkids; 0)
		ARRAY TEXT:C222($atTruckLoad; 0)
		
		ARRAY POINTER:C280($apColumn; 0)
		
		APPEND TO ARRAY:C911($apColumn; ->$atShipDate)
		APPEND TO ARRAY:C911($apColumn; ->$atCarrier)
		APPEND TO ARRAY:C911($apColumn; ->$atSkids)
		APPEND TO ARRAY:C911($apColumn; ->$atTruckLoad)
		
		APPEND TO ARRAY:C911($atShipDate; "Ship Date")
		APPEND TO ARRAY:C911($atCarrier; "Carrier")
		APPEND TO ARRAY:C911($atSkids; "Skids")
		APPEND TO ARRAY:C911($atTruckLoad; "Truck Load")
		
		$bFirst:=True:C214
		
		$esTripRoad:=ds:C1482.Customers_Bills_of_Lading.query(\
			"(ShipDate >= :1 AND ShipDate <= :2) AND ShipTo # :3"; \
			!2021-01-01!; !2021-12-31!; CorektBlank).orderBy("ShipDate asc AND Carrier asc")
		
		For each ($eTripRoad; $esTripRoad)  //Road
			
			Case of   //Tally
					
				: ($bFirst)
					
					$tCarrier:=$eTripRoad.Carrier
					$dShipDate:=$eTripRoad.ShipDate
					$nSkids:=$eTripRoad.Total_Skids
					
					$bFirst:=False:C215
					
				: (($tCarrier=$eTripRoad.Carrier) & ($dShipDate=$eTripRoad.ShipDate))  //Same carrier and date
					
					$nSkids:=$nSkids+$eTripRoad.Total_Skids
					
				Else   //
					
					Case of   //Filter
						: ($tCarrier=CorektBlank)
						: (Core_Text_RemoveT($tCarrier; ->$atStripCharacter; 3)=CorektBlank)
						: (($tCarrier="Daybreak") & ($nSkids>40))
							
						Else 
							
							APPEND TO ARRAY:C911($atShipDate; String:C10($dShipDate))
							APPEND TO ARRAY:C911($atCarrier; $tCarrier)
							APPEND TO ARRAY:C911($atSkids; String:C10($nSkids))
							APPEND TO ARRAY:C911($atTruckLoad; Choose:C955($nSkids<40; "LTL"; "FTL"))
							
					End case   //Done filter
					
					$tCarrier:=$eTripRoad.Carrier
					$dShipDate:=$eTripRoad.ShipDate
					$nSkids:=$eTripRoad.Total_Skids
					
			End case   //Done tally
			
		End for each   //Done road
		
		APPEND TO ARRAY:C911($atShipDate; String:C10($dShipDate))  //Add last one
		APPEND TO ARRAY:C911($atCarrier; $tCarrier)
		APPEND TO ARRAY:C911($atSkids; String:C10($nSkids))
		APPEND TO ARRAY:C911($atTruckLoad; Choose:C955(($nSkids<40); "LTL"; "FTL"))
		
End case   //Done mileage

Core_Array_ToDocument(->$apColumn)