C_PICTURE:C286($iPict)

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(sttAdvSchedPage; 2)
		sttAdvSchedPage{1}:="Need HRD"
		sttAdvSchedPage{2}:="All Scheduled"
		sttAdvSchedPage:=1
		
		AdvancedSchedulerGoToPage(sttAdvSchedPage)
		
		
		OBJECT SET FONT STYLE:C166(sttJobNum; Bold:K14:2)
		Core_ObjectSetColor(->sttJobNum; -(White:K11:1+(256*Grey:K11:15)))
		
		OBJECT SET FONT STYLE:C166(sttJobFormID; Bold and Italic:K14:9)
		
		
	: (Form event code:C388=On Timer:K2:25)
		
		
End case 

