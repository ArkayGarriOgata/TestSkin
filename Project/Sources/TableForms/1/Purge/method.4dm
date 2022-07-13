//(lp) [control]purge
//• 4/11/97 cs enterablilit of range checks for Orders
//• 11/5/97 cs added new checkbox (r21) to layout
//  used to delete issue tickets
//• 12/1a9/97 cs added ship fg trans type
Case of 
	: (Form event code:C388=On Load:K2:1)
		//utl_Trace 
		//OBJECT SET ENABLED(r10;False)
		//SET ENTERABLE(dRmTransDat;False)
		//SET ENTERABLE(cbReceipts;False)
		//SET ENTERABLE(dEndDate;False)  `• 4/11/97 cs 
		//SET ENTERABLE(r20;False)  `• 4/11/97 cs 
		//
		//SET ENTERABLE(rFg60;False)  `• 11/6/97 cs `new Fg transaction stuff
		//SET ENTERABLE(rFg61;False)  `• 11/6/97 cs 
		//SET ENTERABLE(rFg62;False)  `• 11/6/97 cs 
		//SET ENTERABLE(rFg63;False)  `• 11/6/97 cs 
		//SET ENTERABLE(rFg64;False)  `• 11/6/97 cs 
		//SET ENTERABLE(rFg65;False)  `• 11/6/97 cs 
		//SET ENTERABLE(rFg66;False)  `• 11/6/97 cs 
		//SET ENTERABLE(rFg67;False)  `• 12/19/97 cs `added for ship
		//SET ENTERABLE(r37;False)  `• 11/6/97 cs     
		//r20:=30  `• 4/11/97 cs number of days before present Killed orders are
		//« removed
		//cb1:=0  `POs
		//cb2:=0  `Issue tickets 
		//cb3:=0  `unattached process specs
		//cb12:=0  `remove unused raw materials
		//dAsOf:=4D_Current_date-r21
End case 
//