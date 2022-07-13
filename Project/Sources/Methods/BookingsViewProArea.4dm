//%attributes = {}
// _______
// Method: BookingsViewProArea ( ) ->
// By: Mel Bohince @ 12/14/21, 13:38:55
// Description
// test the bookings collection in a ViewPro area
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On VP Ready:K2:59)
		C_COLLECTION:C1488($cellvalues)
		$cellvalues:=New collection:C1472
		
		C_OBJECT:C1216($row_o)
		$row_o:=Form:C1466.bookings_c[0]
		If ($row_o#Null:C1517)
			
			ARRAY TEXT:C222($bookingProperties; 0)
			OB GET PROPERTY NAMES:C1232($row_o; $bookingProperties)
			
			//set column titles
			$currentLineValues:=New collection:C1472
			ARRAY TO COLLECTION:C1563($currentLineValues; $bookingProperties)
			$cellvalues.push($currentLineValues)
			
			For each ($row_o; Form:C1466.bookings_c)
				$currentLineValues:=New collection:C1472
				
				For ($prop; 1; Size of array:C274($bookingProperties))
					$currentLineValues.push($row_o[$bookingProperties{$prop}])
				End for 
				
				$cellvalues.push($currentLineValues)
			End for each 
			
			//provide indication of the date range used
			$cellvalues.push(New collection:C1472("From:"; String:C10(Form:C1466.from); "To:"; String:C10(Form:C1466.to); "On:"; String:C10(Current date:C33)))
			
			
			VP SET VALUES(VP Cell("ViewProArea"; 0; 0); $cellvalues)
			
			Bookings_ApplyStyle
			
		End if 
		
End case 

