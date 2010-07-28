re_workflow_action_confirm = function(id, title, action) {
  $('#re_workflow_action_title').html(title);
  $('#re_workflow_action_content_code').html($('#re_workflow_code').html());
  $('#re_workflow_action_content_title').html($('#re_workflow_title').html());

  $('#re_workflow_action_ok').attr('href', '#re_workflow_' + id + '_form');
  $('#re_workflow_action_ok').html("<span>" + action + "</span>")
  
  $.fancybox({ href: '#re_workflow_action_confirm'});
}

$(document).ready(function() {	  

  $('a#re_workflow_copy').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
    $.re_block();
    if (parseInt(values[0]) == 0)
      $.get('/re_workflows/' + values[1] + '/copy', null, null, 'script');
    else
      $.get('/re_plans/' + values[0] + '/workflows/' + values[1] + '/copy', null, null, 'script');
  	return false;  
  });  

  $("#re_workflow_copy_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_workflow_copy_duplicate').live('click', function() {
    $.re_block();
    $.post($('#re_workflow_copy_form').attr('action'), $('#re_workflow_copy_form').serialize(), null, 'script');    
    return false;
  });

  $('a#re_workflow_edit').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
    $.re_block();
    if (parseInt(values[0]) == 0)
      $.get('/re_workflows/' + values[1] + '/edit', null, null, 'script');
    else
      $.get('/re_plans/' + values[0] + '/workflows/' + values[1] + '/edit', null, null, 'script');
  	return false;  
  });  

  $("#re_workflow_edit_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_workflow_edit_update').live('click', function() {
    $.re_block();
    $.post($('#re_workflow_edit_form').attr('action'), $('#re_workflow_edit_form').serialize(), null, 'script');    
    return false;
  });

  $('a#re_workflow_delete').live('click', function() {    
    re_workflow_action_confirm('delete', "Delete the Workflow", "Delete Workflow")
  	return false;  
  });  

  $("#re_workflow_action_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_workflow_action_ok').live('click', function() {
    var form_id = $(this).attr('href');

    $.re_block();
    $.post($(form_id).attr('action'), $(form_id).serialize(), null, 'script');    
    return false;
  });

  // NEW RULE
  $('a.re-menu-rule-new').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');

    $.re_block();
    if (parseInt(values[0]) == 0)
      $.get('/re_workflows/' + values[1] + '/rules/new?rule_class_name=' + values[2], null, null, 'script');
    else
      $.get('/re_plans/' + values[0] + '/workflows/' + values[1] + '/rules/new?rule_class_name=' + values[2], null, null, 'script');
    
  	return false;  
  });  

  $("#re_rule_new_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_rule_new_insert').live('click', function() {
    $.re_block();
    $.post($('#re_rule_new_form').attr('action'), $('#re_rule_new_form').serialize(), null, 'script');    
    return false;
  });

  // RULE HELP  
  $('a.re-menu-rule-help').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    
    $.re_block();
    if (parseInt(values[0]) == 0)
      $.get('/re_workflows/' + values[1] + '/rules/help?rule_class_name=' + values[2], null, null, 'script');
    else
      $.get('/re_plans/' + values[0] + '/workflows/' + values[1] + '/rules/help?rule_class_name=' + values[2], null, null, 'script');
    
    return false;  
  });  

  $("#re_rule_help_cancel").live('click', function() {
    $.fancybox.close();    
    return false;
  });  

  // RULE EDIT
  $('a.re-list-rule-edit').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');

    $.re_block();
    if (parseInt(values[0]) == 0)
      $.get('/re_workflows/' + values[1] + '/rules/' + values[2] + '/edit', null, null, 'script');
    else
      $.get('/re_plans/' + values[0] + '/workflows/' + values[1] + '/rules/' + values[2] + '/edit', null, null, 'script');

  	return false;  
  });  

  $("#re_rule_edit_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_rule_edit_update').live('click', function() {
    $.re_block();
    $.post($('#re_rule_edit_form').attr('action'), $('#re_rule_edit_form').serialize(), null, 'script');    
    return false;
  });

  // RULE DELETE
  $('a.re-list-rule-delete').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
    $('#re_rule_delete_ok').attr('href', '#re_rule_delete_form_' + values[2])  
    $.fancybox({ 'href': '#re_rule_delete_confirm' });          
  	return false;  
  });  

  $("#re_rule_delete_cancel").live('click', function() {
    $.fancybox.close();  
    return false;
  });  

  $('#re_rule_delete_ok').live('click', function() {
    var form_id = $(this).attr('href');

    $.re_block();
    $.post($(form_id).attr('action'), $(form_id).serialize(), null, 'script');    
    return false;
  });

  // RULE MOVE
  $('a.re-list-rule-move-up').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
    $.re_block();
    $(this).removeClass('re-list-rule-move-up');
    $(this).addClass('re-list-rule-move-up-off');
    
    $.post($('#re_rule_move_up_form_' + values[2]).attr('action'), $('#re_rule_move_up_form_' + values[2]).serialize(), null, 'script');
  	return false;  
  });  
  
  $('a.re-list-rule-move-up-off').live('click', function() {return false;});  
  
  $('a.re-list-rule-move-down').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
      
    $.re_block();
    $(this).removeClass('re-list-rule-move-down');
    $(this).addClass('re-list-rule-move-down-off');
    
    $.post($('#re_rule_move_down_form_' + values[2]).attr('action'), $('#re_rule_move_down_form_' + values[2]).serialize(), null, 'script');    
  	return false;  
  });  
  
  $('a.re-list-rule-move-down-off').live('click', function() {return false;});  

  // RULE GROUPS  
  $('select#re_rule_class_list').live('change', function() {
    var name = $("select#re_rule_class_list option:selected").val().replace(" ", "_")
    $('.re-xtra-rule-list').each(function() {
      $(this).slideUp('slow');      
    })
    $('#re_rule_class_name_' + name).slideDown('slow');
    
    return false;
  });
    
});


