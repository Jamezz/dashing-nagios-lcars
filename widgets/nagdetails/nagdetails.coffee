class Dashing.Nagdetails extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
    prepGlobals()
    $('#nagiosDetailsTable').hide();
	

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    #console.log("nagdetails: onData() called")
    #$(@node).fadeOut().fadeIn()
    checkAlerts(data)

`
   function prepGlobals(){
    window.yellowAlertAudioPlayed = false;
	window.redAlertAudioPlayed = false;
   }
   function checkAlerts(data) {
    if (data !== null && data.criticals_details.length > 0){
	  playRedAlert();
	}
    else if (data !== null && data.warnings_details.length > 0){
	  playYellowAlert();
	  }
	else{
	  resetAlertStatus();
	 }
    }
	  
	function playYellowAlert(){
  	console.log("Yellow alert!");
	$('#federationLogo').hide();
	$('#nagiosDetailsTable').show();
	audio = document.getElementById('yellowalertaudio');
	if (audio !== null && window.yellowAlertAudioPlayed === false && window.redAlertAudioPlayed === false){
	  audio.play();
	  yellowAlertAudioPlayed = true;
	  }
	}
	function playRedAlert(){
  	console.log("Red alert!");
	$('#federationLogo').hide();
	$('#nagiosDetailsTable').show();
	$('.alert_text').addClass('ra_redText5');
	for(i = 1;i <= 5; i++){
	   replaceColorClass('stdcolor'+i.toString(), 'ra_red'+i.toString());
	}
	
	audio = document.getElementById('redalertaudio');
	if (audio !== null && window.redAlertAudioPlayed === false){
	  audio.play();
	  redAlertAudioPlayed = true;
	  }
	}
	  
	function resetAlertStatus(){
	  console.log("Resetting alert status.");
	  $('.alert_text').removeClass('ra_redText5');
	  $('#nagiosDetailsTable').hide();
	  $('#federationLogo').show();
	  for(i = 1;i <= 5; i++){
	   replaceColorClass('ra_red'+i.toString(), 'stdcolor'+i.toString());
	}
	  audio = document.getElementById('restoredalertaudio');
	  if (audio !== null && (window.redAlertAudioPlayed === true || window.yellowAlertAudioPlayed === true)){
	    audio.play();
	    redAlertAudioPlayed = false;
	    yellowAlertAudioPlayed = false;
	}
	   
	}
`
