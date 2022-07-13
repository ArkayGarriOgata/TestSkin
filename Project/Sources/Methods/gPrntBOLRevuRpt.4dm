//%attributes = {"publishedWeb":true}
//(p) gPrntBOLRpt
// Modified by: MelvinBohince (6/8/22) comment out [Customers_Bills_of_Lading];"BOLRevuRpt", v19 no likey

C_LONGINT:C283($Count)
C_DATE:C307(dDate)
C_TEXT:C284(sPage)

<>fContinue:=True:C214
SET WINDOW TITLE:C213("Printing Review Report")
dDate:=4D_Current_date
//FORM SET OUTPUT([Customers_Bills_of_Lading];"BOLRevuRpt")
CREATE SET:C116([Customers_Bills_of_Lading:49]; "ToPrint")
CREATE SET:C116([Customers_Bills_of_Lading:49]; "Save")
$Count:=1

ON EVENT CALL:C190("eCancelPrint")
Repeat 
	If (Size of array:C274(aCustId)=0)  //Size=0 if User is in FGINventory group &selects "all" button on dialog
		MESSAGES OFF:C175
		
		$winRef:=NewWindow(170; 30; 6; 1; "")
		MESSAGE:C88("Sorting Records…")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			CREATE SET:C116([Customers_Bills_of_Lading:49]; "ToSort")
			DISTINCT VALUES:C339([Customers_Bills_of_Lading:49]CustID:2; aCustId)
			CREATE EMPTY SET:C140([Customers:16]; "FoundCust")
			For ($i; 1; Size of array:C274(aCustId))
				QUERY:C277([Customers:16]; [Customers:16]ID:1=aCustid{$i})
				ADD TO SET:C119([Customers:16]; "FoundCust")
			End for 
			USE SET:C118("FoundCust")
			CLEAR SET:C117("FoundCust")
			ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)
			SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustId)
			USE SET:C118("ToSort")
			CLEAR SET:C117("ToSort")
			
		Else 
			
			If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
				DISTINCT VALUES:C339([Customers_Bills_of_Lading:49]CustID:2; aCustId)
				QUERY WITH ARRAY:C644([Customers:16]ID:1; aCustid)
				
			Else 
				
				RELATE ONE SELECTION:C349([Customers_Bills_of_Lading:49]; [Customers:16])
				
			End if   // END 4D Professional Services : January 2019 
			
			ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)
			SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustId)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		MESSAGES ON:C181
		CLOSE WINDOW:C154($winRef)
	End if 
	QUERY SELECTION:C341([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]CustID:2=aCustId{$Count})
	
	If (Records in selection:C76([Customers_Bills_of_Lading:49])>0)
		CREATE SET:C116([Customers_Bills_of_Lading:49]; "Found")
		DIFFERENCE:C122("ToPrint"; "Found"; "ToPrint")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20; >)
			FIRST RECORD:C50([Customers_Bills_of_Lading:49])
			
		Else 
			
			ORDER BY:C49([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20; >)
			// see order by
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		For ($i; 1; Records in selection:C76([Customers_Bills_of_Lading:49]))
			QUERY:C277([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]id_added_by_converter:16=[Customers_Bills_of_Lading:49]Manifest:16)  //v1.0.3-JJG (03/28/17) - deprecated //ALL SUBRECORDS([Customers_Bills_of_Lading]Manifest)
			lPage:=1+Int:C8(Records in selection:C76([Customers_Bills_of_Lading_Manif:181])/19)  //v1.0.3-JJG (03/28/17) - deprecated //Int(Records in subselection([Customers_Bills_of_Lading]Manifest)/19)
			PRINT RECORD:C71([Customers_Bills_of_Lading:49]; *)
			If (<>fContinue=False:C215)
				$i:=Records in selection:C76([Customers_Bills_of_Lading:49])+1
				$Count:=Size of array:C274(aCustId)+1
			End if 
			NEXT RECORD:C51([Customers_Bills_of_Lading:49])
		End for 
	End if 
	USE SET:C118("ToPrint")
	$Count:=$Count+1
Until ($Count>Size of array:C274(aCustId)) | (Records in set:C195("ToPrint")=0)
CLEAR SET:C117("ToPRint")
CLEAR SET:C117("Found")
USE SET:C118("Save")
CLEAR SET:C117("Save")
//FORM SET OUTPUT([Customers_Bills_of_Lading];"RevueBOLList")
ON EVENT CALL:C190("")
SET WINDOW TITLE:C213("Review BOLs : "+String:C10(Records in selection:C76([Customers_Bills_of_Lading:49]))+" of "+String:C10(Records in table:C83([Customers_Bills_of_Lading:49])))