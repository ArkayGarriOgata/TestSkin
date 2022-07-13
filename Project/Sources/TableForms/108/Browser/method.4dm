Case of 
	: (Form event code:C388=On Load:K2:1)
		ALL RECORDS:C47([QA_Procedures:108])
		ARRAY TEXT:C222(aQAid; 0)
		ARRAY TEXT:C222(aQATopic; 0)
		ARRAY TEXT:C222(aQAVersion; 0)
		SELECTION TO ARRAY:C260([QA_Procedures:108]id:1; aQAid; [QA_Procedures:108]Topic:2; aQATopic; [QA_Procedures:108]Version:4; aQAVersion)
		REDUCE SELECTION:C351([QA_Procedures:108]; 0)
		SORT ARRAY:C229(aQAid; aQATopic; aQAVersion; >)
		ARRAY TEXT:C222(aQASectionId; 0)
		ARRAY TEXT:C222(aQASectionTopic; 0)
		ARRAY TEXT:C222(aQASectionVersion; 0)
		xText:=""
		
		//: (Form event=On Clicked )
		//HIGHLIGHT TEXT(xTEXT;1;1)
		//REDRAW(xText)
		
		
	: (Form event code:C388=On Unload:K2:2)
		ARRAY TEXT:C222(aQAid; 0)
		ARRAY TEXT:C222(aQATopic; 0)
		ARRAY TEXT:C222(aQAVersion; 0)
		
		ARRAY TEXT:C222(aQASectionId; 0)
		ARRAY TEXT:C222(aQASectionTopic; 0)
		ARRAY TEXT:C222(aQASectionVersion; 0)
		REDUCE SELECTION:C351([QA_Section:109]; 0)
End case 