If ([Job_Forms_Master_Schedule:67]PressDate:25=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]PressDate:25; -(Grey:K11:15+(256*0)); True:C214)
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]PressDate:25; -(Black:K11:16+(256*0)); True:C214)
End if 