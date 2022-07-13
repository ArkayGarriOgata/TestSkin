//Layout Proc.: SelectXMonth()  081795  MLB
//
Case of 
	: (Form event code:C388=On Load:K2:1)
		rb9month:=1
		dDateEnd:=4D_Current_date
		rReal1:=9
		t2:="INVENTORY 9 MO & UP"
		SetObjectProperties(""; ->rReal1; True:C214; ""; False:C215)
End case 