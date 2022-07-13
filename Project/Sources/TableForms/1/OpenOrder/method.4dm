//[control]Layout Proc.: OpenOrder
//•051295 upr 1508 

If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(rInclPrep; True:C214)  //•051295 upr 1508  
	OBJECT SET ENABLED:C1123(rInclDies; False:C215)  //•051295 upr 1508  
	OBJECT SET ENABLED:C1123(rInclPlates; False:C215)  //•051295 upr 1508  
	OBJECT SET ENABLED:C1123(rInclDups; False:C215)  //•051295 upr 1508  
	OBJECT SET ENABLED:C1123(rInclPnD; False:C215)  //•051295 upr 1508  
	OBJECT SET ENABLED:C1123(bPick; False:C215)
	rb1:=1
	rb2:=0
	
	ARRAY BOOLEAN:C223(ListBox1; 0)
	ARRAY TEXT:C222(aSelected; 0)
	ARRAY TEXT:C222(asCaseID; 0)
	ARRAY TEXT:C222(asDiff; 0)
	
	If (Length:C16(<>EstNo)=9)
		sPONum:=<>EstNo
		<>EstNo:=""
		Ord_loadEstimateToEnterOrder
	Else 
		$yearDigit:=Substring:C12(String:C10(Year of:C25(Current date:C33)); 4; 1)  // Modified by: Mel Bohince (2/12/16) chg to handle teens and twenties
		sPONum:=$yearDigit+"-0000.00"
		HIGHLIGHT TEXT:C210(sPONum; 3; 10)
		<>EstNo:=""
	End if 
	
	$hit:=Find in array:C230(aSelected; "X")
	If ($hit>-1)
		OBJECT SET ENABLED:C1123(bPick; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(bPick; False:C215)
	End if 
	
End if 
//eop