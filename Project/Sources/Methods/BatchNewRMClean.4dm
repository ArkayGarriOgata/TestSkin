//%attributes = {"publishedWeb":true}
//(p) BatchNewRmClean(up)
//locates RMs added through Requisitions which were later changed
//by purchasing to other RMs and orphaned.  These are removed from RM table
//• 6/13/97 cs  created
//• 7/23/98 cs Missed stepping raw material records in a for loop below

READ WRITE:C146([Raw_Materials:21])

QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]NewFromReq:42=True:C214)  //locate new Req RMs
$Count:=Records in selection:C76([Raw_Materials:21])

If ($Count>0)  //if there were some found
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Purchase_Orders_Items:12]Raw_Matl_Code:15; ->[Raw_Materials:21]Raw_Matl_Code:1)  //find all po_items refering to them
		
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Purchase_Orders_Items:12])+" file. Please Wait...")
		RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]Raw_Matl_Code:15)
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	ARRAY TEXT:C222($PoRaw; $Count)
	SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Raw_Matl_Code:15; $PORaw)  //place into an array for faster processing
	uClearSelection(->[Purchase_Orders_Items:12])  //clear selection
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		CREATE EMPTY SET:C140([Raw_Materials:21]; "Remove")
		FIRST RECORD:C50([Raw_Materials:21])
		For ($i; 1; $Count)  //for each new RM test to see that it is referenced in the PO items
			
			If (Find in array:C230($PoRaw; [Raw_Materials:21]Raw_Matl_Code:1)=-1)  //raw material code NOT found
				ADD TO SET:C119([Raw_Materials:21]; "Remove")  //flag for removal
			End if 
			NEXT RECORD:C51([Raw_Materials:21])  //• 7/23/98 cs missed stepping records
		End for 
		USE SET:C118("remove")
		DELETE SELECTION:C66([Raw_Materials:21])
		CLEAR SET:C117("remove")
		
	Else 
		
		// see line 21
		ARRAY TEXT:C222($_Raw_Matl_Code; 0)
		ARRAY LONGINT:C221($_Raw_Materials; 0)
		ARRAY LONGINT:C221($_Raw_Materials_todel; 0)
		SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $_Raw_Matl_Code; [Raw_Materials:21]; $_Raw_Materials)
		
		For ($Iter; 1; $Count; 1)
			
			If (Find in array:C230($PoRaw; $_Raw_Matl_Code{$Iter})=-1)
				
				APPEND TO ARRAY:C911($_Raw_Materials_todel; $_Raw_Materials{$Iter})
				
			End if 
		End for 
		CREATE SELECTION FROM ARRAY:C640([Raw_Materials:21]; $_Raw_Materials_todel)
		DELETE SELECTION:C66([Raw_Materials:21])
	End if   // END 4D Professional Services : January 2019 First record
	
End if 