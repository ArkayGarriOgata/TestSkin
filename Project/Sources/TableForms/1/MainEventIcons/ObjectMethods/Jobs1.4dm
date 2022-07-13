//(S) ibCustOrd
//StartJobs 

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			Case of 
				: (User in group:C338(Current user:C182; "Planners"))
					$menu_items:="(Jobs;Plan via Project Center;Modify...;Review...;(-;Job Bags Review;(Modify Actuals"
				: (User in group:C338(Current user:C182; "RoleCostAccountant"))
					$menu_items:="(Jobs;Plan via Project Center;Modify...;Review...;(-;Job Bags Review;Modify Actuals"
				Else 
					$menu_items:="(Jobs;(Plan via Project Center;(Modify...;Review...;(-;Job Bags Review;(Modify Actuals"
			End case 
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=6)
					<>JFActivity:=3
					Job_JobBagReview
				: ($user_choice=7)
					If (Size of array:C274(<>asJobAPages)=0)
						ARRAY TEXT:C222(<>asJobAPages; 6)
						<>asJobAPages{1}:="Actual"
						<>asJobAPages{2}:="Machine"
						<>asJobAPages{3}:="Material"
						<>asJobAPages{4}:="Summary"
						<>asJobAPages{5}:="Good/Waste Units"
						<>asJobAPages{6}:="Transfers"
					End if 
					<>JFActivity:=2
					ViewSetter(2; ->[Job_Forms:42])
				: ($user_choice=2)
					Pjt_ProjectUserInterface
				: ($user_choice>2)
					ViewSetter($user_choice-1; ->[Jobs:15])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("JOB_OpenPalette"; "$Jobs Palette")
			//EOS
			If (False:C215)
				JOB_OpenPalette
			End if 
		End if 
		
End case 