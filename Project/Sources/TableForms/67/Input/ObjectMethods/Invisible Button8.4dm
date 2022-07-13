If ([Job_Forms_Master_Schedule:67]DateStockDue:16#!00-00-00!)
	Cal_getDate(->[Job_Forms_Master_Schedule:67]DateStockDue:16; Month of:C24([Job_Forms_Master_Schedule:67]DateStockDue:16); Year of:C25([Job_Forms_Master_Schedule:67]DateStockDue:16))
Else 
	Cal_getDate(->[Job_Forms_Master_Schedule:67]DateStockDue:16)
End if 

//•120998  MLB Y2K Remediation 
//C_LONGINT($err)
//$err:=sDateLimitor (->DateStockDue;5)
If ([Job_Forms_Master_Schedule:67]DateStockDue:16=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateStockDue:16; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateStockDue:16; -(15+(256*12)))  //
End if 

//