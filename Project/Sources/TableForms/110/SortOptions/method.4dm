// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 08/27/13, 10:24:48
// ----------------------------------------------------
// Form Method: [ProductionSchedules].SortOptions
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		rOption1:=1
		OBJECT SET ENTERABLE:C238(xl1; False:C215)
		OBJECT SET ENTERABLE:C238(xl2; False:C215)
		OBJECT SET ENTERABLE:C238(xl3; False:C215)
		xl1:=0
		xl2:=0
		xl3:=0
		
	: (Form event code:C388=On Clicked:K2:4)
		Case of 
			: (rOption1=1)
				OBJECT SET ENTERABLE:C238(xl1; False:C215)
				OBJECT SET ENTERABLE:C238(xl2; False:C215)
				OBJECT SET ENTERABLE:C238(xl3; False:C215)
				xl1:=0
				xl2:=0
				xl3:=0
				
			: (rOption2=1)
				OBJECT SET ENTERABLE:C238(xl1; False:C215)
				OBJECT SET ENTERABLE:C238(xl2; False:C215)
				OBJECT SET ENTERABLE:C238(xl3; False:C215)
				xl1:=0
				xl2:=0
				xl3:=0
				
			: (rOption3=1)
				OBJECT SET ENTERABLE:C238(xl1; True:C214)
				OBJECT SET ENTERABLE:C238(xl2; True:C214)
				OBJECT SET ENTERABLE:C238(xl3; True:C214)
				GOTO OBJECT:C206(xl1)
		End case 
End case 