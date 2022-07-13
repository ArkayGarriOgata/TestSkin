// _______
// Method: [Raw_Material_Labels].List.printBtn   ( ) ->
// By: MelvinBohince @ 03/14/18, 14:35:51
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (4/5/22) manage selction for the printlabel method

If (Records in set:C195("UserSet")>0)
	ARRAY LONGINT:C221($_beforePrint; 0)
	LONGINT ARRAY FROM SELECTION:C647([Raw_Material_Labels:171]; $_beforePrint)
	
	USE SET:C118("UserSet")  // Modified by: MelvinBohince (4/5/22) 
	
	RIM_PrintLabels
	
	CREATE SELECTION FROM ARRAY:C640([Raw_Material_Labels:171]; $_beforePrint)
	LOAD RECORD:C52([Raw_Material_Labels:171])  // Added by: Mel Bohince (4/17/19) 
End if 
