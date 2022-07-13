// ----------------------------------------------------
// User name (OS): MLB
// Date: 092895
// ----------------------------------------------------
// Object Method: [zz_control].MachTicket.Variable16
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------
//  Modified by: Mel Bohince (8/9/21) make call to storage to validate c/c#

If (CostCtrCurrent("oop"; sMACC)>0)  //Modified by: Mel Bohince (8/9/21)
	
	If (Position:C15(sMACC; <>GLUERS)#0)  //•092895 MLB UPR 1720`•060696 MLB
		SetObjectProperties(""; ->iMAItemNo; True:C214; ""; True:C214)
		SetObjectProperties("item@"; -><>NULL; True:C214; ""; True:C214)
	Else 
		SetObjectProperties(""; ->iMAItemNo; True:C214; ""; False:C215)
		SetObjectProperties("item@"; -><>NULL; True:C214; ""; False:C215)
	End if 
	
Else   //Modified by: Mel Bohince (8/9/21)
	
	BEEP:C151
	
	SMACC:=""
	GOTO OBJECT:C206(sMACC)
	
End if   //Modified by: Mel Bohince (8/9/21)

//Old stuff:

//If (Find in array(aStdCC;sMACC)=-1)
//BEEP
//ALERT(sMACC+" is an Invalid Cost Center - Please try again!!!")
//sMACC:=""
//GOTO OBJECT(sMACC)
//Else 
//If (Position(sMACC;<>GLUERS)#0)  //•092895  MLB  UPR 1720`•060696  MLB 
//SetObjectProperties ("";->iMAItemNo;True;"";True)
//SetObjectProperties ("item@";-><>NULL;True;"";True)
//Else 
//SetObjectProperties ("";->iMAItemNo;True;"";False)
//SetObjectProperties ("item@";-><>NULL;True;"";False)
//End if 
//End if 