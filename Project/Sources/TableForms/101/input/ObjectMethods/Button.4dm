

$htmlPath_t:=Temporary folder:C486+"email.html"
TEXT TO DOCUMENT:C1237($htmlPath_t; [x_email_logs:101]EmailBody:5)
$url:="file://"+Replace string:C233($htmlPath_t; ":"; "/")
WA OPEN URL:C1020(*; "Web Area"; $url)
