//(s) [BOL]ship.dio
//• 8/13/97 cs created keep user from modifying previous month data
If (Month of:C24(Self:C308->)#Month of:C24(4D_Current_date))  //• 8/13/97 cs 
	ALERT:C41("You may NOT change the date in such a way as to modify the previous"+" month's shipping records."+Char:C90(13)+Char:C90(13)+"Return the product (if needed), then ship using today's date.")  //• 8/13/97 cs 
	Self:C308->:=4D_Current_date  //• 8/13/97 cs 
End if 
//