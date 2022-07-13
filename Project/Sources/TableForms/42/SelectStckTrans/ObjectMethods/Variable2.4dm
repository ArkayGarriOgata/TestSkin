//(S) [JobForm]'SelectStckTrans'bSearch:
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sJobNoF)
Case of 
	: (Records in selection:C76([Job_Forms:42])=0)
		ALERT:C41("Job "+sJobNoF+" does not exist.  Please try again.")
		sJobNoF:=""
		GOTO OBJECT:C206(sJobNoF)
		//CANCEL
	: (Records in selection:C76([Job_Forms:42])>0)
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=sJobNoF)
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			lGoodU:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sJobNoT)
			If (Records in selection:C76([Job_Forms:42])=0)
				ALERT:C41("Job "+sJobNoT+" does not exist.  Please try again.")
				sJobNoT:=""
				GOTO OBJECT:C206(sJobNoT)
				//CANCEL
			Else 
				OK:=1
				ACCEPT:C269
			End if 
		End if 
End case 
//EOS