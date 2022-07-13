//(s) xText
//display text value of posted field
//• 7/28/98 cs created
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		Case of 
			: ([Job_Forms_Issue_Tickets:90]Posted:4=0)
				xtext:="0 NOT Posted"
			: ([Job_Forms_Issue_Tickets:90]Posted:4=1)
				xtext:="1 Posted - OK"
			: ([Job_Forms_Issue_Tickets:90]Posted:4=2)
				xtext:="2 No PO Item - No Issue"
			: ([Job_Forms_Issue_Tickets:90]Posted:4=3)
				xtext:="3 Neg Bin Issue"
			: ([Job_Forms_Issue_Tickets:90]Posted:4=4)
				xtext:="4 Not Enough Material"
		End case 
End case 