
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="(Production Schedule;Presses;Die Cutters;Sheeting;(-;(412;421;(414;(415;(416;(-;452;454;455;467;468;469;474;475;(-;428"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=2)
					PS_ShowAll
				: ($user_choice=3)
					PS_ShowDC
				: ($user_choice=4)
					PS_Show497
				: ($user_choice=6)
					PS_Show412
				: ($user_choice=7)
					PS_Show421
				: ($user_choice=8)
					PS_Show414
				: ($user_choice=9)
					PS_Show415
				: ($user_choice=10)
					PS_Show416
				: ($user_choice=12)
					PS_Show452
				: ($user_choice=13)
					PS_Show454
				: ($user_choice=14)
					PS_Show455
				: ($user_choice=15)
					PS_Show467
				: ($user_choice=16)
					PS_Show468
				: ($user_choice=17)
					PS_Show469
				: ($user_choice=18)
					PS_Show474
				: ($user_choice=19)
					PS_Show475
				: ($user_choice=21)
					PS_Show497
			End case 
			
		Else 
			PS_ShowAll
		End if 
		
End case 


//EOS