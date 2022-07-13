//%attributes = {}
// Method: txt_ToCSV(->text{;obj.property}) -> text version, quoted if necessary
// By: Mel Bohince @ 05/13/20, 07:38:52
// ----------------------------------------------------
// Description
// prepare an objection property to be included in a CSV document.
// see also txt_ToCSV_attribute(obj;"property")
// ----------------------------------------------------

C_POINTER:C301($1)
C_TEXT:C284($0)

$type:=Value type:C1509($1->)
Case of 
	: ($type=Is text:K8:3)
		$0:=txt_quote($1->)
		
	: ($type=Is boolean:K8:9)
		$0:=txt_quote(String:C10(Num:C11($1->); "True;;False"))
		
	: ($type=Is date:K8:7)  //date, no quotes
		$0:=String:C10($1->; Internal date short special:K1:4)
		
	Else   //number, no quotes
		$0:=String:C10($1->)
End case 

If (False:C215)  //TESTING:
	//C_TEXT($text)
	//$text:="johnson, mark"
	//$rtn_t:=txt_ToCSV (->$text)
	
	//C_LONGINT($long)
	//$long:=12345
	//$rtn_t:=txt_ToCSV (->$long)
	
	//C_REAL($real)
	//$real:=12345.12
	//$rtn_t:=txt_ToCSV (->$real)
	
	//C_DATE($date)
	//$date:=Current date
	//$rtn_t:=txt_ToCSV (->$date)
	
	//C_BOOLEAN($bool)
	//$bool:=False
	//$rtn_t:=txt_ToCSV (->$bool)
	
	//$bool:=True
	//$rtn_t:=txt_ToCSV (->$bool)
End if 



