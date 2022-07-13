// _______
// Method: [Users_Record_Accesses].List   ( ) ->
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/27/20) show names for obsoleted customers that had their leading zero changed to 9

Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		
		Case of 
			: ([Users_Record_Accesses:94]TableName:2=Table name:C256(->[Customers:16]))
				$shortName:=CUST_getName([Users_Record_Accesses:94]PrimaryKey:3; "elc")
				
				// Modified by: Mel Bohince (3/27/20) show names for obsoleted customers that had their leading zero changed to 9
				If (Position:C15("_name?"; $shortName)>0)
					$custid:="9"+Substring:C12([Users_Record_Accesses:94]PrimaryKey:3; 2)  //try again with the niner
					$shortName:=CUST_getName($custid; "elc")+" **"  //indicate that this one has spl needs
				End if 
				xText:=$shortName  //display in list view
				
			: ([Users_Record_Accesses:94]TableName:2=Table name:C256(->[Customers_Projects:9]))
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Users_Record_Accesses:94]PrimaryKey:3)
				xText:=[Customers_Projects:9]Name:2
				
		End case 
		
		
End case 
