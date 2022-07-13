
Case of 
		//: (Form event=On Header Click)
		//if(not(nil(columnClicked))
		//OBJECT SET FONT STYLE(columnClicked->;Plain)
		//columnClicked->:=0
		//end if
		
		//columnClicked:=OBJECT Get pointer(Object current)
		//OBJECT SET FONT STYLE(columnClicked->;Bold)
		//columnClicked->:=1
		
	: (Form event code:C388=On After Sort:K2:28)
		C_POINTER:C301(columnClicked)
		C_TEXT:C284($sort_string; $column_title)
		C_LONGINT:C283($i; $sort_order)
		
		columnClicked:=OBJECT Get pointer:C1124(Object current:K67:2)
		$column_title:=OBJECT Get title:C1068(columnClicked->)
		$sort_order:=0
		tSortOrder:="Sorted by "
		Case of   //multi-key sort is helpful 
			: ($column_title="Released")
				$sort_order:=PSG_LocalArray("sort"; 1)
				
			: ($column_title="Gluer")
				$sort_order:=PSG_LocalArray("sort"; 2)
				
			: ($column_title="HRD")
				$sort_order:=PSG_LocalArray("sort"; 3)
				
			: ($column_title="Product Code")
				$sort_order:=PSG_LocalArray("sort"; 5)
				
			: ($column_title="Customer")
				$sort_order:=PSG_LocalArray("sort"; 6)
				
			: ($column_title="Gluer")
				$sort_order:=PSG_LocalArray("sort"; 7)
		End case 
		
		If ($sort_order>0)  //display sort order hint
			$sort_string:=String:C10($sort_order)
			For ($i; 1; Length:C16($sort_string))
				tSortOrder:=tSortOrder+$sort_string[[$i]]+","
			End for 
			//tSortOrder:=Substring(tSortOrder;1;(Length(tSortOrder)-1))  //remove last comma
			
		Else   //single column sort
			tSortOrder:=tSortOrder+$column_title
		End if 
		
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "select@"; False:C215)  //reset everything off
		OBJECT SET ENABLED:C1123(bEdit; False:C215)
		OBJECT SET ENABLED:C1123(bHistory; False:C215)
		OBJECT SET TITLE:C194(bAskMe; "Ask Me")
		OBJECT SET TITLE:C194(b4Edit; "Job")
		OBJECT SET TITLE:C194(bSizeNStyle; "S&S")
		
		If (aGlueListBox<=Size of array:C274(aGlueListBox)) & (aGlueListBox#0)  //clicked on a row
			If (Find in array:C230(aGlueListBox; True:C214)>0)  //hilighted the row
				zwStatusMsg("click"; String:C10(aRecNum{aGlueListBox})+" "+aCPN{aGlueListBox}+"  "+aJobit{aGlueListBox})
				<>jobform:=Substring:C12(aJobit{aGlueListBox}; 1; 8)
				<>jobit:=aJobit{aGlueListBox}
				<>jobformseq:=""  // Modified by: Mel Bohince (10/12/17) see eBag btn on [zz_control].PressSchedule.eBagBtn 
				tText:=<>jobform
				If (Not:C34(<>Rama_Palette_Entry))  //not those people, so turn it on and add to button names
					OBJECT SET ENABLED:C1123(*; "select@"; True:C214)
					OBJECT SET TITLE:C194(bAskMe; "Ask Me-"+aCPN{aGlueListBox})
					OBJECT SET TITLE:C194(b4Edit; "Job-"+Substring:C12(aJobit{aGlueListBox}; 1; 8))
					OBJECT SET TITLE:C194(bSizeNStyle; "S&S-"+aOutline{aGlueListBox})
				End if 
				
				If (Not:C34(User in group:C338(Current user:C182; "Role_Glue_Scheduling")))  //prevent changes via button, see listbox for row level security
					OBJECT SET ENABLED:C1123(bEdit; False:C215)
					OBJECT SET ENABLED:C1123(bHistory; False:C215)
				End if 
				
			End if 
			
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		PSG_MasterArray("store"; aGlueListBox)
		
		LISTBOX SELECT ROW:C912(aGlueListBox; aGlueListBox; 0)
		//SetObjectProperties ("";->bAskMe;True;"Ask Me - "+aCPN{aGlueListBox})
		
End case 



