//%attributes = {"publishedWeb":true}
//(p) POBulkApproval
//• cs 9/9/97 
//moved code from script to here
//• 11/3/97 cs 
// • mel (10/27/04, 16:30:19) refactor

C_BOOLEAN:C305($Continue; $OverRun; $err)
C_LONGINT:C283($Count; $i)
C_TEXT:C284(xText)

$Continue:=True:C214
zwStatusMsg("APPROVING POs"; "Only those in status = Req Approved")
CUT NAMED SELECTION:C334([Purchase_Orders:11]; "hold")
USE SET:C118("UserSet")  //use POs user selected to process

Case of 
	: (Records in set:C195("UserSet")=0)
		uConfirm("You Need to Select (highlight) the Purchase Orders you wish to Approve."; "OK"; "Help")
		USE NAMED SELECTION:C332("Hold")
		
	: (Not:C34(User in group:C338(Current user:C182; "PO_Approval")))
		uConfirm("You are not authorized to approve Purchase Orders."; "OK"; "Help")
		USE NAMED SELECTION:C332("Hold")
		
	Else   //lets do it...
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			SET QUERY DESTINATION:C396(Into set:K19:2; "notRiteStatus")
			QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Status:15#"Req Approved")
			If (Records in set:C195("notRiteStatus")>0)
				COPY SET:C600("notRiteStatus"; "$notRiteStatus")
				DIFFERENCE:C122("UserSet"; "$notRiteStatus"; "UserSet")
				CLEAR SET:C117("$notRiteStatus")
				USE SET:C118("UserSet")
			End if 
			CLEAR SET:C117("notRiteStatus")
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Req Approved")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE EMPTY SET:C140([Purchase_Orders:11]; "problemApproving")
			
			
		Else 
			
			ARRAY LONGINT:C221($_problemApproving; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
		$Count:=Records in selection:C76([Purchase_Orders:11])
		uThermoInit($Count; "Approving Purchase Orders...")
		For ($i; 1; $Count)
			uPOfindClauses
			sChkVendorId
			If (PO_ChkJobLink=0)
				$err:=PoOneApprove([Purchase_Orders:11]PONo:1)
			Else 
				BEEP:C151
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					ADD TO SET:C119([Purchase_Orders:11]; "problemApproving")
					
				Else 
					
					APPEND TO ARRAY:C911($_problemApproving; Record number:C243([Purchase_Orders:11]))
					
				End if   // END 4D Professional Services : January 2019 
				
			End if 
			NEXT RECORD:C51([Purchase_Orders:11])
			uThermoUpdate($i; 1)
		End for 
		uThermoClose
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			COPY SET:C600("problemApproving"; "$problems")  //so we can work with UserSet which is local
			CLEAR SET:C117("problemApproving")
			
		Else 
			
			CREATE SET FROM ARRAY:C641([Purchase_Orders:11]; $_problemApproving; "$problems")
			
			
		End if   // END 4D Professional Services : January 2019 
		
		DIFFERENCE:C122("UserSet"; "$problems"; "UserSet")
		CLEAR SET:C117("$problems")
		USE NAMED SELECTION:C332("Hold")
		HIGHLIGHT RECORDS:C656  //([PURCHASE_ORDER])
		zwStatusMsg("APPROVED"; "Highlighted Purchase Orders have been approved.")
		BEEP:C151
		fNameWindow(filePtr)
End case 