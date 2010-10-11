re_plan_action_confirm = function(id, title, action) {
  $('#re_plan_action_title').html(title);
  $('#re_plan_action_content_code').html($('#re_plan_code').html());
  $('#re_plan_action_content_title').html($('#re_plan_title').html());

  $('#re_plan_action_ok').attr('href', '#re_plan_' + id + '_form');
  $('#re_plan_action_ok').html("<span>" + action + "</span>")
  
  $.fancybox({ href: '#re_plan_action_confirm'});
}

$(document).ready(function() {	  

  $('a#re_plan_copy').live('click', function() {    
    var plan = $(this).attr('href').replace('#', '');
      
    $.re_block();
    $.get('/re_plans/' + plan + '/copy', null, null, 'script');
  	return false;  
  });  

  $("#re_plan_copy_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_plan_copy_duplicate').live('click', function() {
    $.re_block();
    $.post($('#re_plan_copy_form').attr('action'), $('#re_plan_copy_form').serialize(), null, 'script');    
    return false;
  });


  $('a#re_plan_edit').live('click', function() {    
    var plan = $(this).attr('href').replace('#', '');
      
    $.re_block();
    $.get('/re_plans/' + plan + '/edit', null, null, 'script');
  	return false;  
  });  

  $("#re_plan_edit_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_plan_edit_update').live('click', function() {
    $.re_block();
    $.post($('#re_plan_edit_form').attr('action'), $('#re_plan_edit_form').serialize(), null, 'script');    
    return false;
  });

  $('a#re_plan_publish').live('click', function() {  
    $('#re_plan_publish_warning').html('');
    $('#re_plan_publish_form #tag').attr('value', '')
    $('#re_plan_publish_tag').attr('value', '')
    $('#re_plan_publish_tag').re_form_valid();
    $('#re_plan_publish_tag').closest('#re_plan_publish_confirm').find('.form-error-message').remove();
    $.fancybox({ 'href': '#re_plan_publish_confirm' });          
    
  	return false;  
  });  

  $('a#re_plan_publish_with_errors').live('click', function() {  
    $('#re_plan_publish_warning').html('Warning! The plan you are publishing has errors!');
    $('#re_plan_publish_form #tag').attr('value', '')
    $('#re_plan_publish_tag').attr('value', '')
    $('#re_plan_publish_tag').re_form_valid();
    $('#re_plan_publish_tag').closest('#re_plan_publish_confirm').find('.form-error-message').remove();
    $.fancybox({ 'href': '#re_plan_publish_confirm' });          
    
  	return false;  
  });  

  $("#re_plan_publish_ok").live('click', function() {
    var tag = $.trim($('#re_plan_publish_tag').attr('value'))
    if (tag == null || tag.length == 0)
    {
      $('#re_plan_publish_tag').re_form_invalid();
      $('#re_plan_publish_tag').after('<span class="form-error-message">Tag Required</span>');
    }  
    else
    {
      $('#re_plan_publish_form #tag').attr('value', tag)
      $.re_block();
      $.post($('#re_plan_publish_form').attr('action'), $('#re_plan_publish_form').serialize(), null, 'script');    
    }
    return false;
  });  
  

  $('a#re_plan_revert').live('click', function() {    
    re_plan_action_confirm('revert', "Discard Plan Changed", "Discard Changes")
  	return false;  
  });  

  $('a#re_plan_delete').live('click', function() {    
    re_plan_action_confirm('delete', "Delete the Plan", "Delete Plan")
  	return false;  
  });  

  $("#re_plan_action_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_plan_action_ok').live('click', function() {
    var form_id = $(this).attr('href');

    $.re_block();
    $.post($(form_id).attr('action'), $(form_id).serialize(), null, 'script');    
    return false;
  });

});


