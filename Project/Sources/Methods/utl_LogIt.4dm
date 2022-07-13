//%attributes = {"publishedWeb":true}
//PM:  utl_LogIt  9/14/99  MLB
//record activity

C_TEXT:C284(tCalculationLog; $1; tWindowTitle; $3)
C_TEXT:C284(flasher)
C_LONGINT:C283($2)  //suppress flasher

Case of 
	: ($1="init")
		tCalculationLog:=""
		flasher:=""
		
		
	: ($1="show")
		BEEP:C151
		If (False:C215)
			$winRef:=OpenFormWindow(->[zz_control:1]; "text2_dio")
			t1:=tCalculationLog
			DIALOG:C40([zz_control:1]; "text2_dio")
			CLOSE WINDOW:C154
			t1:=""
		Else 
			If (Count parameters:C259=3)
				tWindowTitle:=$3
			Else 
				tWindowTitle:="utl_Logit"
			End if 
			
			$winRef:=Open form window:C675("DisplayText")
			C_OBJECT:C1216($t)
			$t:=New object:C1471("text"; tCalculationLog; "title"; tWindowTitle)
			DIALOG:C40("DisplayText"; $t; *)
			CLOSE WINDOW:C154
		End if 
		
	Else 
		tCalculationLog:=tCalculationLog+$1+Char:C90(13)
		
		
		If (Count parameters:C259=1)
			If (flasher="•o")
				flasher:="o•"
			Else 
				flasher:="•o"
			End if 
			GOTO XY:C161(24; 5)
			MESSAGE:C88(flasher)
		End if 
End case 