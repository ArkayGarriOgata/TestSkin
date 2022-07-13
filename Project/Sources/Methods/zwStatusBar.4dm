//%attributes = {"publishedWeb":true}
//Procedure: zwStatusBar()  020597  MLB
//floating window at bottom of screen for messages
//see zwstatusmsg
//C_LONGINT(◊StatusBar)
//C_TEXT(◊CurrentUser)
//◊CurrentUser:=Current user
//◊StatusBar:=New process("zwStatusBar";(24*1024);"$StatusBar")

C_LONGINT:C283($sw; $sh)
$sw:=Screen width:C187
$sh:=Screen height:C188
C_TEXT:C284(Status1; Status2; <>Status1; <>Status2; <>ThemoWhat)
C_LONGINT:C283(<>Thermometer; <>ThemoMax; <>StatusPage)
<>Thermometer:=0
<>ThemoMax:=0
<>StatusPage:=0
<>ThemoWhat:=""
SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
<>StatusWindow:=Open window:C153(0; $sh-20; $sw; $sh; 3)  //was minus 3, but this cause focus lost after dios
DIALOG:C40([zz_control:1]; "StatusBar")

<>StatusBar:=0
//