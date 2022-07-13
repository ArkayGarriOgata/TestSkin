//(S) sCriterion1:
//091195
//i1:=0
sCriterion1:=fStripSpace("B"; sCriterion1)
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=sCriterion1)

Case of 
	: (Records in selection:C76([Finished_Goods:26])=0)
		uRejectAlert("Invalid F/G Code!  Please try again.")
		sCriterion1:=""
		GOTO OBJECT:C206(sCriterion1)
		
	: (Records in selection:C76([Finished_Goods:26])=1)
		ARRAY TEXT:C222(asCriter2; 1)
		asCriter2{1}:=[Finished_Goods:26]CustID:2
		asCriter2:=1
		sCriterion2:=asCriter2{asCriter2}
		
	Else 
		
		BEEP:C151
		ALERT:C41("Choose a customer number.")
		DISTINCT VALUES:C339([Finished_Goods:26]CustID:2; asCriter2)
		asCriter2:=1
		sCriterion2:=asCriter2{asCriter2}
		
End case 
//EOS