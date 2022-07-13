If (aAskMeMulti#0)
	$fgKey:=aAskMeMulti{aAskMeMulti}
	sCustId:=Substring:C12($fgKey; 1; 5)
	sCPN:=Substring:C12($fgKey; 7)
	ARRAY TEXT:C222($aTemp; 0)
	COPY ARRAY:C226(aAskMeMulti; $aTemp)
	sAskMeCPN(sCPN)
	COPY ARRAY:C226($aTemp; aAskMeMulti)
End if 