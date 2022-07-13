//(s) bPost
If (sCriterion4="")
	uConfirm("You Must enter a Color for this Ink or Coating."; "Try Again"; "Help")
	GOTO OBJECT:C206(sCriterion4)
	REJECT:C38
End if 
//