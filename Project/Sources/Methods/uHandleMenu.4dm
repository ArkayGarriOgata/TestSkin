//%attributes = {"publishedWeb":true}
If (False:C215)  //•• this has been eliminated, keep just in case
	//C_LONGINT($1;$Hit)  `uHandleMenu(action;text;test)
	// C_TEXT($2;$3;$Name)  `$2 just text,$3= file calling this proc
	// C_BOOLEAN($parent)
	// PROCESS ATTRIBUTES(Current process;$Name;$State;$Time)  `who am i
	// $parent:=(Position($3;$Name)#0)  `where am i
	// Case of 
	// : (Not($parent))
	//don't mess with the menu, we are traversing  
	// : ($1=1)  `turn on name in menu
	//  $Hit:=Find in array(◊aProcesses;Current process)
	// If ($Hit#-1)
	//   SET ITEM(2;$Hit+3;$Name+":"+$2)
	//   ENABLE ITEM(2;$Hit+3)
	//  End if 
	// : ((bModMany) & ($1=0))  `going back to a list    
	//  $Hit:=Find in array(◊aProcesses;Current process)
	// If ($Hit#-1)
	//   SET ITEM(2;$Hit+3;$Name+":"+"Selection")
	//  End if 
	// : ($1=0)  `turn off
	//  $Hit:=Current process
	//  $Hit:=Find in array(◊aProcesses;$Hit)  `get element number
	// If ($Hit#-1)
	//   ◊aProcesses{$Hit}:=0
	//  SET ITEM(2;$Hit+3;String($Hit))
	//  DISABLE ITEM(2;$Hit+3)
	//  End if 
	// End case 
End if 