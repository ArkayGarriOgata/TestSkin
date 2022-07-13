//Object Method: bSelect()  051099  MLB
//select the network volumn to store fwd files to dynamics server

[zz_control:1]ShopfloorPathOutbox:54:=Select folder:C670("Select Shopfloor (Flex) Inbox")
If (ok=1)
	<>PATH_FLEX_INBOX:=[zz_control:1]ShopfloorPathOutbox:54
End if 
