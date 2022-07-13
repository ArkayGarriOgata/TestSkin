// JavaScript Document


// Create Base64 Object

var fVerifyOpen = false;
var fVerifyMode = true;



function startScanning(fVerify){
	fVerifyMode = fVerify;

	$("#beep").load();

	navGotoURL('#scanpage');
	GetVerifyDate();	

	setTimeout(function(){ 

			$("#barcode").on("change", function(event) { 
				
				if(fVerifyMode){
					VerifyCrate($("#barcode").val());
				}else{
					LookupCrate($("#barcode").val());
				}
			} );

		$("#barcode").focus(); 


	}, 1000);


}
	


function playBeep () { 
	//var audio = document.getElementById('beep');
	//audio.play();

	//audio.src = 'scan.wav';
	//audio.play(); // there will be a slight delay while the new audio file loads
	//window.alert('player');
	//document.getElementById('beep').play(); 
		$('#beep').get(0).play();

}	



function scanAlert(msg,duration)
{
	
	popupAlert(msg);
	
	/*
 var el = document.createElement("div");
 el.setAttribute("style","position:absolute;top:0px;left:0px;width:100%;height:100%;background-color:white;text-align:center;vertical-align: middle;");
 el.innerHTML = msg;
 setTimeout(function(){
  el.parentNode.removeChild(el);
 },duration);
 document.body.appendChild(el);
 */
}




$(document).ready(function() {
	


	$("#rm_username").val('');
	$("#rm_password").val('');
	


/*
	var input = document.querySelector('input[type=file]'); // see Example 4

	input.onchange = function () {
	  var file = input.files[0];
	
	  upload(file);
	  //drawOnCanvas(file);   // see Example 6
	  //displayAsImage(file); // see Example 7
	};
*/

	/*
	$("#cart").on("mouseenter", function() {
    	$(".shopping-cart").fadeToggle( "fast");
  	});

	$("#cart").on("mouseleave", function() {
    	$(".shopping-cart").fadeToggle( "fast");
  	});

	$("#cart").on("click", function() {
    	//$(".shopping-cart").fadeToggle( "fast");
  			window.location.href = "/YVT/Checkout/checkout.shtml";
	});

	$("#checkout_button").on("click", function() {
		window.location.href = "/YVT/Checkout/checkout.shtml";
  	});
	*/

});


function VerifyCrate(ttCode){
	$("#verifyError").html("");
		$("#verifySuccess").html("");
		$("#barcode").val("");
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ROMSMob_WebRequests");
	theRequest.addParameter('Action', "Crate_Verify");// Designates new image
	theRequest.addParameter('CrateSN', ttCode);// Designates new image
		
	//var ttFileData = file.data;
	//theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
		
		
									playBeep();// Play the sound that we scanned something

								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
									   if (ttResponse == "SUCCESS"){
											$("#verifySuccess").html(ttCode+"<br>VERIFIED SUCCESSFULLY");
										   	//scanAlert(ttCode+"<br>VERIFIED SUCCESSFULLY", 1000);



									   }else{
										   $("#verifyError").html(ttResponse);
										   scanAlert(ttResponse, 1000);
										   //popupAlert(ttResponse);
									   }
									
																				
								   } else {
									   popupAlert("An error occurred.");
								   }
								},null);
	
	
}





function LookupCrate(ttCode){
	$("#verifyError").html("");
		$("#verifySuccess").html("");
		$("#barcode").val("");
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ROMSMob_WebRequests");
	theRequest.addParameter('Action', "Crate_Lookup");// Designates new image
	theRequest.addParameter('CrateSN', ttCode);// Designates new image
		
	//var ttFileData = file.data;
	//theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
		
		
									playBeep();// Play the sound that we scanned something

								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
											$("#verifySuccess").html(ttResponse);
									
																				
								   } else {
									   popupAlert("An error occurred.");
								   }
								},null);
	
	
}





