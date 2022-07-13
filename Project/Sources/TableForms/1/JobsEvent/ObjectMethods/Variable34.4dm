Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aJobRptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice<=0)
				: ($user_choice<10)
					If ($user_choice=6)
						If (User in group:C338(Current user:C182; "RoleCostAccountant"))
							ViewSetter(50; ->[Jobs:15]; <>aJobRptPop{$user_choice})
						Else 
							BEEP:C151
							ALERT:C41("You must be in the RoleCostAccountant group to run this report."; "Call x3186")
						End if 
					Else 
						If (User in group:C338(Current user:C182; "WorkInProcess"))
							ViewSetter(50; ->[Jobs:15]; <>aJobRptPop{$user_choice})
						Else 
							BEEP:C151
							ALERT:C41("You must be in the WorkInProcess group to run this report."; "Call x328")
						End if 
					End if 
					
				: ($user_choice=16)
					<>JFActivity:=3
					Job_JobBagReview
					
					
					//: ($user_choice=17)
					//uSpawnProcess ("rInkOrderForm";0;"Print Job Bag";True;True)
					//If (False)
					//rInkOrderForm 
					//End if 
					
				: ($user_choice=25)  //•081702  mlb  
					ViewSetter(7; ->[Estimates:17]; <>aJobRptPop{$user_choice})
					
				Else 
					ViewSetter(50; ->[Jobs:15]; <>aJobRptPop{$user_choice})
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 