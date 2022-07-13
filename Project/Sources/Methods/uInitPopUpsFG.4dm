//%attributes = {"publishedWeb":true}
//uInitPopUpsFG 10/14/94 try to make uInitPopUps less than 32K
//2/13/95 upr 1333
//•091196  MLB  set up for roanoke
//
// /// arrays will be used to become the To locations given the from, 
// /// so if in CC, then asCC will have the allowed options for the move as in
// /// COPY ARRAY(◊asCC;asMove)
//
//---------------Finished Goods Popup----------------
// Modified by: Mel Bohince (5/18/17) get some O/S love, remove hauppauge types
If (User in group:C338(Current user:C182; "Roanoke")) | (True:C214)
	
	ARRAY TEXT:C222(<>asWIP; 0)
	READ ONLY:C145([WMS_AllowedLocations:73])
	QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]ValidLocation:1="CC@")
	SELECTION TO ARRAY:C260([WMS_AllowedLocations:73]ValidLocation:1; <>asWIP)
	
	ARRAY TEXT:C222(<>asEx; 6)
	<>asEx{1}:="XC:R"  //2/13/95 upr 1333
	<>asEx{2}:="EX:R"
	<>asEx{3}:="FG:R"
	<>asEx{4}:="XC:"
	<>asEx{5}:="Ex:"
	<>asEx{6}:="FG:"
	
	ARRAY TEXT:C222(<>asCC; 6)
	<>asCC{1}:="FG:R"
	<>asCC{2}:="XC:R"
	<>asCC{3}:="EX:R"
	<>asCC{4}:="FG:OS"
	<>asCC{5}:="XC:OS"
	<>asCC{6}:="EX:OS"
	
	ARRAY TEXT:C222(<>asXC; 4)
	<>asXC{1}:="EX:R"
	<>asXC{2}:="FG:R"
	<>asXC{3}:="FG:OS"
	<>asXC{4}:="EX:OS"
	
	ARRAY TEXT:C222(<>asRC; 1)
	<>asRC{1}:="Dk:R"
	
	ARRAY TEXT:C222(<>asFG; 6)
	<>asFG{1}:="FG:R"
	<>asFG{2}:="XC:R"
	<>asFG{3}:="EX:R"
	<>asFG{4}:="FG:OS"
	<>asFG{5}:="XC:OS"
	<>asFG{6}:="EX:OS"
	
	ARRAY TEXT:C222(<>asQA; 1)
	<>asQA{1}:="XC:R"
	
	ARRAY TEXT:C222(<>asCust; 3)
	<>asCust{1}:="XC:R"
	<>asCust{2}:="FG:R"
	<>asCust{3}:="Ex:R"
	
	
	ARRAY TEXT:C222(<>asSc; 5)  //an exception COPY ARRAY(◊asSc;asFrom)
	<>asSc{1}:="Ex:R"
	<>asSc{2}:="CC:R"
	<>asSc{3}:="QA:R"
	<>asSc{4}:="FG:R"
	<>asSc{5}:="XC:R"
	
	
	ARRAY TEXT:C222(<>asCE; 2)
	<>asCE{1}:="XC:R"
	<>asCE{2}:="PX:R"
	
	ARRAY TEXT:C222(<>asBH; 1)
	<>asBH{1}:="BH:R"
	
	
Else 
	ARRAY TEXT:C222(<>asWIP; 1)
	<>asWIP{1}:="CC:"
	
	ARRAY TEXT:C222(<>asEx; 6)
	<>asEx{1}:="XC:"  //2/13/95 upr 1333
	<>asEx{2}:="Ex:"
	<>asEx{3}:="FG:"
	<>asEx{4}:="XC:R"  //2/13/95 upr 1333
	<>asEx{5}:="Ex:R"
	<>asEx{6}:="FG:R"
	
	ARRAY TEXT:C222(<>asCC; 6)
	<>asCC{1}:="FG:"
	<>asCC{2}:="XC:"
	<>asCC{3}:="Ex:"
	<>asCC{4}:="FG:R"
	<>asCC{5}:="XC:R"
	<>asCC{6}:="Ex:R"
	
	ARRAY TEXT:C222(<>asXC; 4)
	<>asXC{1}:="Ex:"
	<>asXC{2}:="FG:"
	<>asXC{3}:="XC:R"
	<>asXC{4}:="Ex:R"
	
	ARRAY TEXT:C222(<>asRC; 1)
	<>asRC{1}:="Dk:"
	
	ARRAY TEXT:C222(<>asFG; 3)
	<>asFG{1}:="FG:"
	<>asFG{2}:="XC:"
	<>asFG{3}:="FG:R"
	
	ARRAY TEXT:C222(<>asQA; 1)
	<>asQA{1}:="XC:"
	
	ARRAY TEXT:C222(<>asCust; 3)
	<>asCust{1}:="FG:"
	<>asCust{2}:="XC:"
	<>asCust{3}:="Ex:"
	
	ARRAY TEXT:C222(<>asSc; 5)  //an exception used as COPY ARRAY(◊asSc;asFrom)
	<>asSc{1}:="Ex:"
	<>asSc{2}:="CC:"
	<>asSc{3}:="FG:"
	<>asSc{4}:="FX:"
	<>asSc{5}:="XC:"
	
	ARRAY TEXT:C222(<>asCE; 2)
	<>asCE{1}:="XC:"
	<>asCE{2}:="FX:"
	
	ARRAY TEXT:C222(<>asBH; 2)
	<>asBH{1}:="BH:R"
	<>asBH{2}:="BD:R"
End if 
//