function configureScreen(){
	
	if(fVerifyOpen){
		$("#stopVerifyButton").show();	
		$("#startVerifyButton").hide();
		$("#verifyButton").show();
	}else{
		$("#stopVerifyButton").hide();
		$("#startVerifyButton").show();
		$("#verifyButton").hide();
		
	}

	
	
}

function gotoScanner(){
		$("#beep").load();
	
		navGotoURL('#scanpage');
		GetVerifyDate();				

	
		//$('#beep').get(0).play();
		
	/*
		$.getScript("./js/adapter-latest.js", function( data, textStatus, jqxhr ) {
			$.getScript("./js/Fp_Barcode.js", function( data, textStatus, jqxhr ) {
				$.getScript("./js/live_w_locator.js", function( data, textStatus, jqxhr ) {
					navGotoURL('#scanpage');
					GetVerifyDate();				
				} )
			} )
			
			
		} )
				
*/
		
	}



function startVerification(){
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ROMSMob_WebRequests");
	theRequest.addParameter('Action', "Crate_SetVerifyDate");
		
	//var ttFileData = file.data;
	//theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
									   if (ttResponse == "SUCCESS"){
										   fVerifyOpen = true;
										   //navGotoURL('/RomsMobile/Crates/verify.shtml');
										   

									   }else{
										   popupAlert(ttResponse);
									   }
									
																				
								   } else {
									   popupAlert("An error occurred.");
								   }
								
									configureScreen();
								},null);
	
	
	
	
	
}


///
function stopVerification(){
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ROMSMob_WebRequests");
	theRequest.addParameter('Action', "Crate_StopVerification");
		
	//var ttFileData = file.data;
	//theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
									   if (ttResponse == "SUCCESS"){
										   fVerifyOpen = false;
										   popupAlert("Verification has been completed");

									   }else{
										   popupAlert(ttResponse);
									   }
									
																				
								   } else {
									   popupAlert("An error occurred.");
								   }
								
									configureScreen();
								},null);
	
	
	
	
	
}



function GetVerifyDate(){
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","ROMSMob_WebRequests");
	theRequest.addParameter('Action', "Crate_GetVerifyDate");
		
	//var ttFileData = file.data;
	//theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
									   if (ttResponse == "NO DATE"){
										   $("#verifyStartedLabel").html("No Verification Open");
										   if(fVerifyMode){
											   $("#verifyStartedLabel2").html("No Verification Open");
										   }else{
											  $("#verifyStartedLabel2").html("Lookup Mode"); 
										   }
										   
										   
										   fVerifyOpen = false;


									   }else{
										   $("#verifyStartedLabel").html("Verification Started on "+ttResponse);
										   if(fVerifyMode){
										   		$("#verifyStartedLabel2").html("Verification Started on "+ttResponse);
										   }else{
											   $("#verifyStartedLabel2").html("Lookup Mode");
										   }
										   fVerifyOpen = true;
									   }
									
																				
								   } else {
									   popupAlert("An error occurred.");
								   }
								
									configureScreen();
								},null);
	
	
}









function showInspectionEntry(ttSeqNum, ttName){
	$("#currentISName").html(ttName);
	$("#currentISOrder").html($("#currentOrder").html());
	$("#currentISAccount").html($("#currentAccount").html());
	
	loadInspectionSheetEntry(ttSeqNum);
	queryForImages(ttSeqNum)
	
	var url = '#ISEntry';
	navGotoURL(url);
	
	
}


