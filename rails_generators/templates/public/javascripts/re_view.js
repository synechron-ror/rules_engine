jQuery.re_message = function(style, header, message, timeout){
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
	jQuery.re_message('growl-error', 'Error', message, timeout);
}
jQuery.success_message = function(message, timeout){
	jQuery.re_message('growl-success', 'Success', message, timeout);
}
jQuery.$.re_notice_message = function(message, timeout){
	jQuery.re_message('growl-notice', 'Notice', message, timeout);
}

$(document).ready(function() {	
	// make success, notice and failure message growl at the user
	if ($('.error').length) {
			$.re_error_message($('.error').text());
			$('.error').hide();			
	}		
	if ($('.success').length) {
			$.re_success_message($('.success').text());
			$('.success').hide();			
	}		
	if ($('.notice').length) {
			$.re_notice_message($('.notice').text());
			$('.notice').hide();			
	}			
});

// Form buttons
jQuery.fn.re_form_button = function() {
  
  var $input = $(this).find('input');
  if ($input.length == 0)
    return;
    
  var id = $input.attr('id');
  var value = $input.attr('value');
  var klass = $input.attr('class');
  
  var $a = $('<a/>')
  $a.addClass(klass);
  $a.addClass('form-submit');
  $a.attr('href', '#');
  $a.attr('id', id);
  $a.append('<span>' + value + "</span>");  
  $(this).html($a);
}

jQuery.fn.re_form_disable = function() {
  $(this).attr('re-form-disabled', true);   
  $(this).parents('.re-form-field').addClass('re-form-disabled');
}

jQuery.fn.re_form_enable = function() {
  $(this).removeAttr("re-form-disabled"); 
  $(this).parents('.re-form-field').removeClass('re-form-disabled');
}

jQuery.replace_new_record_ids = function(s){
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

// document ready
$(document).ready(function() {	
  $('div.re-form-button').each(function() { 
   $(this).re_form_button(); 
  });  
	
	$('a.form-submit').live('click', function() {
	  var $form = $(this).closest('form');
	  if ($form.length)
		  $form.submit();
	});
	
	// nested attributes wrap in a new_position_NAME
	// and put the delete in the outermost div to be deleted so I can grab the parent and hide it
 	$('a.re-add-link').live('click', function() {
 	  var value = eval('new_' + $(this).attr('id'))
 	  var $new_content = $($.replace_new_record_ids(value))
 		$("#new_position_" + $(this).attr('id')).append($new_content); 		
 		$new_content.find('input').focus();
 	});	
 	$('a.re-remove-link').live('click', function() { 
		var id = $(this).attr('id').replace("_remove", "__delete");
		$('input[id=' + id + ']').attr('value', '1');
		$('input[id=' + id + ']').parent().hide();
 	});
	
});

