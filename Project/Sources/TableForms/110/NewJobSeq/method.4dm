// ----------------------------------------------------
// Form Method: [ProductionSchedules].NewJobSeq
// ----------------------------------------------------
C_BOOLEAN:C305(fFromAdvScheduler)  //v1.0.0-PJK (12/16/15)
C_TEXT:C284(ttText)
Case of 
	: (Form event code:C388=On Load:K2:1)
		sCriterion2:=""
		sCriterion3:=""
		sCriterion4:=String:C10(?00:00:00?; HH MM:K7:2)
		sCriterion6:="0"
		rb1:=0
		rb2:=1
		rb3:=0
		SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->tTime; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->sCriterion5; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->sCriterion6; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		
		
		//v1.0.0-PJK (12/16/15) display the machine we are scheduling on
		Begin SQL
			SELECT CONCAT(CONCAT(Cost_Centers.ID,' - '), Cost_Centers.Description) 
			FROM Cost_Centers
			WHERE Cost_Centers.ID = :sCriterion1
			INTO :ttText
		End SQL
		
		
		If (Not:C34(fFromAdvScheduler))  //v1.0.0-PJK (12/16/15)
			sCriterion9:="00000.00.000"
			sCriterion5:="0"
			dDate:=!00-00-00!
			tTime:=?00:00:00?
		Else   //v1.0.0-PJK (12/16/15)
			NewJobSeq_sCriterion9
			OBJECT SET ENTERABLE:C238(sCriterion9; False:C215)
		End if   //v1.0.0-PJK (12/16/15)
		
End case 