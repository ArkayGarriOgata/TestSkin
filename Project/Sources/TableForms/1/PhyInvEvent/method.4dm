// _______
// Method: [zz_control].PhyInvEvent   ( ) ->
//(lp) PhyInvEvent
//•2/28/97 cs upr1858 reemoved initialization of old ◊ PI array
//• 4/8/97 cs after PI cleanup
// Modified by: Mel Bohince (10/29/20) use object names, rmv the btn variables
// Modified by: MelvinBohince (1/11/22) enable buttons for designer login

Case of 
	: (Form event code:C388=On Load:K2:1)  //disble end button if PI not started, • 4/8/97 cs
		READ ONLY:C145([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		
		If (Current user:C182="Designer")
			OBJECT SET ENABLED:C1123(*; "PIactive@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "PIactive@"; [zz_control:1]InvInProgress:24)
		End if 
		
		
		If (User in group:C338(Current user:C182; "Physical Inv Manager"))
			OBJECT SET ENABLED:C1123(*; "CompareWMSaMs"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "PIactiveVoidRM"; False:C215)
			OBJECT SET ENABLED:C1123(*; "CompareWMSaMs"; False:C215)
		End if 
		
		
		
End case 