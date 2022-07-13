Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (aSelected{ListBox1}="")
			Case of 
				: (asOrdStat{ListBox1}="C@")
					aSelected{ListBox1}:=""
					ALERT:C41("Can't revise Complete or Closed forms.")
				: (asOrdStat{ListBox1}="WIP")
					aSelected{ListBox1}:=""
					ALERT:C41("Can't revise forms that are in production.")
				Else 
					aSelected{ListBox1}:="X"
			End case 
			
		Else 
			aSelected{ListBox1}:=""
		End if 
		
		$hit:=Find in array:C230(aSelected; "X")
		If (Length:C16(tTitle)>0) & (Length:C16(sState)=2) & (iJobid>0) & ($hit>-1)
			OBJECT SET ENABLED:C1123(bRevise; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bRevise; False:C215)
		End if 
		
		
	: (Form event code:C388=On Double Clicked:K2:5)
		aSelected{ListBox1}:="X"
		If (Length:C16(tTitle)>0) & (Length:C16(sState)=2) & (iJobid>0)  // & ($hit>-1)
			bRevise:=1
			ACCEPT:C269
		End if 
End case 
