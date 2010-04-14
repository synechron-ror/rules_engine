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
  $('div.form-button').each(function() { 
   $(this).re_form_button(); 
  });  
	
	$('a.form-submit').live('click', function() {
	  var $form = $(this).closest('form');
	  if ($form.length)
		  $form.submit();
	});
	
	// nested attributes wrap in a new_position_NAME
	// and put the delete in the outermost div to be deleted so I can grab the parent and hide it
 	$('a.nested-add-link').live('click', function() {
 	  var value = eval('new_' + $(this).attr('id'))
 	  var $new_content = $($.replace_new_record_ids(value))
 		$("#new_position_" + $(this).attr('id')).append($new_content); 		
 		$new_content.find('input').focus();
 	});	
 	$('a.nested-remove-link').live('click', function() { 
		var id = $(this).attr('id').replace("_remove", "__delete");
		$('input[id=' + id + ']').attr('value', '1');
		$('input[id=' + id + ']').parent().hide();
 	});
	
});

