//%attributes = {"publishedSql":true}
// Method: CUST_getName (custid{;"elc"}) ->cust_name 
// ----------------------------------------------------
// by: mel: 06/22/04, 16:53:15
// ----------------------------------------------------
// Description:
// return customer name when given the id
// Modified by: Mel Bohince (10/8/15) 
// second param prefixes estee lauder customer group, if *, name is replace with estee lauder
// Modified by: Mel Bohince (10/4/17) use cache built by method app_CommonArrays


C_TEXT:C284($0; $1; $2; $name)
$name:=""

If (False:C215)  //original code
	READ ONLY:C145([Customers:16])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$1)
	If (Records in selection:C76([Customers:16])=1)
		$name:=[Customers:16]Name:2
	End if 
	SET QUERY LIMIT:C395(0)
	
	If (Count parameters:C259>1)
		If (ELC_isEsteeLauderCompany($1))
			If ($2="*")
				$name:="Estee Lauder"
			Else 
				
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
				
				$name:="EL_"+$name
			End if 
			
		Else 
			
			Case of 
				: (Position:C15("Procter"; $name)>0)
					$name:="P&G"
				: (Position:C15("Arden"; $name)>0)
					$name:="Arden"
				: (Position:C15("Stila"; $name)>0)
					$name:="Stila"
				: (Position:C15("L'Oreal"; $name)>0)
					$name:="Loreal"
				: (Position:C15("Inter-Parfum"; $name)>0)
					$name:="Inter-Parfums"
				: (Position:C15("Batallure"; $name)>0)
					$name:="Batallure"
				: (Position:C15("Arkay"; $name)>0)
					$name:="Arkay"
				: (Position:C15(" Products Llc"; $name)>0)
					$name:=Replace string:C233($name; " Products Llc"; "")
				: (Position:C15(", Inc."; $name)>0)
					$name:=Replace string:C233($name; ", Inc."; "")
				: (Position:C15(", Inc"; $name)>0)
					$name:=Replace string:C233($name; ", Inc"; "")
				: (Position:C15(", Llc"; $name)>0)
					$name:=Replace string:C233($name; ", Llc"; "")
				: (Position:C15(" Llc"; $name)>0)
					$name:=Replace string:C233($name; " Llc"; "")
				: (Position:C15(" Products"; $name)>0)
					$name:=Replace string:C233($name; " Products"; "")
				: (Position:C15(" Corporation"; $name)>0)
					$name:=Replace string:C233($name; " Corporation"; "")
			End case 
			
		End if 
	End if 
	REDUCE SELECTION:C351([Customers:16]; 0)
	$0:=$name
	
Else   //use cache
	
	$hit:=Find in array:C230(<>Cust_IDs; $1)
	If ($hit>-1)
		
		If (Count parameters:C259=1)  //the real name from the cust rec
			$0:=<>Cust_Names{$hit}
		Else   //apply grouping
			If ($2#"*")
				$0:=<>Cust_ShortNames{$hit}
			Else   //maybe one big lump of lauder
				If (Position:C15("EL_"; <>Cust_ShortNames{$hit})>0)
					$0:="Estee Lauder"
				Else 
					$0:=<>Cust_ShortNames{$hit}
				End if 
			End if 
		End if 
		
	Else 
		$0:=$1+"_name?"
	End if 
	
End if   //use cache


