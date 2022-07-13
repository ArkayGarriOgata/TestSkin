Case of 
	: ((Form event code:C388=On Load:K2:1) & Not:C34(Form event code:C388=On Display Detail:K2:22))
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Estimates:17]z_Bill_To_ID:5)
		Text2:=[Addresses:30]Name:2+Char:C90(13)
		Text2:=Text2+[Addresses:30]Address1:3+Char:C90(13)
		If ([Addresses:30]Address2:4#"")
			Text2:=Text2+[Addresses:30]Address2:4+Char:C90(13)
		End if 
		If ([Addresses:30]Address3:5#"")
			Text2:=Text2+[Addresses:30]Address3:5+Char:C90(13)
		End if 
		Text2:=Text2+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+Replace string:C233([Addresses:30]Zip:8; "_"; "")+" "
		If ([Addresses:30]Country:9#"USA")
			Text2:=Text2+[Addresses:30]Country:9
		End if 
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]CartonSpecKey:7; >; [Estimates_Carton_Specs:19]Item:1; >)
		C_LONGINT:C283($i)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE EMPTY SET:C140([Process_Specs:18]; "theseHereOnes")
			ARRAY TEXT:C222($pSpecs; 0)
			DISTINCT VALUES:C339([Estimates_Carton_Specs:19]ProcessSpec:3; $pSpecs)
			For ($i; 1; Size of array:C274($pSpecs))
				QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$pSpecs{$i})
				ADD TO SET:C119([Process_Specs:18]; "theseHereOnes")
			End for 
			USE SET:C118("theseHereOnes")
			CLEAR SET:C117("theseHereOnes")
			
		Else 
			
			RELATE ONE SELECTION:C349([Estimates_Carton_Specs:19]; [Process_Specs:18])
			
			
		End if   // END 4D Professional Services : January 2019 
		
End case 