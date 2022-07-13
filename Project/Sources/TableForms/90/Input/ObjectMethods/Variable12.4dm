//(s) xText2
//display text value of posted field
//• 7/28/98 cs created
If (Form event code:C388=On Display Detail:K2:22) | (Form event code:C388=On Load:K2:1)
	Case of 
		: ([Job_Forms_Issue_Tickets:90]Posted:4=0)
			xText2:="NOT Posted"
		: ([Job_Forms_Issue_Tickets:90]Posted:4=1)
			xText2:="Posted - OK"
		: ([Job_Forms_Issue_Tickets:90]Posted:4=2)
			xText2:="No PO Item-No Issue"
		: ([Job_Forms_Issue_Tickets:90]Posted:4=3)
			xText2:="Neg Bin Issue"
		: ([Job_Forms_Issue_Tickets:90]Posted:4=4)
			xText2:="Not Enough Material"
		: ([Job_Forms_Issue_Tickets:90]Posted:4=5)
			xText2:="Bad JobForm ID"
	End case 
	fUpdate:=False:C215
End if 
//