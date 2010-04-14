jQuery.growl_message = function(style, header, message, timeout){
	var $m = $('<div class="' + style + '"></div>');
	$m.append('<strong>' + header + '</strong>');
	if (message) $m.append(' : ' + message);
	if (timeout == undefined) timeout = 2300;
  $.blockUI({
		message: $m, 
		fadeIn: 700, 
		fadeOut: 2000, 
		centerY: false,
		timeout: timeout, 
		showOverlay: false,
		css: {
						width:    '450px',
						top:      '10px',
						left:     '',
						right:    '10px',
					  border:   'none',
					  padding:  '5px',
					  opacity:   0.95,
						cursor:    null,
					  color:    '#000',
					  backgroundColor: '#fff6bf',
					  '-webkit-border-radius': '10px',
					  '-moz-border-radius':    '10px'
					}
   });
}

jQuery.error_message = function(message, timeout){
	jQuery.growl_message('growl-error', 'Error', message, timeout);
}
jQuery.success_message = function(message, timeout){
	jQuery.growl_message('growl-success', 'Success', message, timeout);
}
jQuery.notice_message = function(message, timeout){
	jQuery.growl_message('growl-notice', 'Notice', message, timeout);
}

$(document).ready(function() {	
	// make success, notice and failure message growl at the user
	if ($('.error').length) {
			$.error_message($('.error').text());
			$('.error').hide();			
	}		
	if ($('.success').length) {
			$.success_message($('.success').text());
			$('.success').hide();			
	}		
	if ($('.notice').length) {
			$.notice_message($('.notice').text());
			$('.notice').hide();			
	}			
});