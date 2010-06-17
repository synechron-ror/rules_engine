// Ste the fancybox defaults
$.extend($.fn.fancybox.defaults, { 
    hideOnOverlayClick : false,
    overlayOpacity : 0.6
   });
   
jQuery.re_block = function(){
  $.fancybox.showActivity();
  $.blockUI({message: null});

  var loading = $('#fancybox-loading')
  loading.unbind('click')  
}

jQuery.re_unblock = function(){
  $.fancybox.hideActivity();
  $.unblockUI();
}

jQuery.re_message = function(style, header, message) {
	var $m = $('<div class="' + style + '"></div>');
	$m.append('<strong>' + header + '</strong>');
	if (message) $m.append(' : ' + message);
	$m.append('<a class="re-alert-close" href="#">Close</a>');
  if ($('#re_alert').is(':visible')) {
    $('#re_alert').html($m);
  }
  else {
    $('#re_alert').html($m);
    $('#re_alert').slideDown('fast');      
  }
	
}

jQuery.re_error_message = function(message) {
	jQuery.re_message('error', 'Error', message);
}
jQuery.re_success_message = function(message) {
	jQuery.re_message('success', 'Success', message);
}
jQuery.re_notice_message = function(message) {
	jQuery.re_message('notice', 'Notice', message);
}

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

jQuery.fn.re_form_valid = function() {
  var $parent = $(this).parents('.re-form-field')
  $parent.find('.re-form-label-error').addClass('re-form-label').removeClass('re-form-label-error');
  $parent.find('.re-form-data-error').addClass('re-form-data').removeClass('re-form-data-error');

  // $(this).removeAttr("re-form-disabled"); 
  // $(this).parents('.re-form-field').removeClass('re-form-disabled');
}
jQuery.fn.re_form_invalid = function() {
  var $parent = $(this).parents('.re-form-field')
  $parent.find('.re-form-label').addClass('re-form-label-error').removeClass('re-form-label');
    $parent.find('.re-form-data').addClass('re-form-data-error').removeClass('re-form-data');

  // $(this).removeAttr("re-form-disabled"); 
  // $(this).parents('.re-form-field').removeClass('re-form-disabled');
}

jQuery.replace_new_record_ids = function(s){
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

// document ready
$(document).ready(function() {	
  $('a.re-alert-close').live('click', function() {
    $('#re_alert').slideUp('fast');
 	});	
  
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
 		$.fancybox.resize();
 	});	
 	$('a.re-remove-link').live('click', function() { 
		var id = $(this).attr('id').replace("_remove", "__delete");
		$('input[id=' + id + ']').attr('value', '1');
		$('input[id=' + id + ']').parent().hide();
		$.fancybox.resize();
 	});

  // used by fancybox to create fancy boxes ;)
  $('body').append('<div id="re_content_frame" style="display:none"><div id="re_content"> </div></div>');  
});

