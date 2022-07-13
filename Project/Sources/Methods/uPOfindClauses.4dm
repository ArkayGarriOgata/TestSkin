//%attributes = {"publishedWeb":true}
//PM:  uPOfindClauses  5/06/99  MLB
//make sure that all required clauses are attacthed to the PO

//assumes all poitem for this po are selected

//remove any that are no longer applicable
//delete all the subrecrds, nah...

//*Build a hashtable
C_LONGINT:C283($i; $hit; $cursor; $unique; $nextClause)
ARRAY TEXT:C222($aExpenseKey; 10)
ARRAY TEXT:C222($aApplicableClause; 10)
$aExpenseKey{1}:="1241"
$aApplicableClause{1}:="3"
$aExpenseKey{2}:="1242"
$aApplicableClause{2}:="3"
$aExpenseKey{3}:="1243"
$aApplicableClause{3}:="3"
$aExpenseKey{4}:="1244"
$aApplicableClause{4}:="3"
$aExpenseKey{5}:="1245"
$aApplicableClause{5}:="2"
$aExpenseKey{6}:="1240"
$aApplicableClause{6}:="3"
$aExpenseKey{7}:="1246"
$aApplicableClause{7}:="3"
$aExpenseKey{8}:="1128"
$aApplicableClause{8}:="3"
$aExpenseKey{9}:="1131"
$aApplicableClause{9}:="2"
$aExpenseKey{10}:="1220"
$aApplicableClause{10}:="2"

RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
CREATE SET:C116([Purchase_Orders_PO_Clauses:165]; "existingClauses")
If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)
	$nextClause:=1
Else 
	$nextClause:=Max:C3([Purchase_Orders_PO_Clauses:165]SeqNo:1)+1
End if 

DISTINCT VALUES:C339([Purchase_Orders_Items:12]CommodityCode:16; $aCommodityCode)
DISTINCT VALUES:C339([Purchase_Orders_Items:12]ExpenseCode:47; $aExpenseCode)
ARRAY TEXT:C222($aRequiredClause; Size of array:C274($aExpenseCode))
$cursor:=0
//get a unique list of required clauses
For ($i; 1; Size of array:C274($aExpenseCode))
	$hit:=Find in array:C230($aExpenseKey; $aExpenseCode{$i})
	If ($hit>-1)  //this needs to be included
		$unique:=Find in array:C230($aRequiredClause; $aApplicableClause{$hit})
		If ($unique=-1)  //it hasn't already been added
			$cursor:=$cursor+1
			$aRequiredClause{$cursor}:=$aApplicableClause{$hit}
		End if 
	End if 
End for 
//if there are some required
If ($cursor>0)
	ARRAY TEXT:C222($aRequiredClause; $cursor)  //shrink
	
	For ($i; 1; $cursor)
		Case of 
			: ($aRequiredClause{$i}="2")  //need 2
				USE SET:C118("existingClauses")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]ClauseID:2="2")
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)
					PO_ClauseAdd("2"; ->$nextClause)
				End if 
				
			: ($aRequiredClause{$i}="3")  //need 1 and 2
				USE SET:C118("existingClauses")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]ClauseID:2="1")
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)
					PO_ClauseAdd("1"; ->$nextClause)
				End if 
				
				USE SET:C118("existingClauses")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]ClauseID:2="2")
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)
					PO_ClauseAdd("2"; ->$nextClause)
				End if 
		End case 
	End for 
End if 

//now check for commodity based clauses
RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
CREATE SET:C116([Purchase_Orders_PO_Clauses:165]; "existingClauses")  //refresh set

For ($i; 1; Size of array:C274($aCommodityCode))
	QUERY:C277([Purchase_Order_Comm_Clauses:83]; [Purchase_Order_Comm_Clauses:83]CommodityCode:1=$aCommodityCode{$i})
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($j; 1; Records in selection:C76([Purchase_Order_Comm_Clauses:83]))
			
			USE SET:C118("existingClauses")
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]ClauseID:2=[Purchase_Order_Comm_Clauses:83]Clause:2)
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)  //ensure that this will not duplicate an existing clause
				PO_ClauseAdd([Purchase_Order_Comm_Clauses:83]Clause:2; ->$nextClause)
			End if 
			
			NEXT RECORD:C51([Purchase_Order_Comm_Clauses:83])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_Clause; 0)
		SELECTION TO ARRAY:C260([Purchase_Order_Comm_Clauses:83]Clause:2; $_Clause)
		
		For ($j; 1; Size of array:C274($_Clause); 1)
			
			USE SET:C118("existingClauses")
			QUERY SELECTION:C341([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]ClauseID:2=$_Clause{$j})
			
			If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)  //ensure that this will not duplicate an existing clause
				PO_ClauseAdd($_Clause{$j}; ->$nextClause)
			End if 
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
End for 
//
RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
//