function loadCrates(ttRouteTo){
	
	var theCratesClass=new fourD_Crates();

	theCratesClass.init();


    var ttSQL = "Crates.Status <> 'Deleted'";
	
	theCratesClass.queryTableByFormula('CratesGetAllOpen', '', '', 
	function()
			{
				var ttText = '';

				for (var i = 0; i < theCratesClass.getRecordsInSelection(); i++)
				{
					theCratesClass.gotoRecord(i);
					
					var ttColor = theCratesClass.field4D_Color;
					if(ttColor.length > 0 ){
						ttText = ttText+'<li style="background-color:'+ttColor+'">'
					}else{
						ttText = ttText+'<li>'
					}
						
					
					
					ttText = ttText+'<h2>'+theCratesClass.field4D_SeqNum+'</h2>'
					ttText = ttText+'<p><strong>'+theCratesClass.field4D_Location+'</strong></p>'
					ttText = ttText+'<p>'+theCratesClass.field4D_Comment+'</p>'
						ttText = ttText+'<p class="ui-li-aside"><strong>Last Verified on '+theCratesClass.field4D_LastVerified+'</strong></p>'
					ttText = ttText+'</a></li>'
					


				}
				
				$("#crate_list").html(ttText);
				$('#crate_list').listview('refresh');// reload the company list
				$('#crate_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_SeqNum", "field4D_Location", "field4D_Date", "field4D_LastVerified", "field4D_Comment", "field4D_Color"]);

	
}






function setQuestionText(ttTextField, xlIndex){
	var ttValue = $(ttTextField).val();
	obFormEntryObject.Fields[xlIndex].Notes = ttValue;
	saveTheFormsRecord();
}

function saveTheFormsRecord(){
	
	var ttSeqNum = theFormsEntryClass.field4D_SeqNum;
	theFormsEntryClass.field4D_FormFields = JSON.stringify(obFormEntryObject); // stringify the fields object and save it back to the database
	theFormsEntryClass.saveFieldWithKey("field4D_SeqNum", ttSeqNum, "field4D_FormFields", '', '', 
	function()
			{
				//Success, do nothing
			}, 
			function()
			{
				// Fail Function
				popupAlert("An error occurred, the record cannot be saved at this time.");
			});


}






function loadInspectionSheetEntry(ttSeqNum){

	theFormsEntryClass.init();


    var ttSQL = "InspectionForms.SeqNum = "+ttSeqNum;
	
	theFormsEntryClass.queryTable(ttSQL, '', '', 
	function()
			{
				var ttText = '';
				if(theFormsEntryClass.getRecordsInSelection() > 0){
					theFormsEntryClass.gotoRecord(0); // activate the first and only record in the selection
					if(theFormsEntryClass.field4D_FormFields.length > 0){
						obFormEntryObject = JSON.parse(theFormsEntryClass.field4D_FormFields, null);
						var sttFieldArray = obFormEntryObject.Fields;
						for (var i = 0; i < sttFieldArray.length; i++)
						{
							var ttFieldData = sttFieldArray[i];
							var ttDone = "";
							if(ttFieldData.Done){
								ttDone = "selected";
							}
							
							
							
							ttText = ttText + '<li class="ui-field-contain">';
							ttText = ttText + '<div class="ui-corner-all custom-corners">';
							ttText = ttText + '<div class="ui-bar ui-bar-a">';
							
							ttText = ttText + '<h2>'+ttFieldData.FieldName+'</h2>';
								ttText = ttText + '<div style="position:absolute; right:10px; top:5px;">';
									ttText = ttText + '<select name="done-'+i+'" id="done-'+i+'" data-role="slider" onchange="setDone(this, '+i+')">';
										ttText = ttText + '<option value="off"></option>';
										ttText = ttText + '<option value="on"'+ttDone+'>Done</option>';
									ttText = ttText + '</select>';
								ttText = ttText + '</div>';
							ttText = ttText + '</div>';
							
							ttText = ttText + '<div class="ui-body ui-body-a">';
								//ttText = ttText + '<label for="textarea-'+i+'" class="ui-hidden-accessible">Textarea:</label>';
								ttText = ttText + '<textarea name="textarea-'+i+'" id="textarea-'+i+'" onchange="setQuestionText(this, '+i+')">'+ttFieldData.Notes+'</textarea>';
							ttText = ttText + '</div>';
								
							
							
							
							
							ttText = ttText + '</div>';
							ttText = ttText + '</li>';
							
							
							
							
							
							
							
							
						} // End for
						
					}
					
				}
				
				
				
				$("#field_list").html(ttText);
				$('#field_list').listview('refresh');// reload the company list
				$('#field_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, null);

	
	
}





