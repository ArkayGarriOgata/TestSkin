//Layout Proc.: JobTrack()  072595  MLB

Case of 
	: (Form event code:C388=On Printing Detail:K2:18)
		t4:=f5CharDate(->[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12)
		t5:=f5CharDate(->[Job_Forms_Master_Schedule:67]DateFinalToolApproved:18)
		t6:=f5CharDate(->[Job_Forms_Master_Schedule:67]DateStockDue:16)
		t7:=f5CharDate(->[Job_Forms_Master_Schedule:67]DateStockRecd:17)
		t8:=f5CharDate(->[Job_Forms_Master_Schedule:67]PlannerReleased:14)
		t9:=f5CharDate(->[Job_Forms_Master_Schedule:67]EnterOrderDate:9)
		t10:=f5CharDate(->[Job_Forms_Master_Schedule:67]CustWantDate:10)
		t11:=f5CharDate(->[Job_Forms_Master_Schedule:67]MAD:21)
		t12:=f5CharDate(->[Job_Forms_Master_Schedule:67]PressDate:25)
		t13:=f5CharDate(->[Job_Forms_Master_Schedule:67]FirstReleaseDat:13)
		t14:=f5CharDate(->[Job_Forms_Master_Schedule:67]ActualFirstShip:19)
		t15:=f5CharDate(->[Job_Forms_Master_Schedule:67]Printed:32)
		t16:=f5CharDate(->[Job_Forms_Master_Schedule:67]OrigRevDate:20)
		t17:=f5CharDate(->[Job_Forms_Master_Schedule:67]GlueReady:28)
		t18:=f5CharDate(->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42)
		t19:=f5CharDate(->[Job_Forms_Master_Schedule:67]DateClosingMet:23)
End case 
//