//OM:  sCriterion1()  3/02/01  mlb
//find by poi
If (Length:C16([Purchase_Orders_Items:12]Raw_Matl_Code:15)=0)  // do a search
	
	If (Length:C16([Purchase_Orders_Items:12]RM_Description:7)>0)
		$criterion:=[Purchase_Orders_Items:12]RM_Description:7
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Description:4=$criterion)
		
		If (Records in selection:C76([Raw_Materials:21])>0)
			tMessage1:="To select, click on the "+"Raw Material"+"name below."
			sHead1:=Field name:C257(->[Raw_Materials:21]Raw_Matl_Code:1)
			sHead2:=Field name:C257(->[Raw_Materials:21]Commodity_Key:2)
			sHead3:=Field name:C257(->[Raw_Materials:21]Description:4)
			SELECTION TO ARRAY:C260([Raw_Materials:21]; alRecNo; [Raw_Materials:21]Raw_Matl_Code:1; asPrimKey; [Raw_Materials:21]Commodity_Key:2; asDesc1; [Raw_Materials:21]Description:4; asDesc2)
			SORT ARRAY:C229(asDesc1; alRecNo; asPrimKey; asDesc2; >)
			$winRef:=OpenSheetWindow(->[zz_control:1]; "PickList_dio")
			DIALOG:C40([zz_control:1]; "PickList_dio")
			CLOSE WINDOW:C154
			Case of 
				: (bPick=1)
					GOTO RECORD:C242([Raw_Materials:21]; alRecNo{asPrimKey})
					
				: (bNoPick=1)
					REDUCE SELECTION:C351([Raw_Materials:21]; 0)
					
				: (bNewPick=1)  //BUTTON NOT IMPLEMENTED, deal with from calling proc
					BEEP:C151
					REDUCE SELECTION:C351([Raw_Materials:21]; 0)
				Else 
					REDUCE SELECTION:C351([Raw_Materials:21]; 0)
			End case 
			
			ARRAY LONGINT:C221(alRecNo; 0)
			ARRAY TEXT:C222(asPrimKey; 0)
			ARRAY TEXT:C222(asDesc1; 0)
			ARRAY TEXT:C222(asDesc2; 0)
			
			If (Records in selection:C76([Raw_Materials:21])=1)
				POI_RMcodeChanged
				
			Else 
				[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""
				[Purchase_Orders_Items:12]RM_Description:7:=""
				GOTO OBJECT:C206([Purchase_Orders_Items:12]Raw_Matl_Code:15)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("No descriptions contained "+[Purchase_Orders_Items:12]RM_Description:7+".")
			[Purchase_Orders_Items:12]RM_Description:7:=""
		End if 
		CLOSE WINDOW:C154
	End if 
	
Else 
	fNewRM:=True:C214
	txt_Gremlinizer(->[Purchase_Orders_Items:12]RM_Description:7)
End if 
//
