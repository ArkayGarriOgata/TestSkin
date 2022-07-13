//%attributes = {}
//Method: Help_View_LoadHList
//Description:  This method will load the HList that holds 
// The indexes of pages a user may want to see

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $esHelp)
	
	$esHelp:=New object:C1471()
	
	$esHelp:=$1
	
	Compiler_Help_Array(Current method name:C684; 4)
	
	HelpapParameter{CoreknHListTable}:=->[Help:36]
	HelpapParameter{CoreknHListPrimaryKey}:=->[Help:36]Help_Key:1
	HelpapParameter{CoreknHListFolder}:=->[Help:36]Category:2
	HelpapParameter{CoreknHListTitle}:=->[Help:36]Title:3
	
End if   //Done initialize

USE ENTITY SELECTION:C1513($esHelp)

If (Records in selection:C76([Help:36])>0)  //Record
	
	ORDER BY:C49([Help:36]; [Help:36]Category:2; >; [Help:36]Title:3; >)
	
	Core_HList_Initialize(1; ->HelpapParameter)
	
	Core_HList_Create(1; True:C214)
	
Else 
	
	CLEAR LIST:C377(CorenHList1)
	
	CorenHList1:=0
	
End if   //Done record  

REDUCE SELECTION:C351([Help:36]; 0)

REDRAW:C174(CorenHList1)