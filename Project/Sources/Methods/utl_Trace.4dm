//%attributes = {"publishedWeb":true}
// utl_Trace({1}{;msg in compilemode}) KBK 031698
//•020399  MLB  extend concept

C_BOOLEAN:C305($trace)
C_REAL:C285($1)  //debug mode if not 0

If (Current user:C182="Designer") | (Application type:C494=4D Server:K5:6)  //*Only trace while designer
	$trace:=False:C215
	If (Caps lock down:C547)  //*Caplocks is the physical switch
		$trace:=True:C214
	Else 
		If (Count parameters:C259>0)
			If ($1#0)
				$trace:=True:C214
			End if 
		End if 
	End if 
	
	If ($trace)
		If (Is compiled mode:C492)
			If (Count parameters:C259>=2)
				ALERT:C41($2+Char:C90(13)+"CAPLOCKS ON?")
				DELAY PROCESS:C323(Current process:C322; 60)
				IDLE:C311
			End if 
		Else 
			TRACE:C157
		End if 
	End if 
End if 