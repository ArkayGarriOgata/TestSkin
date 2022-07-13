//%attributes = {}
// Method: util_ConvertAscii (winAsciiCode{;macAsciiCode) -> platform converted code 
// ----------------------------------------------------
// by: mel: 12/27/04, 14:25:58
// ----------------------------------------------------
// Description:
// return the Mac dec. equivelent of a Window's dec. ascii code
// Updates:
// see <http://www.idautomation.com/code128faq.html> and 
//<http://www.4d.com/docs/CMU/CMU10119.HTM>
// ----------------------------------------------------
C_LONGINT:C283($1; $0)
C_TEXT:C284($platform)
$platform:="WIN"  //get environment

If (Count parameters:C259=1)  //covert win to mac
	Case of 
		: ($platform="WIN")  //don't convert
			//$0:=Ascii(Win to Mac(Char($1)))
			$0:=$1
		: ($1=194)
			$0:=229
		: ($1=195)
			$0:=204
		: ($1=196)
			$0:=128
		: ($1=197)
			$0:=129
		: ($1=198)
			$0:=174
		: ($1=199)
			$0:=130
		: ($1=200)
			$0:=233
		: ($1=201)
			$0:=131
		: ($1=202)
			$0:=230
		: ($1=203)
			$0:=232
		: ($1=204)
			$0:=237
		: ($1=205)
			$0:=234
		: ($1=206)
			$0:=235
		Else 
			$0:=$1  //just return what you got passed
	End case 
	
Else   //convert mac to win
	Case of 
		: ($platform="WIN")  //don't convert
			//$0:=Ascii(Mac to Win(Char($1)))
			$0:=$2
		: ($2=229)
			$0:=194
		: ($2=204)
			$0:=195
		: ($2=128)
			$0:=196
		: ($2=129)
			$0:=197
		: ($2=174)
			$0:=198
		: ($2=130)
			$0:=199
		: ($2=233)
			$0:=200
		: ($2=131)
			$0:=201
		: ($2=230)
			$0:=202
		: ($2=232)
			$0:=203
		: ($2=237)
			$0:=204
		: ($2=234)
			$0:=205
		: ($2=235)
			$0:=206
		Else 
			$0:=$2  //just return what you got passed
	End case 
	
End if 

