//(s) baOK [control]ombinePoItems
//• 6/20/97 cs created
If (Find in array:C230(aBullet; "•")<0)
	ALERT:C41("You Must Select at least one PO to move, to accept this dialog.")
	REJECT:C38
End if 