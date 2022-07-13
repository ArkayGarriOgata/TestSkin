//%attributes = {"publishedWeb":true}
//Procedure: SF_ShopHolidays(date)->date  080497  MLB
//return the next workday if holiday, same day if not
//v1.0.0-PJK (12/23/15)  completely rewrote to automagically build Holiday lists on demand
// Modified by: Mel Bohince (1/20/16) Stop excluding holidaz
// sometimes departments work thru the holiday

//C_LONGINT($i;$days;$xlResult;$xlDay;$xlMonth;$xlYear)  //$1;$timeStamp
C_DATE:C307($1; $date; $0)
//C_TEXT($ttURL;$ttHTML;$ttName)
//C_OBJECT($obDate)
$0:=!00-00-00!  // Modified by: Mel Bohince (1/20/16) Stop excluding holidaz

//Case of 
//:(false)//pjk(Count parameters=0)  //construct calendar
//  //v1.0.0-PJK (12/23/15)  completely rewrote to automagically build Holiday lists on demand
//$xlYear:=Year of(4D_Current_date)
//$ttList:="ShopHolidays_"+String($xlYear)
//ARRAY TEXT($asHolidays;0)

//LIST TO ARRAY($ttList;$asHolidays)
//If (Size of array($asHolidays)=0)  // Need to build it
//$ttURL:="http://www.kayaposoft.com/enrico/json/v1.0/?action=getPublicHolidaysForYear&year="+String($xlYear)+"&country=usa"  //  &region=Pennsylvania

//$ttErrorMethod:=Method called on error  //v1.0.0-PJK (12/23/15) remember what was set as the error handler
//ON ERR CALL("e_EmptyErrorMethod")
//$xlResult:=HTTP Get($ttURL;$ttHTML)
//ON ERR CALL($ttErrorMethod)
//If ($xlResult=200)  // success is HTTP200
//ARRAY OBJECT($sobHolidays;0)
//JSON PARSE ARRAY($ttHTML;$sobHolidays)

//For ($i;1;Size of array($sobHolidays))
//$ttName:=OB Get($sobHolidays{$i};"localName")
//$obDate:=OB Get($sobHolidays{$i};"date")
//$xlMonth:=OB Get($obDate;"month")
//$xlDay:=OB Get($obDate;"day")
//$xlYear:=OB Get($obDate;"year")

//$dDate:=Date(String($xlMonth)+"/"+String($xlDay)+"/"+String($xlYear))
//APPEND TO ARRAY($asHolidays;String($dDate;System date short))
//End for 


//ARRAY TO LIST($asHolidays;$ttList)

//End if 

//End if 
//$days:=Size of array($asHolidays)
//If ($days>0)
//$0:=Date($asHolidays{1})
//Else 
//$0:=!00/00/0000!  //Size of array(aHolidays)
//End if 

//:(false)//original count params = 0
//ARRAY TEXT($asHolidays;0)
//LIST TO ARRAY("ShopHolidays";$asHolidays)
//$days:=Size of array($asHolidays)
//ARRAY DATE(aHolidays;$days)  //need a selection to array thingy 
//For ($i;1;$days)
//aHolidays{$i}:=Date($asHolidays{$i})
//End for 
//SORT ARRAY(aHolidays;>)
//If ($days>0)
//$0:=aHolidays{1}
//Else 
//$0:=!00/00/0000!  //Size of array(aHolidays)
//End if 

//Else   //return first workday  

//  //$timeStamp:=$1
//$date:=$1  //TS2Date ($1)

//$xlYear:=Year of($date)  //v1.0.0- (12/23/15)
//$ttList:="ShopHolidays_"+String($xlYear)  //v1.0.0- (12/23/15)
//ARRAY TEXT($asHolidays;0)  //v1.0.0- (12/23/15)
//LIST TO ARRAY($ttList;$asHolidays)  //v1.0.0- (12/23/15)

//$hit:=0
//Repeat 
//$hit:=Find in array($asHolidays;String($date;System date short))  //v1.0.0- (12/23/15)
//If ($hit>=0)
//$date:=$date+1
//  //$timeStamp:=$timeStamp+(3600*24)
//End if 
//Until ($hit<0)
//$0:=$date  //$timeStamp
//End case 