
Case of 
	: (Form event code:C388=On Load:K2:1)
		
		C_BOOLEAN:C305(Core_bLsBx1_Focus)
		C_BOOLEAN:C305(Core_bLsBx1_FrontMostWindow)
		
		C_LONGINT:C283(Core_nLsBx1_Header1)
		C_LONGINT:C283(Core_nLsBx1_Header2)
		
		
		LISTBOX INSERT COLUMN:C829(*; "Core_abLsBx1"; 1; "Core_atLsBx1_Column1"; Core_atLsBx1_Column1; "Core_nLsBx1_Header1"; Core_nLsBx1_Header1)
		LISTBOX INSERT COLUMN:C829(*; "Core_abLsBx1"; 2; "Core_atLsBx1_Column2"; Core_atLsBx1_Column2; "Core_nLsBx1_Header2"; Core_nLsBx1_Header2)
		
		LISTBOX SET ARRAY:C1279(Core_atLsBx1_Column1; lk font color array:K53:27; ->Core_anLsBx1_FontColor1)
		LISTBOX SET ARRAY:C1279(Core_atLsBx1_Column2; lk background color array:K53:28; ->Core_anLsBx1_BackColor1)
		
		
		ARRAY BOOLEAN:C223(Core_abLsBx1; 0)
		
		ARRAY TEXT:C222(Core_atLsBx1_Column1; 0)
		ARRAY TEXT:C222(Core_atLsBx1_Column2; 0)
		
		APPEND TO ARRAY:C911(Core_atLsBx1_Column1; "Hello")
		APPEND TO ARRAY:C911(Core_atLsBx1_Column1; "World")
		
		APPEND TO ARRAY:C911(Core_atLsBx1_Column2; "Bye")
		APPEND TO ARRAY:C911(Core_atLsBx1_Column2; "Now")
		
		
		//Row for the whole listbox color these are defined in the lisbox settings
		ARRAY LONGINT:C221(Core_anLsBx1_FontColor; 0)
		ARRAY LONGINT:C221(Core_anLsBx1_BackColor; 0)
		
		APPEND TO ARRAY:C911(Core_anLsBx1_FontColor; 7765131)
		APPEND TO ARRAY:C911(Core_anLsBx1_BackColor; 7765131)
		
		//Column colors that override the row colors
		
		ARRAY LONGINT:C221(Core_anLsBx1_FontColor1; 0)
		
		APPEND TO ARRAY:C911(Core_anLsBx1_FontColor1; 15528703)
		APPEND TO ARRAY:C911(Core_anLsBx1_FontColor1; 0)
		
		ARRAY LONGINT:C221(Core_anLsBx1_BackColor1; 0)
		
		APPEND TO ARRAY:C911(Core_anLsBx1_BackColor1; 8554649)
		APPEND TO ARRAY:C911(Core_anLsBx1_BackColor1; 7765131)
		
		ARRAY LONGINT:C221(anStyle; 0)
		
		APPEND TO ARRAY:C911(anStyle; Bold:K14:2)
		APPEND TO ARRAY:C911(anStyle; Italic:K14:3)
		
		
		//LISTBOX SET ARRAY(Core_atLsBx1_Column1;lk font color array;->Core_anLsBx1_FontColor)
		//LISTBOX SET ARRAY(Core_atLsBx1_Column2;lk background color array;->Core_anLsBx1_BackGround)
		
		//LISTBOX SET ARRAY(Core_atLsBx1_Column1;lk style array;->anStyle)
		
	: (Form event code:C388=On Losing Focus:K2:8)
		
		Core_bLsBx1_Focus:=False:C215
		
	: (Form event code:C388=On Getting Focus:K2:7)
		
		Core_bLsBx1_Focus:=True:C214
		
	: (Form event code:C388=On Activate:K2:9)
		
		Core_bLsBx1_FrontMostWindow:=True:C214
		
	: (Form event code:C388=On Deactivate:K2:10)
		
		Core_bLsBx1_FrontMostWindow:=False:C215
		
End case 