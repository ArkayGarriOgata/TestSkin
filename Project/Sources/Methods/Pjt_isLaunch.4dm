//%attributes = {}
// Method: Pjt_isLaunch (jobform) -> 
// ----------------------------------------------------
// by: mel: 04/01/04, 13:49:49
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305($0; $qryJob; $qryPjt)

$0:=False:C215
$qryJob:=False:C215
$qryPjt:=False:C215
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Job_Forms:42]; "preJF")
	COPY NAMED SELECTION:C331([Customers_Projects:9]; "prePjt")
	
Else 
	
	ARRAY LONGINT:C221($_preJF; 0)
	ARRAY LONGINT:C221($_prePjt; 0)
	
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms:42]; $_preJF)
	LONGINT ARRAY FROM SELECTION:C647([Customers_Projects:9]; $_prePjt)
	
	
End if   // END 4D Professional Services : January 2019 

If ([Job_Forms:42]JobFormID:5#$1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
	$qryJob:=True:C214
End if 

If ([Customers_Projects:9]id:1#[Job_Forms:42]ProjectNumber:56)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Job_Forms:42]ProjectNumber:56)
	$qryPjt:=True:C214
End if 

If (Records in selection:C76([Customers_Projects:9])>0)
	$0:=[Customers_Projects:9]LaunchProject:17
End if 

If ($qryJob)
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("preJF")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Job_Forms:42]; $_preJF)
	End if   // END 4D Professional Services : January 2019 
	
End if 
If ($qryPjt)
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("prePjt")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Customers_Projects:9]; $_prePjt)
		
	End if   // END 4D Professional Services : January 2019 
	
End if 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	CLEAR NAMED SELECTION:C333("preJF")
	CLEAR NAMED SELECTION:C333("prePjt")
Else 
	
End if   // END 4D Professional Services : January 2019 
