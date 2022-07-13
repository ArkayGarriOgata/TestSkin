//%attributes = {"publishedWeb":true}
//(p) rPiFgCountSheet: Finished Goods Pysical inventory count sheet
//•112296   remove page breaking
//• 2/3/98 cs changed title, report is naemd the same but has ben changed
// to include 2 count columns

<>filePtr:=->[Finished_Goods_Locations:35]
uSetUp(1; 1)
//BEEP
//ALERT("Be sure Copies is set to 2 and Collated is off in the Print Settings Dialog")  `• mlb - 4/20/01  13:29
C_BOOLEAN:C305($pageBreak)
//uConfirm ("One bin per page?";"Yes";"No")
uConfirm("Page Break on Rows?"; "Yes"; "No")
If (ok=1)
	$pageBreak:=True:C214
Else 
	$pageBreak:=False:C215
End if 

SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Bin Status Report")
NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
If (OK=1)
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "BinStatusRpt")
		FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "BinStatusRpt")
		PRINT SETTINGS:C106
		If (ok=1)
			ARRAY TEXT:C222(aLoc; 0)
			//ARRAY TEXT(aLoc;Records in table([WMS_AllowedLocations]))  `• mlb - 4/20/01  13:30
			For ($i; 1; Size of array:C274(aLoc))
				aLoc{$i}:=""
			End for 
			C_LONGINT:C283(iOnPage)
			iOnPage:=0  //used as a cursor to the aLoc array      
			
			iPage:=1
			C_LONGINT:C283(iPageOffset)
			iPageOffset:=Num:C11(Request:C163("Page numbering begins at:"; "1001"))
			If (ok=1)
				If (iPageOffset>0)
					iPageOffset:=iPageOffset-1
				End if 
			Else 
				iPageOffset:=0
			End if 
			aQtyOH:=0
			
			//----------SET UP MAIN HEADER----------
			xReptTitle:="Finished Goods Inventory Count Sheet"
			xComment:="The Report is sorted by Finished Goods Location"
			MESSAGES OFF:C175
			//ORDER BY([Finished_Goods_Locations];[Finished_Goods_Locations]Location;>;[Finished_Goods_Locations]Jobit;>)
			ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; >; [Finished_Goods_Locations:35]Bin:38; >; [Finished_Goods_Locations:35]Tier:39; >; [Finished_Goods_Locations:35]Jobit:33; >)
			
			ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; rReal1)
			If ($pageBreak)
				BREAK LEVEL:C302(1; 1)  //page break
			Else 
				BREAK LEVEL:C302(1)  //no page break
			End if 
			PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
			
			//ARRAY TEXT(aLoc;iOnPage)
			//C_TEXT($cr)
			//$cr:=Char(13)
			//xText:="TAG NO"+Char(9)+"BIN LOCATION"+$cr
			//For ($i;1;Size of array(aLoc))
			//xText:=xText+aLoc{$i}+$cr
			//End for 
			//xTitle:="FG TAG CONTROL REPORT "+TS2String (TSTimeStamp )
			//$filename:="FG_TAGS_"+String(TSTimeStamp )+".xls"
			//rPrintText ($filename)
			//$File:=GetDefaultPath 
			//
			//$File:=$File+$filename
			
			xText:=""
			xTitle:=""
			ARRAY TEXT:C222(aLoc; 0)
			//BEEP
			//ALERT("Your tag report was save in file "+$filename)
		End if   //print settings
		FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
	End if 
End if 