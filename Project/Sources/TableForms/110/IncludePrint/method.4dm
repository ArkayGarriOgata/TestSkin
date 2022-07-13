//FM: Include() -> 
//@author mlb - 12/4/01  15:40

Case of 
	: (Form event code:C388=On Printing Detail:K2:18)
		//
		If (True:C214)  // New code
			PS_Included_OnDisplayDetail
		Else 
			If ([ProductionSchedules:110]Completed:23=0)
				
				PS_SetReadyColors
				
				C_OBJECT:C1216($oNameColor)
				$oNameColor:=New object:C1471()
				$oNameColor:=Cust_Name_ColorO([ProductionSchedules:110]Customer:11)
				
				OBJECT SET RGB COLORS:C628(*; "color@"; $oNameColor.nForeground; $oNameColor.nBackground)
				
				Case of 
					: ([ProductionSchedules:110]Priority:3=0)
						Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; -(White:K11:1+(256*Black:K11:16)))
					: ([ProductionSchedules:110]Priority:3<0)
						Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; -(Yellow:K11:2+(256*Red:K11:4)))
					Else 
						Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; -(Black:K11:16+(256*White:K11:1)))
				End case 
				
			Else   //
				PS_SetCompleteColors
			End if 
		End if 
End case 