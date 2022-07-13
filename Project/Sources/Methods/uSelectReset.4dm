//%attributes = {"publishedWeb":true}
//(P) uSelectReset: Resets select dialog criterion filter and format
// SetObjectProperties, Mark Zinke (5/16/13)

C_LONGINT:C283($len; $type; $1)  //$1=Button number selected

zSelectNum:=$1
sCriterion1:=""
sCriterion2:=""
sCriterion3:=""
sCriterion4:=""

GET FIELD PROPERTIES:C258(aSlctField{zSelectNum}; $type; $len)
GOTO OBJECT:C206(sCriterion1)
SetObjectProperties("notBool@"; -><>NULL; True:C214)

Case of 
	: ($type=0) | ($type=2) | ($type=24)  //string, text or string
		SetObjectProperties("contains@"; -><>NULL; True:C214)
		GOTO OBJECT:C206(sCriterion4)
		//uSelAlphReset 
	: ($type=1) | ($type=8) | ($type=9)  //real, int, longint
		SetObjectProperties("contains@"; -><>NULL; False:C215)
		//uSelRealReset 
	: ($type=4)  //date
		SetObjectProperties("contains@"; -><>NULL; False:C215)
		//uSelDateReset 
	: ($type=6)  //boolean
		SetObjectProperties("contains@"; -><>NULL; False:C215)
		SetObjectProperties("notBool@"; -><>NULL; False:C215)
		sCriterion1:="True"
End case 