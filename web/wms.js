	var ttScanMode = '';
	var fScannerActive = false;
	var ttCurrentBinID = '';
	var fCreateDieBoard = false;


$(document).ready(function() {


	
});

function setScanMode(ttMode){
	ttScanMode = ttMode;
}

function getScanMode(){
	return ttScanMode;
}

function startScanner(){
	fScannerActive = true;

}				  

function stopScanner(){
	fScannerActive = false;

}

function isScannerActive(){
	 return fScannerActive;
}

				  
function navGotoURL(ttURL){
		document.location.href=ttURL+'?'+Math.random();
		return true;
}




function logout(){
	
	
	
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ams_WebRequests");
	theRequest.addParameter('Action', "Logout");
		

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
											   var ttResponse = this.fourDResponse;
											   if(ttResponse.length >0){
												   if (ttResponse == "SUCCESS"){
															var url = '/index.shtml';
															navGotoURL(url);
												   }else{
												   		//window.alert("Invalid username or password.");
														popupAlert("Invalid Username or Password!");
												   }
												
																							
											   } else {
												   popupAlert("An error occurred, the request cannot be processed.");
											   }
											},null);

}


function login(){
	
	
	
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ams_WebRequests");
	theRequest.addParameter('Action', "Login");
	theRequest.addParameter('Username', $("#rm_username").val()); // Pass OrderItemSN, 
	theRequest.addParameter('Password', $("#rm_password").val()); // Pass zero for the new item
		
	//var myJSONString = JSON.stringify(obPageData);
	//theRequest.addData( myJSONString);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
											   var ttResponse = this.fourDResponse;
											   if(ttResponse.length >0){
												   if (ttResponse == "SUCCESS"){
															var url = '/index.shtml';
															navGotoURL(url);
												   }else{
												   		//window.alert("Invalid username or password.");
														popupAlert("Invalid Username or Password!");
												   }
												
																							
											   } else {
												   popupAlert("An error occurred, the request cannot be processed.");
											   }
											},null);

}


function isLoggedIn(){
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ams_WebRequests");
	theRequest.addParameter('Action', "IsLoggedIn");
		
	//var myJSONString = JSON.stringify(obPageData);
	//theRequest.addData( myJSONString);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
											   var ttResponse = this.fourDResponse;
											   if(ttResponse.length >0){
												   if (ttResponse == "SUCCESS"){
															$("#mainBody").show();
															$("#loginBody").hide();
												   }else{
													   $("#mainBody").hide();
													   $("#loginBody").show();

												   }
												
																							
											   } else {
												   popupAlert("An error occurred, the record cannot be saved at this time.");
											   }
											},null);
	
}


function checkLogin(){
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ams_WebRequests");
	theRequest.addParameter('Action', "IsLoggedIn");
		
	//var myJSONString = JSON.stringify(obPageData);
	//theRequest.addData( myJSONString);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
											   var ttResponse = this.fourDResponse;
											   if(ttResponse.length >0){
												   if (ttResponse != "SUCCESS"){
															var url = '/index.shtml';
															navGotoURL(url);
												   }else{
													   $("#mainBody").show();

												   }
												
																							
											   } else {
												   popupAlert("An error occurred, the record cannot be saved at this time.");
											   }
											},null);
	
}










function playBeep () { 
		$('#beep').get(0).play();
}	















