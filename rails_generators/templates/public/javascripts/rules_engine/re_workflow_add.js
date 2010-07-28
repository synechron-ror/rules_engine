re_plan_workflow_add_update = function() {
  $('a.re-menu-workflow-add-link').each(function() {
    var workflow_id = $(this).attr('href').replace('#', '')
    
    if ($('#re_workflow_remove_form_' + workflow_id).length > 0)
    {
      $(this).removeClass('re-menu-workflow-add-link');
      $(this).addClass('re-menu-workflow-add-link-off');
    }
  })

  $('a.re-menu-workflow-add-link-off').each(function() {
    var workflow_id = $(this).attr('href').replace('#', '')
    
    if ($('#re_workflow_remove_form_' + workflow_id).length == 0)
    {
      $(this).removeClass('re-menu-workflow-add-link-off');
      $(this).addClass('re-menu-workflow-add-link');
    }
  })
}    
      
$(document).ready(function() {	  
  // NEW WORKFLOW
  $('a#re_workflow_new').live('click', function() {    
    var plan_id = $(this).attr('href').replace('#', '');  
    
    if (plan_id == "0")
    {
      $.re_error_message('Plan Required')
      return false;
    }
    
    $.re_block();
    $.get('/re_plans/' + plan_id + '/workflows/new', null, null, 'script');
        
  	return false;  
  });  

  $("#re_workflow_new_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_workflow_new_insert').live('click', function() {
    $.re_block();    
    $.post($('#re_workflow_new_form').attr('action'), $('#re_workflow_new_form').serialize(), null, 'script');
    
    return false;
  });

  // WORKFLOW ADD
  $('a.re-menu-workflow-add-link').live('click', function() {    
    var workflow_id = $(this).attr('href').replace('#', '').split('|');
    var plan_id = $('.re-menu-workflow-add:first').attr('id').replace('re_menu_workflow_add_', '')

    if (plan_id == "0") {
      $.re_error_message('Plan Required')
      return false;
    }
    
    $.re_block();
    $(this).removeClass('re-workflow-add');
    $(this).addClass('re-workflow-add-off');
    
    $.post('/re_plans/' + plan_id + '/workflows/' + workflow_id + '/add', $('#re_workflow_add_form_' + workflow_id).serialize(), null, 'script');
  	return false;  
  });  

  $('a.re-menu-workflow-add-link-off').live('click', function() {    
  	return false;  
  });  

  // REMOVE WORKFLOW
  $('a.re-list-workflow-remove').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
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
    $.post($(form_id).attr('action'), $(form_id).serialize(), null, 'script');    
    return false;
  });

  // WORKFLOW DEFAULT
  $('a.re-list-workflow-make-default').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
    $.re_block();
    $(this).removeClass('re-workflow-make-default');
    $(this).addClass('re-workflow-make-default-off');
    
    $.post($('#re_workflow_default_form_' + values[1]).attr('action'), $('#re_workflow_default_form_' + values[1]).serialize(), null, 'script');    
  	return false;  
  });  
  
  $('a.re-list-workflow-make-default-off').live('click', function() {    
  	return false;  
  });  
   
 // GET THE WORKFLOWS
 $.get('/re_workflows/add', null, null, 'script');
 
});