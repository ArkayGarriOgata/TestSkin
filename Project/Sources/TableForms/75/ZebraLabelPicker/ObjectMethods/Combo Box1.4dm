$paren:=Position:C15("("; tcpAddresses{0})
If ($paren>0)
	tcpAddress:=Substring:C12(tcpAddresses{0}; 1; $paren-1)
Else 
	tcpAddress:=tcpAddresses{0}
End if 

//If (Length(tcpAddress)>0)
//$zebraDefaults:=util_UserPreference ("get";"ZebraIP-"+tcpAddress)
//If (Length($zebraDefaults)>0)
//sCriterion1:=Replace string(Substring($zebraDefaults;1;2);" ";"")  `Print speed
//sCriterion2:=Replace string(Substring($zebraDefaults;3;4);" ";"")  `x origin
//sCriterion3:=Replace string(Substring($zebraDefaults;7;4);" ";"")  `y origin
//tcpPort:=Num(Substring($zebraDefaults;11))
//End if 
//End if 
