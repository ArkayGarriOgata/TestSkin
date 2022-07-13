//%attributes = {}
//Method:  Adrs_MileageFill
//Description:  This method will fill in the address mileage from the warehouse

//read a tab delimited document from the Desktop
//$millis:=Milliseconds

//$milageSourceDocument:=File("MacBook22:Users:mel:Desktop:YTD_Billings_220506_1328.txt";fk platform path)

//$data:=$milageSourceDocument.getText()

//$delimitorRow:="\r"
//$delimitorColumn:="\t"

//$rows_c:=New collection
//$rows_c:=Split string($data;$delimitorRow;sk ignore empty strings+sk trim spaces)

//For each ($row;$rows_c)
//$columns_c:=New collection
//$columns_c:=Split string($row;$delimitorColumn;sk ignore empty strings+sk trim spaces)

//$customerID:=String(Num($columns_c[0]);"00000")


//End for each 

//$elapse:=Milliseconds-$millis

//ALERT(String($elapse/1000))

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bProgress)
	
	C_LONGINT:C283($nCustomer; $nNumberOfCustomers)
	C_LONGINT:C283($nNumberOfLookups; $nShipTo)
	
	C_OBJECT:C1216($eAddress; $esAddress)
	C_OBJECT:C1216($oSaved)
	C_OBJECT:C1216($oProgress)
	
	C_TEXT:C284($tAddressID)
	
	$oProgress:=New object:C1471()
	
	ARRAY LONGINT:C221($anShipTo; 0)  //Lookup arrays
	ARRAY TEXT:C222($atLookUpCustomer; 0)
	
	ARRAY TEXT:C222($atCustomer; 0)  //Name arrays
	ARRAY LONGINT:C221($anMileage; 0)
	
	ARRAY TEXT:C222($atShipTo; 0)  //ShipTo arrays
	ARRAY LONGINT:C221($anShipToMileage; 0)
	
	If (True:C214)  //Fill
		
		If (True:C214)  //Lookup
			
			APPEND TO ARRAY:C911($anShipTo; 9828)
			APPEND TO ARRAY:C911($anShipTo; 2031)
			
		End if   //Done lookup
		
		If (True:C214)  //Name
			
			APPEND TO ARRAY:C911($atCustomer; "220 Laboratories")
			APPEND TO ARRAY:C911($atCustomer; "Arcade Beauty")
			
		End if   //Done name
		
		If (True:C214)  //ShipTo
			
			ARRAY TEXT:C222($atShipTo; 0)
			
		End if   //Done shipto
		
	End if   //Done fill
	
	$nNumberOfLookups:=Size of array:C274($atLookUpCustomer)
	$nNumberOfCustomers:=Size of array:C274($atCustomer)
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfCustomers
	$oProgress.tTitle:="Updating Customer Mileage"
	
End if   //Done initialize

For ($nCustomer; 1; $nNumberOfCustomers)  //Customer
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$oProgress.nLoop:=$nCustomer
		$oProgress.tMessage:=$atCustomer{$nCustomer}
		
		Prgr_Message($oProgress)
		
		$nShipTo:=Find in array:C230($atLookUpCustomer; $atCustomer{$nCustomer})
		
		Case of   //Valid
				
			: ($nShipTo=CoreknNoMatchFound)
				
			: ($nShipTo>$nNumberOfLookups)
				
			Else   //Found
				
				Case of   //AddressID
						
					: ($anShipTo{$nShipTo}=-2)
						
						$tAddressID:="<<<<"
						
					: ($anShipTo{$nShipTo}=-1)
						
						$tAddressID:="VOID"
						
					: ($anShipTo{$nShipTo}=0)
						
						$tAddressID:="????"
						
					Else 
						
						$tAddressID:=String:C10($anShipTo{$nShipTo}; "00000")
						
				End case   //Done addressID
				
				$esAddress:=ds:C1482.Addresses.query("ID = :1"; $tAddressID)
				
				If ($esAddress.length=1)  //Unique
					
					$eAddress:=$esAddress.first()
					
					$eAddress.MilesFromDeparture:=$anMileage{$nCustomer}
					
					$oSaved:=$eAddress.save()
					
				End if   //Done unique
				
		End case   //Done valid
		
	Else   //Progress canceled
		
		$nCustomer:=$nNumberOfCustomers+1  //Cancel loop
		
	End if   //Done progress
	
End for   //Done customer

Prgr_Quit($oProgress)

