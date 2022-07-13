//• 5/1/97 cs replaced thermoset
TRACE:C157
uThermoInit(Size of array:C274(aRep); "Processing Rep's Initials…")  //• 5/1/97 cs replaced thermoset
If (real1=1)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3)  For
		
		For ($i; 1; Size of array:C274(aRep))
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=aOL{$i})
			If (Records in selection:C76([Customers_Order_Lines:41])#0)
				aRep{$i}:=[Customers_Order_Lines:41]SalesRep:34
			Else 
				aRep{$i}:=""
			End if 
			uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
		End for 
		
	Else 
		//Laghzaoui i use principe [Customers_Order_Lines]OrderLine unique
		QUERY WITH ARRAY:C644([Customers_Order_Lines:41]OrderLine:3; aOL)
		ARRAY TEXT:C222($_OrderLine; 0)
		ARRAY TEXT:C222($_SalesRep; 0)
		
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $_OrderLine; \
			[Customers_Order_Lines:41]SalesRep:34; $_SalesRep)
		
		For ($i; 1; Size of array:C274(aRep))
			$position:=Find in array:C230($_OrderLine; aOL{$i})
			If ($position>0)
				
				aRep{$i}:=$_SalesRep{$position}
				
			Else 
				aRep{$i}:=""
			End if 
			uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	
	For ($i; 1; Size of array:C274(aRep))
		aRep{$i}:=""
		uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
	End for 
	
End if 
uThermoClose  //• 5/1/97 cs replaced thermoset
// 