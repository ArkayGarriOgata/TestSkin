//PSG_UI_SetOptions 
//PSG_HideRows 

Case of 
	: (Form event code:C388=On Load:K2:1)
		//Progress group
		rb1:=0
		rb2:=0
		rb3:=0
		rb4:=0
		Case of 
			: (psg_progress="Anything")
				rb1:=1
			: (psg_progress="WIP")
				rb2:=1
			: (psg_progress="Printed")
				rb3:=1
			: (psg_progress="D/C")
				rb4:=1
		End case 
		
		// Added by: Mel Bohince (6/27/19) 
		//Assignment Group
		COPY ARRAY:C226(<>aGluers; aCCname)
		SORT ARRAY:C229(aCCname; >)
		APPEND TO ARRAY:C911(aCCname; "491")
		APPEND TO ARRAY:C911(aCCname; "493")
		APPEND TO ARRAY:C911(aCCname; "503")
		APPEND TO ARRAY:C911(aCCname; "505")
		APPEND TO ARRAY:C911(aCCname; "9xx")
		APPEND TO ARRAY:C911(aCCname; "ALL")
		APPEND TO ARRAY:C911(aCCname; "N/A")
		ARRAY BOOLEAN:C223(abOK; 0)
		ARRAY BOOLEAN:C223(abOK; Size of array:C274(aCCname))
		
		If (psg_assignments=(<>Gluers+" 9xx N/A"))
			$hit:=Find in array:C230(aCCname; "ALL")
			abOK{$hit}:=True:C214
		Else 
			For ($i; 1; Size of array:C274(aCCname))
				If (Position:C15(aCCname{$i}; psg_assignments)>0)
					abOK{$i}:=True:C214
				End if 
			End for 
		End if 
		
		If (False:C215)
			For ($i; 1; 12)
				$check_box_ptr:=Get pointer:C304("cb"+String:C10($i))
				$check_box_ptr->:=0
			End for 
			
			Case of 
				: (psg_assignments=(<>Gluers+" 9xx N/A"))
					cb1:=1
					
				Else   //what a mess, individually tic them off, I am
					If (Position:C15("N/A"; psg_assignments)>0)
						cb2:=1
					End if 
					If (Position:C15("476"; psg_assignments)>0)
						cb3:=1
					End if 
					If (Position:C15("478"; psg_assignments)>0)
						cb5:=1
					End if 
					If (Position:C15("480"; psg_assignments)>0)
						cb6:=1
					End if 
					If (Position:C15("481"; psg_assignments)>0)
						cb4:=1
					End if 
					If (Position:C15("482"; psg_assignments)>0)
						cb10:=1
					End if 
					If (Position:C15("483"; psg_assignments)>0)
						cb12:=1
					End if 
					If (Position:C15("484"; psg_assignments)>0)
						cb8:=1
					End if 
					If (Position:C15("485"; psg_assignments)>0)
						cb7:=1
					End if 
					If (Position:C15("493"; psg_assignments)>0)
						cb11:=1
					End if 
					If (Position:C15("9xx"; psg_assignments)>0)
						cb9:=1
					End if 
			End case 
		End if   //false
		
		//Timing Group
		f1:=0
		f2:=0
		Case of 
			: (psg_timeing="3 Day Rush")
				f1:=1
			: (psg_timeing="All Releases")
				f2:=1
		End case 
		
		OBJECT SET ENABLED:C1123(bSort; False:C215)
		
		If (User in group:C338(Current user:C182; "Role_Glue_Scheduling"))
			OBJECT SET ENABLED:C1123(bPriority; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPriority; False:C215)
		End if 
		
		
	: (Form event code:C388=On Unload:K2:2)
		psg_progress:=("Anything"*rb1)+("WIP"*rb2)+("Printed"*rb3)+("D/C"*rb4)
		
		psg_assignments:=""  //start fresh
		$hit:=Find in array:C230(aCCname; "ALL")
		If (abOK{$hit})  //all
			psg_assignments:=<>Gluers+" 9xx N/A"
		Else 
			For ($i; 1; Size of array:C274(aCCname))
				If (abOK{$i})
					psg_assignments:=psg_assignments+" "+aCCname{$i}
				End if 
			End for 
		End if 
		
		If (False:C215)
			If (cb1=1)  //***TODO
				psg_assignments:=<>Gluers+" 9xx N/A"
				
			Else 
				
				psg_assignments:=""
				If (cb2=1)
					psg_assignments:=psg_assignments+" N/A"
				End if 
				If (cb3=1)
					psg_assignments:=psg_assignments+" 476"
				End if 
				If (cb4=1)
					psg_assignments:=psg_assignments+" 481"
				End if 
				If (cb5=1)
					psg_assignments:=psg_assignments+" 478"
				End if 
				
				If (cb6=1)
					psg_assignments:=psg_assignments+" 480"
				End if 
				If (cb7=1)
					psg_assignments:=psg_assignments+" 485"
				End if 
				If (cb8=1)
					psg_assignments:=psg_assignments+" 484"
				End if 
				If (cb9=1)
					psg_assignments:=psg_assignments+" 9xx"
				End if 
				
				If (cb10=1)
					psg_assignments:=psg_assignments+" 482"
				End if 
				If (cb11=1)
					psg_assignments:=psg_assignments+" 493"
				End if 
				If (cb12=1)
					psg_assignments:=psg_assignments+" 483"
				End if 
				
			End if 
		End if   //false
		
		psg_timeing:=("3 Day Rush"*f1)+("All Releases"*f2)
End case 

