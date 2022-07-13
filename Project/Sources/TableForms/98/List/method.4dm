app_basic_list_form_method
Case of 
	: (Form event code:C388=On Load:K2:1)
		b1:=0
		b2:=0
		b3:=0
		b4:=0
		b5:=0
		b6:=1
		cb1:=0
		cb2:=1
		Li1:=0
		Li2:=0
		i3:=0
		Case of 
				//: (True)
				//lastTab:=<>Activitiy
			: (User in group:C338(Current user:C182; "RolePlanner"))
				lastTab:=2
			: (User in group:C338(Current user:C182; "RoleQA"))
				lastTab:=4
			: (User in group:C338(Current user:C182; "RoleImaging"))
				lastTab:=3
			: (User in group:C338(Current user:C182; "RoleCustomerService"))
				lastTab:=5
			: (User in group:C338(Current user:C182; "RoleSalesman"))
				lastTab:=6
			Else 
				lastTab:=7
		End case 
		
		C_TEXT:C284($itemText)
		If (lastTab<1)
			lastTab:=1
		End if 
		SELECT LIST ITEMS BY POSITION:C381(iJMLTabs; lastTab)
		GET LIST ITEM:C378(iJMLTabs; lastTab; $itemRef; $itemText)
		If (Length:C16($itemText)>0)
			winTitle:=$itemText+" "+fNameWindow(->[Finished_Goods_Specifications:98])
		Else 
			winTitle:=fNameWindow(->[Finished_Goods_Specifications:98])
		End if 
		
		//winTitle:=$itemText+" "+fNameWindow (->[Finished_Goods_Specifications])
		SET WINDOW TITLE:C213(winTitle)
		FORM GOTO PAGE:C247(1)
		//If (User in group(Current user;"RoleOperations"))
		//OBJECT SET ENABLED(bPriority;True)
		//Else 
		//OBJECT SET ENABLED(bPriority;False)
		//End if 
		
	: (Form event code:C388=On Display Detail:K2:22)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Finished_Goods_Specifications:98]FG_Key:1)
		//If ([Finished_Goods]Preflight)
		//xText:=[Finished_Goods]PreflightBy
		//If (Length(xText)=0)
		//xText:="X"
		//End if 
		//Else 
		//xText:=""
		//End if 
		
		xText:=""
		
		$red:=-(Red:K11:4+(256*Red:K11:4))
		$green:=-(White:K11:1+(256*Green:K11:9))
		$black:=-(White:K11:1+(256*Black:K11:16))
		$yellow:=-(Yellow:K11:2+(256*Black:K11:16))
		$late:=-(Red:K11:4+(256*White:K11:1))
		$regular:=-(Black:K11:16+(256*White:K11:1))
		$hold:=-(Blue:K11:7+(256*White:K11:1))
		
		$canDo:=True:C214
		
		
		If ([Finished_Goods_Specifications:98]Size_n_style:79#!00-00-00!)
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Size_n_style:79; $green)
		Else 
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Size_n_style:79; $red)
		End if 
		
		If ([Finished_Goods_Specifications:98]Colors:80#!00-00-00!)
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Colors:80; $green)
		Else 
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Colors:80; $red)
			$canDo:=False:C215
		End if 
		
		If ([Finished_Goods_Specifications:98]ProcessColors:81)
			If ([Finished_Goods_Specifications:98]MatchPrint:82#!00-00-00!)
				Core_ObjectSetColor(->[Finished_Goods_Specifications:98]MatchPrint:82; $green)
			Else 
				Core_ObjectSetColor(->[Finished_Goods_Specifications:98]MatchPrint:82; $red)
				$canDo:=False:C215
			End if 
			
			If ([Finished_Goods_Specifications:98]HiRez:83#!00-00-00!)
				Core_ObjectSetColor(->[Finished_Goods_Specifications:98]HiRez:83; $green)
			Else 
				Core_ObjectSetColor(->[Finished_Goods_Specifications:98]HiRez:83; $red)
				$canDo:=False:C215
			End if 
			
		Else 
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]MatchPrint:82; $green)
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]HiRez:83; $green)
		End if 
		
		If ([Finished_Goods_Specifications:98]PreApproved:67)  //• mlb - 3/20/03  15:51
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Approved:10; $green)
		Else 
			Core_ObjectSetColor(->[Finished_Goods_Specifications:98]Approved:10; $red)
			//$canDo:=False
		End if 
		
		If ([Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!)
			If ($canDo)
				If ((Current date:C33-[Finished_Goods_Specifications:98]DateSubmitted:5)>5) & ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)
					Core_ObjectSetColor("*"; "ID@"; $late; True:C214)
				Else 
					Core_ObjectSetColor("*"; "ID@"; $regular; True:C214)
				End if 
			Else 
				Core_ObjectSetColor("*"; "ID@"; $regular; True:C214)
			End if 
			
		Else 
			Core_ObjectSetColor("*"; "ID@"; $regular; True:C214)
		End if 
		
		If ([Finished_Goods_Specifications:98]Status:68="0n Hold")
			Core_ObjectSetColor("*"; "ID@"; $hold; True:C214)
			//OBJECT SET COLOR([Finished_Goods_Specifications]DateSubmitted;$yellow)
			//OBJECT SET COLOR([Finished_Goods_Specifications]DateArtReceived;$yellow)
			//OBJECT SET COLOR([Finished_Goods_Specifications]DatePrepDone;$yellow)
		Else 
			If ([Finished_Goods_Specifications:98]Status:68="7 Filed")
				Core_ObjectSetColor("*"; "c@"; $green)
			Else 
				If ([Finished_Goods_Specifications:98]Status:68="6 Rejected")
					Core_ObjectSetColor("*"; "c@"; $black)
					
				Else 
					Core_ObjectSetColor("*"; "c@"; $red)
					
					If ([Finished_Goods_Specifications:98]Status:68="5 Customer")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSentToCustomer:8; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateProofRead:7; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="4 Mail Room")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateProofRead:7; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="3 Quality")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DatePrepDone:6; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="2 Imaging")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; $green)
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
					If ([Finished_Goods_Specifications:98]Status:68="1 Planning")
						Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateArtReceived:63; $green)
					End if 
				End if 
			End if 
		End if 
End case 