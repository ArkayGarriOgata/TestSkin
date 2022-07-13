//FM: Include() -> 
//@author mlb - 12/4/01  15:40

$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
		<>AA_PNGA_CHANGED_2011_02_22:=True:C214
		PS_Included_OnDisplayDetail
		
		//If ([ProductionSchedules]Completed=0)
		//PS_SetReadyColors 
		//$color:=PS_SetCustColor ([ProductionSchedules]Customer)
		//SET COLOR(*;"color@";$color)
		//Case of 
		//: ([ProductionSchedules]Priority=0)
		//SET COLOR([ProductionSchedules]Priority;-(White +(256*Black )))
		//: ([ProductionSchedules]Priority<0)
		//SET COLOR([ProductionSchedules]Priority;-(Yellow +(256*Red )))
		//Else 
		//SET COLOR([ProductionSchedules]Priority;-(Black +(256*White )))
		//End case 
		//
		//Else   `
		//PS_SetCompleteColors 
		//End if 
		<>AA_PNGA_CHANGED_2011_02_22:=False:C215
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([ProductionSchedules:110]; "clickedIncludeRecord")
		
		If ([ProductionSchedules:110]Completed:23=0)
			
			PS_SetReadyColors
			
			C_OBJECT:C1216($oNameColor)
			$oNameColor:=New object:C1471()
			$oNameColor:=Cust_Name_ColorO([ProductionSchedules:110]Customer:11)
			
			OBJECT SET RGB COLORS:C628(*; "color@"; $oNameColor.nForeground; $oNameColor.nBackground)
			
			Case of 
				: ([ProductionSchedules:110]Priority:3=0)
					Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; -(White:K11:1+(256*Black:K11:16)); True:C214)
				: ([ProductionSchedules:110]Priority:3<0)
					Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; -(Yellow:K11:2+(256*Red:K11:4)); True:C214)
				Else 
					Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; -(Black:K11:16+(256*White:K11:1)); True:C214)
			End case 
			
		Else   //
			PS_SetCompleteColors
		End if 
		
	: ($e=On Data Change:K2:15)
		SAVE RECORD:C53([ProductionSchedules:110])
End case 