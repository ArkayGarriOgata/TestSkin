//Object Method: bSelect()  051099  MLB
//select the network volumn to store fwd files to dynamics server

[zz_control:1]TrelloBoardEmailAddress:55:=Select folder:C670("Select Shopfloor (aMs) Inbox")
If (ok=1)
	<>PATH_AMS_INBOX:=[zz_control:1]TrelloBoardEmailAddress:55
End if 
