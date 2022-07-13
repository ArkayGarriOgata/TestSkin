//%attributes = {}
// Method: ADDR_getInfoWithCache("addressID") -> country, city, name
// ----------------------------------------------------
// User name (OS): Mel Bohince : 06/16/20, 09:11:50
// ----------------------------------------------------
// Description
// need to init without parameters before use
//---------------------------------------------
// Modified by: Mel Bohince (1/26/21) remove City

C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($hit)
C_OBJECT:C1216($addr_es)

If (Count parameters:C259=0)  //init
	ARRAY TEXT:C222(aADDR_Info_Cache; 0)
	ARRAY TEXT:C222(aADDR_ID_Cache; 0)
	$0:="init"
	
Else 
	
	$hit:=Find in array:C230(aADDR_ID_Cache; $1)  //check the cache
	If ($hit>-1)
		$0:=aADDR_Info_Cache{$hit}
		
	Else   //ask the server
		$addr_es:=ds:C1482.Addresses.query("ID = :1"; $1)
		If ($addr_es.length>0)  //query and add to the hash table
			APPEND TO ARRAY:C911(aADDR_ID_Cache; $addr_es.first().ID)
			//$info:=$addr_es.first().Country+", "+$addr_es.first().City+", "+$addr_es.first().Name
			$info:=$addr_es.first().Country+", "+$addr_es.first().Name  // Modified by: Mel Bohince (1/26/21) remove City
			
			APPEND TO ARRAY:C911(aADDR_Info_Cache; $info)
			$0:=$info
			
		Else   //invalid id
			$0:="N/F"
		End if   //valid id
	End if   //using cache
End if   //params

//