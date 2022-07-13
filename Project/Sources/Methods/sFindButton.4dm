//%attributes = {"publishedWeb":true}
//(P) sFindButton: called from [CONTROL]Select.D'bSearch
//1/13/95 UPR 1395 abandon set technology for saleRep/Coord restrictions
//• 6/10/97 cs upr 1872 - needed to change sort from 'sfile' to file of
//   field being searched

C_TEXT:C284($SortDir)
C_LONGINT:C283($len; $type)
C_BOOLEAN:C305(useFindWidget)  // Added by: Mel Bohince (6/12/19) 
useFindWidget:=False:C215
GOTO XY:C161(10; 24)
MESSAGE:C88("Searching! Please Wait...")
GET FIELD PROPERTIES:C258(aSlctField{zSelectNum}; $type; $len)
zDefFilePtr:=filePtr

Case of 
	: ($type=0) | ($type=2) | ($type=24)  //string, text or string
		sSlctType:="A"
	: ($type=1)
		sSlctType:="R"
	: ($type=4)  //date
		sSlctType:="D"
	: ($type=8)  //Integer 
		sSlctType:="L"
	: ($type=9)  //Longint
		sSlctType:="L"
	: ($type=6)  //boolean
		sSlctType:="B"
End case 

Case of 
	: (rbSearchEd=1)  //by search editor
		SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
		QUERY:C277(filePtr->)
		If (OK=0)
			uClearSelection(filePtr)
		End if 
		SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	: (rbAll=1)  //all records
		ALL RECORDS:C47(filePtr->)
	: (rbCurrSel=1)  //current selection
		USE SET:C118("◊LastSelection"+String:C10(fileNum))
	: (sCriterion1#"")  //equals search
		uEqualSrch
	: (sCriterion4#"")  //equals search
		uContainSrch
	Else   //range search
		uRangeSrch
End case 

User_AllowedSelection(filePtr)
NumRecs1:=Records in selection:C76(filePtr->)

If (NumRecs1=0)
	uNoneFound
	REJECT:C38
	
Else 
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	CREATE SET:C116(filePtr->; "CurrentSet")
	
	C_TEXT:C284($SortDir)
	$SortDir:=(">"*sAsc)+("<"*sDes)
	Case of 
		: (sSortEd=1)  //sort editor
			SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
			ORDER BY:C49(filePtr->)
			SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
			zSort:=""
		: (sNoSort=1)  //no sort
			zSort:=""
		Else 
			zSort:="["+Table name:C256(zDefFilePtr)+"]"+Field name:C257(aSlctField{zSelectNum})+";"+$SortDir
	End case 
	
	GOTO XY:C161(10; 24)
	MESSAGE:C88((" "*39))
	If (zSort#"")
		GOTO XY:C161(10; 24)
		MESSAGE:C88("Sorting! Please Wait...        ")
		EXECUTE FORMULA:C63("ORDER BY(["+Table name:C256(zDefFilePtr)+"];"+zSort+")")
		
		GOTO XY:C161(10; 24)
		MESSAGE:C88((" "*39))
		NumRecs1:=Records in selection:C76(filePtr->)
	End if 
End if 