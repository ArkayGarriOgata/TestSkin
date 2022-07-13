//%attributes = {"publishedWeb":true}
//Procedure: rptInvDialog()  072796  MLB
//reduce size of rptNewInventor2

C_BOOLEAN:C305($0)
C_LONGINT:C283(rb9Month; rb12Month; rb15Month; rb0thMonth)  //radio buttons to set rReal1

$0:=True:C214

uDialog("NewInvent_dio"; 255; 220)  //•081795  MLB  hk request
If (False:C215)
	FORM SET INPUT:C55([zz_control:1]; "NewInvent_dio")
End if 

If (OK=1)
	If (tCust="All Customers")
		tCust:=""
	End if 
	PRINT SETTINGS:C106
	If (OK=0)
		$0:=False:C215
	End if 
Else 
	$0:=False:C215
End if 