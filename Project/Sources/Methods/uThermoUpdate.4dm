//%attributes = {"publishedWeb":true}
//Procedure: uThermoUpdate()  041996  MLB
//avoid thermoSet

C_LONGINT:C283($1; $2; $increment)
C_BOOLEAN:C305(useStatusBar)

If (Not:C34(Application type:C494=4D Server:K5:6))
	If (Count parameters:C259=1)
		$increment:=10
	Else 
		$increment:=$2
	End if 
	IDLE:C311
	If (($1%$increment)=0)
		If (useStatusBar)
			zwStatusTherm("update"; ""; $1)
			
		Else 
			GOTO XY:C161(1; 1)
			Case of 
				: ($Increment>0)  //positve incrment (count down)
					MESSAGE:C88(String:C10((ThermoMax-$1); "^^^,^^^,^^^")+" more")
				: ($Increment=0)  //positve incrment (count down)
					MESSAGE:C88(String:C10((ThermoMax); "^^^,^^^,^^^")+" more")
				Else   //negative increment count up (import other unknown duriation actions
					MESSAGE:C88(String:C10((ThermoMax+Abs:C99($1)); "^^^,^^^,^^^")+" Done")
			End case 
		End if 
	End if 
End if 