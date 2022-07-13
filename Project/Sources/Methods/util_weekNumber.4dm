//%attributes = {"publishedWeb":true}
//PM:  util_weekNumber  3/03/01  mlb
//created by Joachim Bondo Schultz
//week begins on Mondays
// • mel (10/14/04, 12:20:18) next year over 52, last year negative
// Modified by: Mel Bohince (3/3/21) change to algo from the tech tips
// Modified by: Mel Bohince (10/26/21) let the weeks run into next years

C_LONGINT:C283($0; $currentYear)
C_DATE:C307($test_date; $1; $first_day)
$currentYear:=Year of:C25(Current date:C33)

$test_date:=$1
$first_day:=Add to date:C393($test_date; 0; 1-Month of:C24($test_date); 1-Day of:C23($test_date))

$nextYears:=(Year of:C25($test_date)-$currentYear)*52

$0:=(Int:C8(($test_date-$first_day)/7)+1)+$nextYears
