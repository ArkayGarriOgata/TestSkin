//%attributes = {"publishedWeb":true}
//(p) sFindPo
//called from scripts in buttons on [control]selectPO2Review
//• 3/16/98 cs created

C_LONGINT:C283($recs; $i)

Case of 
	: (rb1=1)  //search by PO number
		If (Num:C11(sCriterion1)#0)
			sCriterion1:=nZeroFill(Replace string:C233(sCriterion1; " "; ""); 7)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=sCriterion1)
			sCriterion1:=""
		End if 
		
	: (rb2=1)  //by Date
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PODate:4=dDate)
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1; >)
		
	: (rb3=1)  //by search editor
		QUERY:C277([Purchase_Orders:11])
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1; >)
		SetObjectProperties(""; ->sCriterion1; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
		rb3:=0
		rb1:=1
		GOTO OBJECT:C206(sCriterion1)
End case 
$recs:=Records in selection:C76([Purchase_Orders:11])

Case of 
	: ($recs=0) & (OK=1)  //nothing found
		uNoneFound
		
	: ($recs>0) & (OK=1)  //something found
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $Recs)  //place all found Pos into array for display
				If (Find in array:C230(aText; [Purchase_Orders:11]PONo:1)<0)  //DO NOT insert PO twice
					$Size:=Size of array:C274(aText)
					INSERT IN ARRAY:C227(aText; $Size+1)
					aText{$Size+1}:=[Purchase_Orders:11]PONo:1
				End if 
				ADD TO SET:C119([Purchase_Orders:11]; "Found")
				NEXT RECORD:C51([Purchase_Orders:11])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_PONo; 0)
			CREATE SET:C116([Purchase_Orders:11]; "4D_optimum")
			SELECTION TO ARRAY:C260([Purchase_Orders:11]PONo:1; $_PONo)
			
			UNION:C120("Found"; "4D_optimum"; "Found")
			CLEAR SET:C117("4D_optimum")
			
			For ($i; 1; $Recs; 1)  //place all found Pos into array for display
				If (Find in array:C230(aText; $_PONo{$i})<0)  //DO NOT insert PO twice
					$Size:=Size of array:C274(aText)
					INSERT IN ARRAY:C227(aText; $Size+1)
					aText{$Size+1}:=$_PONo{$i}
				End if 
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
	Else 
End case 