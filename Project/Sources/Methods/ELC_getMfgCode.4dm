//%attributes = {}
// -------
// Method: ELC_getMfgCode   ( ) ->
// By: Mel Bohince @ 05/02/18, 16:53:26
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/18) always use COL

C_TEXT:C284($0; mfg_code; $cpn; $run; $mthStr; $yr; $1)
//C_LONGINT($a;$mth)
$0:="COL"  // Modified by: Mel Bohince (5/6/18) always use COL

//$cpn:=$1  //[Job_Forms_Items]ProductCode  //still has hyphens
//$a:=Character code("A")-1
//ARRAY TEXT($jobits;0)
//Begin SQL
//SELECT distinct Jobit
//from Job_Forms_Items
//where ProductCode = :$cpn
//into :$jobits
//End SQL

//$run:=Char($a+Size of array($jobits))
//$mth:=Month of(wmsDateMfg)

//Case of 
//: ($mth=10)
//$mthStr:="A"
//: ($mth=11)
//$mthStr:="B"
//: ($mth=12)
//$mthStr:="C"
//Else 
//$mthStr:=String($mth)
//End case 

//$yr:=Substring(String(Year of(wmsDateMfg));4;1)
//$0:=$run+$mthStr+$yr