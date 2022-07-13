//
app_basic_list_form_method
//
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		Case of 
			: (bQuery=1)
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
		End case 
		//
	: ((Form event code:C388=On Display Detail:K2:22) | (Form event code:C388=On Printing Detail:K2:18))
		$green:=-(Green:K11:9+(256*Green:K11:9))
		$red:=-(Red:K11:4+(256*Red:K11:4))
		$yellow:=-(Yellow:K11:2+(256*Yellow:K11:2))
		$black:=-(Black:K11:16+(256*Black:K11:16))
		//
		For ($i; 1; 7)
			$ptField:=Field:C253(Table:C252(->[ProductionSchedules_Additional:170]); Field:C253(->[ProductionSchedules_Additional:170]Color_Column_1:2)-1+$i)
			Case of 
				: ($ptField->="Green")
					Core_ObjectSetColor($ptField; $green)
				: ($ptField->="Red")
					Core_ObjectSetColor($ptField; $red)
				: ($ptField->="Yellow")
					Core_ObjectSetColor($ptField; $yellow)
				: ($ptField->="Black")
					Core_ObjectSetColor($ptField; $black)
				Else 
					
			End case 
		End for 
End case 
//