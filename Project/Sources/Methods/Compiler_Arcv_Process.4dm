//%attributes = {}
//Method:  Compiler_Core_Array(tMethodName)
//Description:  This method initializes process variables

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tMethodName)
	
	$tMethodName:=$1
	
End if   //Done initialization

Case of   //Method name
		
	: ($tMethodName="Arcv_View_Import")
		
		C_OBJECT:C1216(Arcv_oTableSelected)
		
		Arcv_oTableSelected:=New object:C1471()
		
	: ($tMethodName="Arcv_View_TableName")
		
		C_LONGINT:C283(Arcv_nView_Header01)
		C_LONGINT:C283(Arcv_nView_Header02)
		C_LONGINT:C283(Arcv_nView_Header03)
		C_LONGINT:C283(Arcv_nView_Header04)
		C_LONGINT:C283(Arcv_nView_Header05)
		C_LONGINT:C283(Arcv_nView_Header06)
		C_LONGINT:C283(Arcv_nView_Header07)
		C_LONGINT:C283(Arcv_nView_Header08)
		C_LONGINT:C283(Arcv_nView_Header09)
		C_LONGINT:C283(Arcv_nView_Header10)
		
		C_LONGINT:C283(Arcv_nView_Footer01)
		C_LONGINT:C283(Arcv_nView_Footer02)
		C_LONGINT:C283(Arcv_nView_Footer03)
		C_LONGINT:C283(Arcv_nView_Footer04)
		C_LONGINT:C283(Arcv_nView_Footer05)
		C_LONGINT:C283(Arcv_nView_Footer06)
		C_LONGINT:C283(Arcv_nView_Footer07)
		C_LONGINT:C283(Arcv_nView_Footer08)
		C_LONGINT:C283(Arcv_nView_Footer09)
		C_LONGINT:C283(Arcv_nView_Footer10)
		
		Arcv_nView_Header01:=0
		Arcv_nView_Header02:=0
		Arcv_nView_Header03:=0
		Arcv_nView_Header04:=0
		Arcv_nView_Header05:=0
		Arcv_nView_Header06:=0
		Arcv_nView_Header07:=0
		Arcv_nView_Header08:=0
		Arcv_nView_Header09:=0
		Arcv_nView_Header10:=0
		
		Arcv_nView_Footer01:=0
		Arcv_nView_Footer02:=0
		Arcv_nView_Footer03:=0
		Arcv_nView_Footer04:=0
		Arcv_nView_Footer05:=0
		Arcv_nView_Footer06:=0
		Arcv_nView_Footer07:=0
		Arcv_nView_Footer08:=0
		Arcv_nView_Footer09:=0
		Arcv_nView_Footer10:=0
		
End case   //Done method name
