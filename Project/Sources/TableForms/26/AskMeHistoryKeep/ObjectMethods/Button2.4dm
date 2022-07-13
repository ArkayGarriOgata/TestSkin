// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/17/13, 11:37:33
// ----------------------------------------------------
// Method: [Finished_Goods].AskMeHistoryKeep.Button2
// Description:
// First checks to make sure the user didn't choose over 40.
// ----------------------------------------------------

If (xlKeep<=40)
	ACCEPT:C269
Else 
	ALERT:C41("Please choose a number 40 or less.")
End if 