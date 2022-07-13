//%attributes = {}
// _______
// Method: util_PAGE_SETUP(->[table];"formName") ->
// By: Mel Bohince @ 04/23/20, 10:32:31
// Description
// replacement for obsolete PAGE SETUP
// sets orientation and scaling for printing
// ----------------------------------------------------
// Modified by: Mel Bohince (4/16/21) change default from 70 to 60%

C_LONGINT:C283($width; $height; $widthPoints)
FORM GET PROPERTIES:C674($1->; $2; $width; $height)
$widthPoints:=Int:C8($width*1)  //0.75 pixel to point conversion

$eightInches:=Round:C94(72*8.5; 0)  //612 in points, guessing 1/72 inches per point 
$tenInches:=Int:C8(72*10.5)  //720
$twelveInches:=72*12  //864
$fourteenInches:=72*14  //1008

Case of 
	: ($widthPoints<=$eightInches)
		SET PRINT OPTION:C733(Orientation option:K47:2; 1)  //1=Portrait, 2=Landscape
		SET PRINT OPTION:C733(Scale option:K47:3; 100)
		
	Else 
		SET PRINT OPTION:C733(Orientation option:K47:2; 2)  //1=Portrait, 2=Landscape
		
		Case of 
			: ($widthPoints<=$tenInches)
				SET PRINT OPTION:C733(Scale option:K47:3; 100)
				
			: ($widthPoints<=$twelveInches)
				SET PRINT OPTION:C733(Scale option:K47:3; 90)
				
			: ($widthPoints<=$fourteenInches)
				SET PRINT OPTION:C733(Scale option:K47:3; 80)
				
			Else 
				SET PRINT OPTION:C733(Scale option:K47:3; 60)  // Modified by: Mel Bohince (4/16/21) was 70
		End case 
		
End case 
