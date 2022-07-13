//(s) [control]movesubgroup'tSubgroup
//• 8/10/97 cs  created
txt_CapNstrip(Self:C308)

//If (Length(Self->)>17)
//Self->:=Substring(Self->;1;17)
//CONFIRM("The subgroup name can Not exceed 17 characters."+Char(13)+
//«"Truncating entered subgroup name to..."+Char(13)+Self->+Char(13)+"Keep
//« truncated name?";"No";"Keep")
//Else 
//OK:=1
//End if 

//If (OK=1)
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=i4; *)
QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10=Self:C308->)

Case of 
	: (Records in selection:C76([Raw_Materials_Groups:22])=0)
		ALERT:C41("The entered Subgroup ("+Self:C308->+") was NOT found in Commodity "+String:C10(i4; "00"))  //+Char(13)+"Do You want to create this Subgroup?")
		// If (OK=0)
		Self:C308->:=""
		//End if 
		//fNew:=(OK=1)  `flag that this is a NEW subgroup
		
	: (Records in selection:C76([Raw_Materials_Groups:22])>1)
		ALERT:C41("Please enter a Unique subgroup.")
		Self:C308->:=""
		
	Else   // only one found
		//$Loc:=Find in array(aText;Self»)
		//$Size:=Size of array(aText)
		//DELETE ELEMENT(aText;$Loc;1)
		//DELETE ELEMENT(aBullet;$Loc;1)
End case 
uClearSelection(->[Raw_Materials_Groups:22])
//Else 
GOTO OBJECT:C206(tSubgroup)
//End if 
//