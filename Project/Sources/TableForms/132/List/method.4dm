Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		app_basic_list_form_method
		
		$late:=-(Red:K11:4+(256*White:K11:1))
		$regular:=-(Black:K11:16+(256*White:K11:1))
		$hold:=-(Blue:K11:7+(256*White:K11:1))
		
		If ([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54>0)
			Core_ObjectSetColor(->[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1; -Brown:K11:14; True:C214)
			Core_ObjectSetColor(->[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54; -Brown:K11:14; True:C214)
		Else 
			Core_ObjectSetColor(->[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1; -Black:K11:16; True:C214)
			Core_ObjectSetColor(->[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54; -Black:K11:16; True:C214)
		End if 
		
		If ([Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!)
			If ([Finished_Goods_SizeAndStyles:132]Hold:59)
				Core_ObjectSetColor("*"; "ID@"; $hold; True:C214)
				
			Else 
				If ((Current date:C33-[Finished_Goods_SizeAndStyles:132]DateSubmitted:5)>5) & ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!)
					Core_ObjectSetColor("*"; "ID@"; $late; True:C214)
				Else 
					Core_ObjectSetColor("*"; "ID@"; $regular; True:C214)
				End if 
			End if 
			
		Else 
			Core_ObjectSetColor("*"; "ID@"; $regular; True:C214)
		End if 
		
		
		
	: (Form event code:C388=On Load:K2:1)
		b4:=1
		b5:=0
		b6:=0
		b7:=0
		lastTab:=<>Activitiy
		If (lastTab<1)  // Modified by: Mel Bohince (11/24/15) a zero causes a crash in v14.4
			lastTab:=1
		End if 
		SELECT LIST ITEMS BY POSITION:C381(iJMLtabs; lastTab)
		
		
End case 

