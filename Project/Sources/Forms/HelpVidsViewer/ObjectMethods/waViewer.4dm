Case of 
	: (Form event code:C388=On End URL Loading:K2:47)
		If (abVideoLB+1<Size of array:C274(abVideoLB))  //Check this first to avoid an error.
			If (atChapter{abVideoLB+1}="Chapter@")
				WA OPEN URL:C1020(waViewer; atPath{abVideoLB+1})
			End if 
		End if 
		
End case 