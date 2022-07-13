//(s) dDate [raw_Material]POarray
//• 8/13/97 cs stop modifications to previouos month data
//• cs 9/8/97 allow Mellisa to get around date range check
//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 4; 4)

If (Month of:C24(Self:C308->)#Month of:C24(4D_Current_date)) & (Not:C34(User in group:C338(Current user:C182; "RoleCostAccountant")))  //• 8/13/97 cs , • cs 9/8/97 allow melissa to get around this
	ALERT:C41("You may NOT change the date in such a way as to modify the previous"+" month's receipts."+Char:C90(13)+Char:C90(13)+"Just receive the item(s) using today's date.")  //• 8/13/97 cs 
	Self:C308->:=4D_Current_date  //• 8/13/97 cs 
Else 
	//gRmDateLimit (Self)
End if 
//