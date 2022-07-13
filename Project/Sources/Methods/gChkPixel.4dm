//%attributes = {"publishedWeb":true}
//(P) gChkPixel
//----------------------------------------------
//• 12/15/97 cs added incomming parameter flag (if not empty) to print
//NEW JCO header, not old
//• 7/29/98 cs made pixel count smaller (again)(iPixel>710) now690

C_TEXT:C284($1)
C_BOOLEAN:C305($PrintNew)

iPixel:=iPixel+12

Case of   //• 12/15/97 cs 
	: (Count parameters:C259=0)
		$PrintNew:=False:C215
	: (Count parameters:C259=1) & ($1#"")
		$PrintNew:=True:C214
	Else 
		$PrintNew:=False:C215
End case 

//• 12/16/97 cs made pixel count smaller If (iPixel>760)
//• 7/29/98 cs made pixel count smaller (again)(iPixel>710)
If (iPixel>690)
	iPixel:=120
	iPage:=iPage+1
	PAGE BREAK:C6(>)
	BEEP:C151
	If (fHdgChg)
		Print form:C5([Job_Forms:42]; "CloseoutRept_H3")
	Else 
		If (Not:C34($PrintNew))
			Print form:C5([Job_Forms:42]; "CloseoutRept_H1")
		Else 
			Print form:C5([Job_Forms:42]; "NewJCORpt.h")
		End if 
	End if 
End if 