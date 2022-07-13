//%attributes = {"publishedWeb":true}
//uChgReleaseInfo   11/8/94  code simplifiactions, called by gChgOApproval
//upr 1303 11/9/94
//1/25/95 comments added
C_LONGINT:C283($i)
C_TEXT:C284($sOrdLine)
RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
//FIRST SUBRECORD([Customers_Order_Change_Orders]OrderChg_Items)
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=(String:C10([Customers_Order_Change_Orders:34]OrderNo:5; "00000")+"@"))  //*get all release for this order
If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ChgOrdItmPosted:27:=False:C215)  //*mark em to see if they are touched
	//$numSubrecords:=Records in subselection([Customers_Order_Change_Orders]OrderChg_Items)
	While (Not:C34(End selection:C36([Customers_Order_Changed_Items:176])))
		//For ($i;1;$numSubrecords)  `*for each item in the change order
		MESSAGE:C88(String:C10([Customers_Order_Changed_Items:176]ItemNo:1; " ## "))
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5; *)  //*.   try to find ol via old cpn
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=[Customers_Order_Changed_Items:176]OldProductCode:9)
		//If different line then connect Release
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderNumber:2=[Customers_Order_Change_Orders:34]OrderNo:5; *)  //*.   get all release for this cpn on this order
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=[Customers_Order_Changed_Items:176]OldProductCode:9)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
					FIRST RECORD:C50([Customers_ReleaseSchedules:46])
					$sOrdLine:=[Customers_ReleaseSchedules:46]OrderLine:4  //*.   only do the first occurance
					$i:=1
					While (($i<=Records in selection:C76([Customers_ReleaseSchedules:46])) & ($sOrdLine=[Customers_ReleaseSchedules:46]OrderLine:4))
						If ([Customers_ReleaseSchedules:46]ChgOrdItmPosted:27=False:C215)
							[Customers_ReleaseSchedules:46]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
							[Customers_ReleaseSchedules:46]ChgOrdItmPosted:27:=True:C214
							SAVE RECORD:C53([Customers_ReleaseSchedules:46])
							NEXT RECORD:C51([Customers_ReleaseSchedules:46])
						End if 
						$i:=$i+1
					End while 
					
				Else 
					// 4D PS you don't need first record you use query before 
					
					ARRAY LONGINT:C221($_Customers_ReleaseSchedules; 0)
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; $_Customers_ReleaseSchedules)
					
					$sOrdLine:=[Customers_ReleaseSchedules:46]OrderLine:4
					$OrderLine_Customers_Order_Lines:=[Customers_Order_Lines:41]OrderLine:3
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$sOrdLine; *)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ChgOrdItmPosted:27=False:C215)
					APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4:=$OrderLine_Customers_Order_Lines)
					APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ChgOrdItmPosted:27:=True:C214)
					
					CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_Customers_ReleaseSchedules)
					
				End if   // END 4D Professional Services : January 2019 First record and next 
				
				
			End if   //there are releases
			
		Else   //*old item doesn't exist anymore
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderNumber:2=[Customers_Order_Change_Orders:34]OrderNo:5; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=[Customers_Order_Changed_Items:176]OldProductCode:9)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				CONFIRM:C162("If this is a product code change from "+[Customers_Order_Changed_Items:176]OldProductCode:9+" to "+[Customers_Order_Changed_Items:176]NewProductCode:10+" then click 'OK'.")
				If (OK=1)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
						
						FIRST RECORD:C50([Customers_ReleaseSchedules:46])
						$sOrdLine:=[Customers_ReleaseSchedules:46]OrderLine:4
						$i:=1
						While (($i<=Records in selection:C76([Customers_ReleaseSchedules:46])) & ($sOrdLine=[Customers_ReleaseSchedules:46]OrderLine:4))
							If ([Customers_ReleaseSchedules:46]ChgOrdItmPosted:27=False:C215)
								[Customers_ReleaseSchedules:46]ProductCode:11:=[Customers_Order_Changed_Items:176]NewProductCode:10
								[Customers_ReleaseSchedules:46]ChgOrdItmPosted:27:=True:C214
								SAVE RECORD:C53([Customers_ReleaseSchedules:46])
								NEXT RECORD:C51([Customers_ReleaseSchedules:46])
							End if 
							$i:=$i+1
						End while 
						
					Else 
						
						ARRAY LONGINT:C221($_Customers_ReleaseSchedules; 0)
						SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; $_Customers_ReleaseSchedules)
						$sOrdLine:=[Customers_ReleaseSchedules:46]OrderLine:4
						$NewProductCode_Customers_Order:=[Customers_Order_Changed_Items:176]NewProductCode:10
						
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$sOrdLine; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ChgOrdItmPosted:27=False:C215)
						APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4:=$NewProductCode_Customers_Order)
						APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ChgOrdItmPosted:27:=True:C214)
						CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_Customers_ReleaseSchedules)
					End if   // END 4D Professional Services : January 2019 First record with next
					
				Else 
					ALERT:C41("Error:  old cpn: "+[Customers_Order_Changed_Items:176]OldProductCode:9+" New CPN: "+[Customers_Order_Changed_Items:176]NewProductCode:10+" Outstanding Releases for Deleted CPN.  Release Number "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1))
					//BAK 9/16/94  may need to qustion to delete releases later.
				End if   //there has been a cpn chnage
			End if   //there are releases
		End if   //does old exist
		
		NEXT RECORD:C51([Customers_Order_Changed_Items:176])
		//End for   `each cco item
	End while 
End if   //there are releases
//