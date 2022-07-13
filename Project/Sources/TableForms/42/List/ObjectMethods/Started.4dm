If ([Job_Forms:42]StartDate:10=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms:42]StartDate:10; -(Grey:K11:15+(256*0)); True:C214)
Else 
	Core_ObjectSetColor(->[Job_Forms:42]StartDate:10; -(Black:K11:16+(256*0)); True:C214)
End if 