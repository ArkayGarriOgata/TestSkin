//%attributes = {}
// Method: ELC_isEsteeLauderCompany () -> 
// ----------------------------------------------------
// by: mel: 04/27/04, 09:52:03
// ----------------------------------------------------
// Description:
// Test if a custid is an estee lauder company
// ----------------------------------------------------

C_LONGINT:C283($i)
C_TEXT:C284($1)  //custid
C_BOOLEAN:C305($0)

If (Count parameters:C259=1)
	$0:=(Position:C15($1; <>EL_Companies)>0)
	
Else   //set in app_CommonArrays at startup
	If (Length:C16(sEL_Companies)=0)  //init it
		ARRAY TEXT:C222($aEsteeCompany; 0)
		READ ONLY:C145([Customers:16])
		QUERY:C277([Customers:16]; [Customers:16]ParentCorp:19="Estée Lauder Companies")
		SELECTION TO ARRAY:C260([Customers:16]ID:1; $aEsteeCompany)
		REDUCE SELECTION:C351([Customers:16]; 0)
		sEL_Companies:=" "
		For ($i; 1; Size of array:C274($aEsteeCompany))
			sEL_Companies:=sEL_Companies+$aEsteeCompany{$i}+" "
		End for 
		$0:=(Length:C16(sEL_Companies)>1)
	End if 
End if 