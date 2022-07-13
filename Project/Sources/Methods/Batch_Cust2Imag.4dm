//%attributes = {"publishedWeb":true}
//(p) Batch_Cust2Imag(ing)
//create a text file containing new or changed customer ids for
//Scott
//• 8/5/98 cs created
//• 8/27/98 cs placed messages to test where this fails

C_LONGINT:C283($Error)
C_BOOLEAN:C305($0)
C_TEXT:C284($PrimaryPath; xText)

uMsgWindow("Customer Update to Imaging..."+Char:C90(13))

READ WRITE:C146([Customers:16])
QUERY:C277([Customers:16]; [Customers:16]Exported:53=False:C215)

If (Records in selection:C76([Customers:16])>0)
	MESSAGE:C88("Building Customer list..."+Char:C90(13))
	xText:=""
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([Customers:16]))
			xText:=xText+[Customers:16]ID:1+Char:C90(9)+[Customers:16]Name:2+Char:C90(13)
			
			NEXT RECORD:C51([Customers:16])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ID; 0)
		ARRAY TEXT:C222($_Name; 0)
		
		SELECTION TO ARRAY:C260([Customers:16]ID:1; $_ID; [Customers:16]Name:2; $_Name)
		
		For ($i; 1; Size of array:C274($_ID); 1)
			
			xText:=xText+$_ID{$i}+Char:C90(9)+$_Name{$i}+Char:C90(13)
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	$PrimaryPath:="Imaging's DB hd:"
	MESSAGE:C88("Mounting "+$PrimaryPath+" ..."+Char:C90(13))
	//$error:=MountVolume("*";"Imaging's DB";"Imaging's DB HD";"Systems";"Arkay")
	DELAY PROCESS:C323(Current process:C322; 10*60)
	
	If ($Error=0)  //disk is mounted
		$PrimaryPath:=$PrimaryPath+"Prep Report ƒ"
		$error:=Test path name:C476($PrimaryPath)
		MESSAGE:C88("Testing existance of 'Prep Report ƒ'"+Char:C90(13))
		DELAY PROCESS:C323(Current process:C322; 10*60)
		
		If ($Error=1)
			$CustPath:=$PrimaryPath+":Customer Drop"
			$error:=Test path name:C476($CustPath)
			MESSAGE:C88("Looking for/creating 'Customer Drop'"+Char:C90(13))
			DELAY PROCESS:C323(Current process:C322; 10*60)
			
			If ($error=0)  //no folder, create it
				NewFolder($CustPath)
				DELAY PROCESS:C323(Current process:C322; 60)
			End if 
			vDoc:=Create document:C266($CustPath+":New Customers "+String:C10(4D_Current_date); "TEXT")
			MESSAGE:C88("Creating Text file..."+Char:C90(13))
			SEND PACKET:C103(vDoc; xText)
			CLOSE DOCUMENT:C267(vDoc)
			//$error:=EjectVolume("Imaging's DB hd:")
			
			Repeat 
				APPLY TO SELECTION:C70([Customers:16]; [Customers:16]Exported:53:=True:C214)
			Until (uChkLockedSet(->[Customers:16]))
		Else 
			BEEP:C151
			MESSAGE:C88("Error - remote Directory "+$PrimaryPath+" could not be mounted.")
			DELAY PROCESS:C323(Current process:C322; 120)
		End if 
	Else 
		BEEP:C151
		MESSAGE:C88("Error - remote Volume: 'Imaging's DB HD' could not be mounted.")
		DELAY PROCESS:C323(Current process:C322; 120)
	End if 
End if   //no new customers
CLOSE WINDOW:C154