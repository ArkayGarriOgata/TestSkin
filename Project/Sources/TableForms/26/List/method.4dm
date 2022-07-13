app_basic_list_form_method
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		$active:=-(Black:K11:16+(256*White:K11:1))
		$inactive:=-(Light blue:K11:8+(256*Light grey:K11:13))
		If ([Finished_Goods:26]FRCST_NumberOfReleases:69>0)
			OBJECT SET FONT STYLE:C166(*; "a@"; Bold:K14:2)
			Core_ObjectSetColor("*"; "a@"; $active; True:C214)
			$color:=$active
		Else 
			Core_ObjectSetColor("*"; "a@"; $inactive; True:C214)
			OBJECT SET FONT STYLE:C166(*; "a@"; Plain:K14:1)
			$color:=$inactive
		End if 
		
		$isLaunchHold:=-(Red:K11:4+(256*Light grey:K11:13))
		$isLaunch:=-(Orange:K11:3+(256*Light grey:K11:13))
		If (FG_LaunchItem("is"; [Finished_Goods:26]ProductCode:1))
			If (FG_LaunchItem("hold"; [Finished_Goods:26]ProductCode:1))
				Core_ObjectSetColor("*"; "a@"; $isLaunchHold; True:C214)
			Else 
				Core_ObjectSetColor("*"; "a@"; $isLaunch; True:C214)
			End if 
			
		Else 
			Core_ObjectSetColor("*"; "a@"; $color; True:C214)
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		If (Read only state:C362([Finished_Goods:26]))
			OBJECT SET VISIBLE:C603(*; "Search@"; False:C215)
		Else 
			OBJECT SET VISIBLE:C603(*; "Search@"; True:C214)
		End if 
		
End case 