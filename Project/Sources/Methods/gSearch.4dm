//%attributes = {"publishedWeb":true}
//(P) gSearch: ad hoc search
//upr 1454 3/24/95
//$1 - String - FLag tell system to search entire currrent file
//  BU not as a selection, changing current contents of window.
//• 2/3/98 cs added parameter one
// Added by: Garri Ogata (1/25/21) Read/Write verify default table is set

fAdHoc:=True:C214  //flag for entry screens
SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)

If (rbSearchEd=1)
	Case of 
		: (fAdHocLocal) & (Count parameters:C259=1)  //on output list & we WANT a fresh search      
			QUERY:C277(zDefFilePtr->)  //present editor for the default file
		: (fAdHocLocal)  //on output list, search selection
			
			If (Records in selection:C76(zDefFilePtr->)>0)
				QUERY SELECTION:C341(zDefFilePtr->)  //present editor for the default file
			End if 
		Else   //from splash screen
			QUERY:C277(zDefFilePtr->)  //present editor for the default file
	End case 
End if 

If (OK=1)
	User_AllowedSelection(zDefFilePtr)
	CREATE SET:C116(zDefFilePtr->; "CurrentSet")  //save selection as current set
	
	If (fAdHocLocal)  //on output list
		bSelect:=1
		ACCEPT:C269  //accepts output list and returns back to main event loop
	Else   //selected from splash screen    
		sWindTitle:="Review:"+Table name:C256(zDefFilePtr)
		SET WINDOW TITLE:C213(sWindTitle)
		<>PassThrough:=True:C214
		CREATE SET:C116(zDefFilePtr->; "◊PassThroughSet")
		<>iMode:=3
		<>filePtr:=zDefFilePtr
		doReviewRecord
		//    gRevRecord 
	End if 
End if 
SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)

Case of   //Set read write
		
	: (Not:C34(Is nil pointer:C315(Current default table:C363)))
		
		READ WRITE:C146(Current default table:C363->)
		
	: (Not:C34(Is nil pointer:C315(zDefFilePtr)))
		
		READ WRITE:C146(zDefFilePtr->)
		
	Else   //Do nothing
		
End case   //Done set read write
