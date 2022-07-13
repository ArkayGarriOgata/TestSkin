uConfirm("Get Serial Information?"; "Yes"; "No")
If (ok=1)
	GET SERIAL INFORMATION:C696($key; $user; $company; $connected; $maxUser)
	ALERT:C41("Key= "+String:C10($key)+Char:C90(13)+"User= "+$user+Char:C90(13)+"Company= "+$company+Char:C90(13)+"#Connected= "+String:C10($connected)+Char:C90(13)+"Max#Users= "+String:C10($maxUser))
End if 