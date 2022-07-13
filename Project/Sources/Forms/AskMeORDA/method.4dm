// _______
// Method: AskMeORDA   ( ) ->
// By: Mel Bohince @ 09/27/19, 09:19:59
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Length:C16(<>AskMeFG)>0)
			sCPN:=<>AskMeFG
			<>AskMeFG:=""
		End if 
		
		AskMeHistory("LoadAll")
		
End case 
