//%attributes = {"publishedWeb":true}
//(p) VenSumSetFlag
//sets the 20% verience flag for reporting
//uses real 1 - 14 see rBasicVensum
C_TEXT:C284(xText)
C_REAL:C285($Real120; $Real220; $Real520; $Real620; $Real920; $Real1020)
xText:=""
$Real120:=real1*0.2
$Real220:=real2*0.2
$Real520:=real5*0.2
$Real620:=real6*0.2
$Real920:=real9*0.2
$Real1020:=real10*0.2

Case of 
	: ((real1+$Real120)>real3) | ((real1-$real120)<Real3)
		xText:="••"
	: ((real2+$Real220)>real4) | ((real2-$real220)<Real4)
		xText:="••"
	: ((real5+$Real520)>real7) | ((real5-$real520)<Real7)
		xText:="••"
	: ((real6+$Real620)>real8) | ((real6-$real620)<Real8)
		xText:="••"
	: ((real9+$Real920)>real11) | ((real9-$real920)<Real11)
		xText:="••"
	: ((real1+$Real1020)>real12) | ((real1-$real1020)<Real12)
		xText:="••"
End case 
//