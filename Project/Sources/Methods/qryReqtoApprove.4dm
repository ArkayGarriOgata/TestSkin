//%attributes = {"publishedWeb":true}
//qryReqtoApprove
//$1-String(optional) specific department code to locate 
//REturns number of records found (might be useful)
//• 8/8/97 cs created
//• 1/16/98 fixed problem with notifier, if user looking for group "all"

C_LONGINT:C283($i; $Size; $0)
C_TEXT:C284($Division)
C_TEXT:C284($1)

MESSAGES OFF:C175
uMsgWindow("Searching...")

If (User in group:C338(Current user:C182; "Roanoke"))
	$Division:="2"
Else 
	$Division:="1"
End if 

If (User in group:C338(Current user:C182; "PO_Approval"))
	$Division:="@"
End if 

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition"; *)
	QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]CompanyID:43=$Division)  //• 8/8/97 cs have search filter for division
	$Size:=Size of array:C274(<>UserDepart)
	
	Case of 
		: (Count parameters:C259=1)  //parameter requests search for specific department
			
			If ($1#" All")
				QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Dept:7=$1)
			End if 
		: ($Size=0)  //no department data, do nothing
		: (<>UserDepart{1}=" All") & (Size of array:C274(<>UserDepart)=1)  //all departments do nothing - option + space for leading space
		Else   //need to parse department data
			
			For ($i; 1; $Size)
				Case of 
					: ($i=1) & ($Size>1)  //first item to locate and there are more
						QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Dept:7=<>UserDepart{$i}; *)
					: ($i=1)  //only one dept code to locate
						QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Dept:7=<>UserDepart{$i})
					: ($i#$Size)  //intermediate codes to locate
						QUERY SELECTION:C341([Purchase_Orders:11];  | ; [Purchase_Orders:11]Dept:7=<>UserDepart{$i}; *)
					Else   //last code to locate, close search  
						QUERY SELECTION:C341([Purchase_Orders:11];  | ; [Purchase_Orders:11]Dept:7=<>UserDepart{$i})
				End case 
			End for 
	End case 
	
Else 
	
	
	$Size:=Size of array:C274(<>UserDepart)
	
	Case of 
		: (Count parameters:C259=1)  //parameter requests search for specific department
			If ($1#" All")
				QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Dept:7=$1; *)
			End if 
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition"; *)
			QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]CompanyID:43=$Division)
			
		: ($Size=0)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition"; *)
			QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]CompanyID:43=$Division)
			
		: (<>UserDepart{1}=" All") & (Size of array:C274(<>UserDepart)=1)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition"; *)
			QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]CompanyID:43=$Division)
			
		Else   //need to parse department data
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition"; *)
			QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]CompanyID:43=$Division)
			QUERY SELECTION WITH ARRAY:C1050([Purchase_Orders:11]Dept:7; <>UserDepart)
			
	End case 
	
End if   // END 4D Professional Services : January 2019 query selection

$0:=Records in selection:C76([Purchase_Orders:11])

MESSAGES ON:C181
CLOSE WINDOW:C154