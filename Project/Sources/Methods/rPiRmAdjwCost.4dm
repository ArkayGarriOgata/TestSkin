//%attributes = {"publishedWeb":true}
//(p) rPiFgAdjwCost
//Created 3/5/97 cs upr 1858
//codifying a quick report Melissa usesd for Cycle count/Phys Inventory

C_TIME:C306(vDoc)

t2:=""
vDoc:=?00:00:00?

uClearSelection(->[Raw_Materials_Transactions:23])
uDialog("SelectDivision"; 250; 200)

If (OK=1)
	util_PAGE_SETUP(->[Raw_Materials_Transactions:23]; "PiRmAdjust")
	PRINT SETTINGS:C106
	
	If (OK=1)
		Case of   //§locate records to print
			: (rbAll=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
					t2:="All Divisions"
				Else 
					t2:="Commodity: "+sCommKey+" in All Divisions"
				End if 
			: (rbArkay=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20="1"; *)
					t2:="Hauppauge Only"
				Else 
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20="1"; *)
					t2:="Commodity: "+sCommKey+" in Hauppauge Only"
				End if 
			: (rbRoanoke=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20="2"; *)
					t2:="Roanoke Only"
				Else 
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20="2"; *)
					t2:="Commodity: "+sCommKey+" in Roanoke Only"
				End if 
			: (rbLabel=1)
				If (cbAllComm=1)
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20="3"; *)
					t2:="Labels Only"
				Else 
					QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20="3"; *)
					t2:="Commodity: "+sCommKey+" in Labels Only"
				End if 
		End case 
		
		Case of 
			: (cbAllComm=1) & (rbAll=0)  //specified location, all commodities
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=Num:C11(sCommkey); *)
			: (cbAllComm=0) & (rbAll=1)  //specified commodity, all locations
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=Num:C11(sCommkey); *)
			: (cbAllComm=0)  //specified location, specified commodity
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=Num:C11(sCommkey); *)
		End case 
		
		If (Not:C34((rbAll=1) & (cbAllComm=1)))
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)  //physical inventory for date range entered  
		End if 
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Reason:5="Phy@")
		
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CompanyID:20; >; [Raw_Materials_Transactions:23]CommodityCode:24; >; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; >)
			t2:="Phys Inv RM Adjustments with costs for '"+t2+"' "+String:C10(dDateBegin)+" thru "+String:C10(dDateEnd)
			
			If (fSave)  //user wants to save to disk      
				vDoc:=Create document:C266("PiRmAdjRpt")
				SEND PACKET:C103(vDoc; t2+Char:C90(13))
				SEND PACKET:C103(vDoc; "XActionType"+Char:C90(9)+"XActionDate"+Char:C90(9)+"Product Code"+Char:C90(9)+"JobForm"+Char:C90(9)+"Quantity"+Char:C90(9)+"Location"+"Extended Value"+Char:C90(9)+"Mod Who"+Char:C90(13))
			Else 
				vDoc:=?00:00:00?
			End if 
			FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "PiRmAdjust")
			BREAK LEVEL:C302(2)
			ACCUMULATE:C303([Raw_Materials_Transactions:23]ActExtCost:10; [Raw_Materials_Transactions:23]Qty:6)
			PRINT SELECTION:C60([Raw_Materials_Transactions:23]; *)
			FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "list")
		Else 
			ALERT:C41("No Transactions currently exist for your request.")
		End if 
		uClearSelection(->[Raw_Materials_Transactions:23])
	End if 
End if 

If (vDoc#?00:00:00?)
	CLOSE DOCUMENT:C267(vDoc)
End if 