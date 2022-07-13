//Layout Proc.: Control.NewInvent.dio()  030696  MLB
//get date of interest and optional customer restriction

Case of 
	: (Form event code:C388=On Load:K2:1)
		rb6month:=1
		dDateEnd:=4D_Current_date
		rReal1:=6
		t2:="INVENTORY 6 MONTHS & UP"
		tCust:="All Customers"
		SetObjectProperties(""; ->rReal1; True:C214; ""; False:C215)
End case 