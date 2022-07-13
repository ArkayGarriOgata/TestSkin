//%attributes = {"publishedWeb":true}
//rRptGeneric, modified by JML 

Case of 
	: ($1=1)  //uRptGeneric, depend on reports layout name  
		FORM SET OUTPUT:C54(filePtr->; "Listing")
	: ($1=2)  //uRptGeneric, depend on reports layout name  
		FORM SET OUTPUT:C54(filePtr->; "Labels")
	: ($1=3)
		FORM SET OUTPUT:C54(filePtr->; "Letter")
	Else 
		FORM SET OUTPUT:C54(filePtr->; "Output")
End case 
//SORT SELECTION(filePtr»)  `I assume this is redundant since this is called from 
PRINT SELECTION:C60(filePtr->)
FORM SET OUTPUT:C54(filePtr->; "List")  //this used to say'OutPut' instead of 'List', I assume that was a bug