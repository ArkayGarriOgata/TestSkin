//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/04/17, 14:55:33
// ----------------------------------------------------
// Method: Cust_getNameCached
// Description
// cache cust name to use like CUST_getName w/o hitting server
// Modified by: Mel Bohince (10/5/17) switch to ip arrays so triggers have access to hash pair
// Parameters
// ----------------------------------------------------
C_TEXT:C284($name; $1; $2; $0)
C_LONGINT:C283($i; $numElements; $hit)


Case of 
	: ($1="init")
		ARRAY TEXT:C222(<>Cust_IDs; 0)
		ARRAY TEXT:C222(<>Cust_ShortNames; 0)
		ARRAY TEXT:C222(<>Cust_Names; 0)
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		SELECTION TO ARRAY:C260([Customers:16]ID:1; <>Cust_IDs; [Customers:16]Name:2; <>Cust_Names)
		REDUCE SELECTION:C351([Customers:16]; 0)
		
		SORT ARRAY:C229(<>Cust_IDs; <>Cust_Names; >)
		
		$numElements:=Size of array:C274(<>Cust_IDs)
		ARRAY TEXT:C222(<>Cust_ShortNames; $numElements)
		
		//uThermoInit ($numElements;"Processing Array")
		For ($i; 1; $numElements)
			
			Case of 
				: (Position:C15(<>Cust_IDs{$i}; <>EL_Companies)>0)
					If (Count parameters:C259=2)
						$name:="Estee Lauder"
					Else 
						$name:=<>Cust_Names{$i}
						Case of 
							: (Position:C15("Clini"; $name)>0)
								$name:="Clinique"
							: (Position:C15("Len"; $name)>0)
								$name:="LenRon"
							: (Position:C15("Aramis"; $name)>0)
								$name:="Aramis"
							: (Position:C15("Bobbi"; $name)>0)
								$name:="Bobbi Brn"
							: (Position:C15("Mac Cosmetics"; $name)>0)
								$name:="Mac"
						End case 
						
						<>Cust_ShortNames{$i}:="EL_"+$name
					End if 
					
				Else   //all others
					
					Case of 
						: (Position:C15("Procter"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="P&G"
						: (Position:C15("Arden"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="Arden"
						: (Position:C15("Stila"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="Stila"
						: (Position:C15("L'Oreal"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="Loreal"
						: (Position:C15("Inter-Parfum"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="Inter-Parfums"
						: (Position:C15("Batallure"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="Batallure"
						: (Position:C15("Arkay"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:="Arkay"
						: (Position:C15(" Products Llc"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; " Products Llc"; "")
						: (Position:C15(", Inc."; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; ", Inc."; "")
						: (Position:C15(", Inc"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; ", Inc"; "")
						: (Position:C15(", Llc"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; ", Llc"; "")
						: (Position:C15(" Llc"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; " Llc"; "")
						: (Position:C15(" Products"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; " Products"; "")
						: (Position:C15(" Corporation"; <>Cust_Names{$i})>0)
							<>Cust_ShortNames{$i}:=Replace string:C233(<>Cust_Names{$i}; " Corporation"; "")
						Else 
							<>Cust_ShortNames{$i}:=<>Cust_Names{$i}
					End case 
			End case 
			
			
			//uThermoUpdate ($i)
		End for 
		//uThermoClose 
		$0:=String:C10(Size of array:C274(<>Cust_IDs))
		
	: ($1="get")
		$0:=CUST_getName($2; "el")  //old method retrofitted
		
End case 
