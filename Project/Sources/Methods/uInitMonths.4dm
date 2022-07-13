//%attributes = {"publishedWeb":true}
//(P) uInitMonths
//• 4/2/98 cs added number of days in the onth
// Modified by Mel Bohince on 2/23/07 at 15:47:34 : fix leap year

ARRAY TEXT:C222(<>ayMonth; 12)
ARRAY LONGINT:C221(<>aDaysInMth; 12)

<>ayMonth{4}:="April"
<>aDaysInMth{4}:=30
<>ayMonth{5}:="May"
<>aDaysInMth{5}:=31
<>ayMonth{6}:="June"
<>aDaysInMth{6}:=30
<>ayMonth{7}:="July"
<>aDaysInMth{7}:=31
<>ayMonth{8}:="August"
<>aDaysInMth{8}:=31
<>ayMonth{9}:="September"
<>aDaysInMth{9}:=30
<>ayMonth{10}:="October"
<>aDaysInMth{10}:=31
<>ayMonth{11}:="November"
<>aDaysInMth{11}:=30
<>ayMonth{12}:="December"
<>aDaysInMth{12}:=31
<>ayMonth{1}:="January"
<>aDaysInMth{1}:=31
<>ayMonth{2}:="February"
<>aDaysInMth{2}:=28+(1*(Num:C11(Year of:C25(Current date:C33)%4=0)))  //28
<>ayMonth{3}:="March"
<>aDaysInMth{3}:=31