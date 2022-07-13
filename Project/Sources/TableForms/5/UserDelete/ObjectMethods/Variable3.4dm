//(S) [USER]UserDelete'bSearch
QUERY:C277([Users:5]; [Users:5]Initials:1=sCriterion)
If (Records in selection:C76([Users:5])=0)
	uNoneFound
	REJECT:C38
End if 
//EOS