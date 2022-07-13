//%attributes = {"publishedWeb":true}
C_TEXT:C284($proc)
C_BOOLEAN:C305($error)

$error:=False:C215
$proc:=""

Repeat 
	$proc:=Request:C163("Execute procedure:"; $proc)
	If (ok=1)
		Case of 
			: ($proc="")
				$error:=True:C214
			: ((Position:C15("("; $proc)=0) & (Length:C16($proc)>15))
				$error:=True:C214
			: ((Substring:C12($proc; 1; 1)>="0") & (Substring:C12($proc; 1; 1)<="9"))
				$error:=True:C214
			: (Position:C15("*"; $proc)>0)
				$error:=True:C214
			: (Position:C15("+"; $proc)>0)
				$error:=True:C214
			: (Position:C15("."; $proc)>0)
				$error:=True:C214
			: (Position:C15("/"; $proc)>0)
				$error:=True:C214
			: (Position:C15("\\"; $proc)>0)
				$error:=True:C214
			: (Position:C15(":"; $proc)>0)
				$error:=True:C214
			Else 
				MESSAGE:C88("Executing procedure "+$proc)
				EXECUTE FORMULA:C63($proc)
				ABORT:C156
		End case 
		If ($error)
			BEEP:C151
			ALERT:C41("Invalid procedure name -> "+$proc)
		End if 
	End if 
Until (OK=0)