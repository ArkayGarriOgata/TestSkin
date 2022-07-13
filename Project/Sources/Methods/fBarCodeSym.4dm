//%attributes = {"publishedWeb":true}
//Procedure: fBarCodeSym(symbology;text)  072696  MLB
//prepare a text string for use with a barcode font
//• 5/5/97 cs added third Parameter, pointer to object to print with
//  allow object  have it's font style set

C_LONGINT:C283($1)  //eg 39 or 128
C_TEXT:C284($2; $0)
C_POINTER:C301($3)

Case of 
	: ($1=39)  //requires start and stop chars
		If ($2#"")  //• 5/5/97 cs
			$0:="*"+$2+"*"
			
			If (Count parameters:C259=3)
				OBJECT SET FONT SIZE:C165($3->; 12)  //set to 18 point
				OBJECT SET FONT:C164($3->; "IDAutomationHC39S")
				$3->:=$0
			End if 
			
		Else   //• 5/5/97 cs stop from sending only "**"
			$0:=""
		End if 
		
	: ($1=128)  //using Code128c, requires start and stop chars and check digits        
		$0:=fBarCodeInterleave128c($2)  //specific to P&G as of 11/09/00 
		
	: ($1=129)
		$0:=BarCode_128auto($2)
		
	Else 
		$0:=$2
End case 