//(LOP) [MachineTicket];"ProdAnalCCRept"

//•120998  MLB  

//•121898  Systems G3  fix addition


Case of 
	: (Form event code:C388=On Printing Detail:K2:18)
		job_ProdAnalCCRptDetail
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=0)
				job_ProdAnalCCRptBreak0
			: (Level:C101=1)
				job_ProdAnalCCRptBreak1
			: (Level:C101=2)
				job_ProdAnalCCRptBreak2
		End case 
End case 
//EOLP