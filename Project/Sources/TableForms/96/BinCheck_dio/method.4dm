// User name (OS): Mel Bohince
// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].BinCheck_dio
//------------------------------------------------
// Modified by: Mel Bohince (12/9/15) tidy up the enable on the bDelete, change BNR to BN
Case of 
	: (Form event code:C388=On Load:K2:1)
		WMS_API_LoginLookup  //make sure <>WMS variables are up to date. `v0.1.0-JJG (05/06/16) - added 
		rft_log:="Bins begin with BN, Skid with 00, Cases have 22 digits\rEnter 'Done' to quit."
		rft_prompt:="Scan something: "
		rft_response:=""
		rft_state:="BIN"
		rft_error_log:=""
		qtyListed:=0
		
		ARRAY BOOLEAN:C223(ListBox1; 0)
		ARRAY TEXT:C222(rft_Case; 0)
		ARRAY TEXT:C222(rft_Skid; 0)
		ARRAY TEXT:C222(rft_Bin; 0)
		ARRAY LONGINT:C221($acase_state; 0)
		ARRAY TEXT:C222(rft_Status; 0)
		
		OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
		<>WMS_ERROR:=0
		
		SET WINDOW TITLE:C213(rft_state)
		zwStatusMsg("BIN CHECK"; "Scan a bin")
		
		SetObjectProperties(""; ->rft_error_log; False:C215)
		
	: (Form event code:C388=On Data Change:K2:15)
		$priorPrompt:=rft_prompt
		rft_error_log:=""
		$success:=False:C215
		OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
		
		Case of 
			: (rft_response="DONE")  //A way to bail
				CANCEL:C270
				
			: (Substring:C12(rft_response; 1; 2)="BN")
				rft_state:="BIN"
				
			: (Substring:C12(rft_response; 1; 2)="00") & (Length:C16(rft_response)=20)
				rft_state:="SKID"
				
			Else 
				rft_state:="CASE"
		End case 
		
		SET WINDOW TITLE:C213(rft_state)
		
		zwStatusMsg(rft_state+" CHECK"; "Last scan: "+rft_response)
		
		Case of 
			: (rft_response="DONE")  //A way to bail
				CANCEL:C270
				
			: (Position:C15(rft_state; " BIN SKID CASE ")>0)
				<>WMS_ERROR:=0
				
				wms_api_lookup  //v0.1.0-JJG (05/09/16) - modularized
				If (False:C215)  //v0.1.0-JJG (05/09/16) - modularized above for 4D vs MySQL
					//$conn_id:=DB_ConnectionManager ("Open")
					//If ($conn_id>0)
					
					//$sql:="SELECT case_id, skid_number, case_status_code, bin_id "
					//$sql:=$sql+" FROM cases WHERE "
					
					//Case of 
					//: (rft_state="BIN")
					//$sql:=$sql+"bin_id = '"+rft_response
					
					//: (rft_state="SKID")
					//$sql:=$sql+"skid_number = '"+rft_response
					
					//: (rft_state="CASE")
					//$sql:=$sql+"case_id = '"+rft_response
					
					//End case 
					
					//$sql:=$sql+"' order by skid_number, case_id"
					
					//$row_set:=MySQL Select ($conn_id;$sql)
					//$row_count:=MySQL Get Row Count ($row_set)
					
					//ARRAY BOOLEAN(ListBox1;0)
					//ARRAY TEXT(rft_Case;0)
					//ARRAY TEXT(rft_Skid;0)
					//ARRAY TEXT(rft_Bin;0)
					//ARRAY LONGINT($acase_state;0)
					//ARRAY TEXT(rft_Status;0)
					
					//MySQL Column To Array ($row_set;"";1;rft_Case)
					//MySQL Column To Array ($row_set;"";2;rft_Skid)
					//MySQL Column To Array ($row_set;"";3;$acase_state)
					//MySQL Column To Array ($row_set;"";4;rft_Bin)
					
					//ARRAY BOOLEAN(ListBox1;$row_count)
					//ARRAY TEXT(rft_Status;$row_count)
					//$qty:=0
					//For ($i;1;$row_count)
					//If (rft_Case{$i}#rft_Skid{$i})  //not a supercase
					//$qty:=$qty+Num(WMS_CaseId (rft_Case{$i};"qty"))
					//End if 
					
					//rft_Status{$i}:=wmss_CaseState ($acase_state{$i})
					
					//End for 
					//  //qtyListed:=String($qty;"###,##0")
					//qtyListed:=$qty
					
					//MySQL Delete Row Set ($row_set)
					//$conn_id:=DB_ConnectionManager ("Close")
					
					//If (Size of array(rft_Case)>0)
					//SetObjectProperties ("";->rft_error_log;False)
					//Else 
					//rft_error_log:=rft_response+" not found"
					//SetObjectProperties ("";->rft_error_log;True;"";False)
					//rft_response:=""
					//End if 
					
					//End if   //connid
				End if   //v0.1.0-JJG (05/09/16) - end of commented block
				
				
			Else   //wtf
				rft_error_log:="This can't be happening!"
				SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
				OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
				rft_response:=""
		End case 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
End case 

