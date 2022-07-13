//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/25/07, 16:47:43
// ----------------------------------------------------
// Method: x_FixJMIFormClosed2
// Description
// allocation on server was not setting items closed when it should
//used in JIC_Regenerate
// 
// ----------------------------------------------------
C_LONGINT:C283($i)
C_TEXT:C284($body)
C_BOOLEAN:C305(FixedJMIFormClosed2)  //set in Batch_Runner
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	If (Not:C34(FixedJMIFormClosed2))  //don't run this mulitple times
		READ ONLY:C145([Job_Forms:42])
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6="closed")
		
		READ WRITE:C146([Job_Forms_Items:44])
		RELATE MANY SELECTION:C340([Job_Forms_Items:44]JobForm:1)
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]FormClosed:5=False:C215)
		
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $aJobits)
			FIRST RECORD:C50([Job_Forms_Items:44])
			APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]FormClosed:5:=True:C214)
			$body:=""
			If (Count parameters:C259=0)
				For ($i; 1; Size of array:C274($aJobits))
					$body:=$body+$aJobits{$i}+Char:C90(13)
				End for 
			End if 
			EMAIL_Sender("x_FixJMIFormClosed2 fixed "+String:C10(Records in selection:C76([Job_Forms_Items:44])); ""; $body)
			//Else 
			//EMAIL_Sender ("x_FixJMIFormClosed2 fixed "+String(Records in selection([Job_Forms_Items])))
		End if 
		
		BEEP:C151
		zwStatusMsg("Done"; "[Job_Forms_Items]FormClosed:=True")
		FixedJMIFormClosed2:=True:C214
	End if 
	
Else 
	
	If (Not:C34(FixedJMIFormClosed2))  //don't run this mulitple times
		
		READ WRITE:C146([Job_Forms_Items:44])
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms:42]Status:6="closed"; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]FormClosed:5=False:C215)
		
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $aJobits)
			APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]FormClosed:5:=True:C214)
			$body:=""
			If (Count parameters:C259=0)
				For ($i; 1; Size of array:C274($aJobits))
					$body:=$body+$aJobits{$i}+Char:C90(13)
				End for 
			End if 
			EMAIL_Sender("x_FixJMIFormClosed2 fixed "+String:C10(Records in selection:C76([Job_Forms_Items:44])); ""; $body)
		End if 
		
		BEEP:C151
		zwStatusMsg("Done"; "[Job_Forms_Items]FormClosed:=True")
		FixedJMIFormClosed2:=True:C214
	End if 
	
End if   // END 4D Professional Services : January 2019 First record
