re_plan_action_confirm = function(id, title, action) {
  $('#re_plan_action_title').html(title);
  $('#re_plan_action_content_code').html($('#re_plan_code').html());
  $('#re_plan_action_content_title').html($('#re_plan_title').html());

  $('#re_plan_action_ok').attr('href', '#re_plan_' + id + '_form');
  $('#re_plan_action_ok').html("<span>" + action + "</span>")
  
  $.fancybox({ href: '#re_plan_action_confirm'});
}

$(document).ready(function() {	  

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
    re_plan_action_confirm('publish', "Publish Plan", "Publish")
  	return false;  
  });  

  $('a#re_plan_deactivate').live('click', function() {    
    re_plan_action_confirm('deactivate', "Deactivate Plan", "Deactivate")
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

  // NEW PIPELINE
  $('a#re_workflow_new').live('click', function() {    
    var plan_id = $(this).attr('href').replace('#', '');  
    
    $.re_block();
    $.get('/re_plans/' + plan_id + '/workflows/new', null, function() {
          $.re_unblock();
          $.fancybox({ href: '#re_content'});
        }, 'script');
        
  	return false;  
  });  

  $("#re_workflow_new_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_workflow_new_insert').live('click', function() {
    $.re_block();    
    $.post($('#re_workflow_new_form').attr('action'), $('#re_workflow_new_form').serialize(), function() {
        $.fancybox.resize();
        $.re_unblock();
      }, 'script');
    
    return false;
  });

  // PIPELINE ADD
  $('a.re-menu-workflow-add').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $.re_block();
    $(this).removeClass('re-workflow-add');
    $(this).addClass('re-workflow-add-off');
    
    $.post($('#re_workflow_add_form_' + values[1]).attr('action'), $('#re_workflow_add_form_' + values[1]).serialize(), null, 'script');
  	return false;  
  });  

  // REMOVE PIPELINE
  $('a.re-list-workflow-remove').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $('#re_workflow_remove_ok').attr('href', '#re_workflow_remove_form_' + values[1])  
    $.fancybox({ 'href': '#re_workflow_remove_confirm' });          
  	return false;  
  });  

  $("#re_workflow_remove_cancel").live('click', function() {
    $.fancybox.close();  
    return false;
  });  

  $('#re_workflow_remove_ok').live('click', function() {
    var form_id = $(this).attr('href');

    $.re_block();
    $.post($(form_id).attr('action'), $(form_id).serialize(), function() { 
      $.fancybox.close();
      $.re_unblock(); 
    }, 'script');    
    return false;
  });

  // PIPELINE DEFAULT
  $('a.re-list-workflow-make-default').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $.re_block();
    $(this).removeClass('re-workflow-make-default');
    $(this).addClass('re-workflow-make-default-off');
    
    $.post($('#re_workflow_default_form_' + values[1]).attr('action'), $('#re_workflow_default_form_' + values[1]).serialize(), null, 'script');    
  	return false;  
  });  
  
  $('a.re-list-workflow-make-default-off').live('click', function() {    
  	return false;  
  });  
    

});


