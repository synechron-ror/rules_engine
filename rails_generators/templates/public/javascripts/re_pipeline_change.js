re_pipeline_action_confirm = function(id, title, action) {
  $('#re_pipeline_action_title').attr('class', 're-pipeline-' + id + ' red');
  $('#re_pipeline_action_title').html(title);
  $('#re_pipeline_action_content_code').html($('#re_pipeline_code').html());
  $('#re_pipeline_action_content_title').html($('#re_pipeline_title').html());

  $('#re_pipeline_action_ok').attr('href', '#re_pipeline_' + id + '_form');
  $('#re_pipeline_action_ok').html("<span>" + action + "</span>")
  
  tb_show("", '#?TB_inline=true&inlineId=re_pipeline_action_confirm&height=160&width=600', false);
}


$(document).ready(function() {	  

  $('a.re-pipeline-action-edit').live('click', function() {    
    var pipeline = $(this).attr('href').replace('#', '');
      
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=800', false);
    block_thickbox();
    $.get('/re_pipelines/' + pipeline + '/edit', null, unblock_thickbox, 'script');
  	return false;  
  });  

  $("#re_pipeline_edit_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_pipeline_edit_update').live('click', function() {
    block_thickbox();    
    $.post($('#re_pipeline_edit_form').attr('action'), $('#re_pipeline_edit_form').serialize(), unblock_thickbox, 'script');    
    return false;
  });

  $('a.re-pipeline-action-activate').live('click', function() {    
    re_pipeline_action_confirm('activate', "Confirm Activate Pipeline", "Activate")
  	return false;  
  });  

  $('a.re-pipeline-action-deactivate').live('click', function() {    
    re_pipeline_action_confirm('deactivate', "Confirm Deactivate Pipeline", "Deactivate")
  	return false;  
  });  

  $('a.re-pipeline-action-revert').live('click', function() {    
    re_pipeline_action_confirm('revert', "Confirm Discard Pipeline Changed", "Discard Changes")
  	return false;  
  });  

  $('a.re-pipeline-action-delete').live('click', function() {    
    re_pipeline_action_confirm('delete', "Confirm Delete <strong>This cannot be undone !!!</strong>", "Delete Pipeline")
  	return false;  
  });  

  $("#re_pipeline_action_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_pipeline_action_ok').live('click', function() {
    var form_id = $(this).attr('href');
    $.post($(form_id).attr('action'), $(form_id).serialize(), unblock_thickbox, 'script');    
    return false;
  });

  // NEW RULE
  $('a.re-rule-class-new').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;

    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=780', false);
    block_thickbox();
    $.get('/re_pipelines/' + values[0] + '/re_rules/new?rule_class_name=' + values[1], null, unblock_thickbox, 'script');
  	return false;  
  });  

  $("#re_rule_new_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_rule_new_insert').live('click', function() {
    block_thickbox();    
    $.post($('#re_rule_new_form').attr('action'), $('#re_rule_new_form').serialize(), unblock_thickbox, 'script');    
    return false;
  });

  // RULE EDIT
  $('a.re-rule-edit').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;

    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=780', false);
    block_thickbox();
    $.get('/re_pipelines/' + values[0] + '/re_rules/' + values[1] + '/edit', null, unblock_thickbox, 'script');
  	return false;  
  });  

  $("#re_rule_edit_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_rule_edit_update').live('click', function() {
    block_thickbox();    
    $.post($('#re_rule_edit_form').attr('action'), $('#re_rule_edit_form').serialize(), unblock_thickbox, 'script');    
    return false;
  });

  // RULE DELETE
  $('a.re-rule-delete').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $('#re_rule_delete_ok').attr('href', '#re_rule_delete_form_' + values[1])  
    tb_show("", '#?TB_inline=true&inlineId=re_rule_delete_confirm&height=160&width=500', false);
  	return false;  
  });  

  $("#re_rule_delete_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_rule_delete_ok').live('click', function() {
    var form_id = $(this).attr('href');
    $.post($(form_id).attr('action'), $(form_id).serialize(), unblock_thickbox, 'script');    
    return false;
  });

  // RULE MOVE
  $('a.re-rule-move-up').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $(this).removeClass('re-rule-move-up');
    $(this).addClass('re-rule-move-up-off');
    
    $.post($('#re_rule_move_up_form_' + values[1]).attr('action'), $('#re_rule_move_up_form_' + values[1]).serialize(), null, 'script');    
  	return false;  
  });  

  $('a.re-rule-move-down').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $(this).removeClass('re-rule-move-down');
    $(this).addClass('re-rule-move-down-off');
    
    $.post($('#re_rule_move_down_form_' + values[1]).attr('action'), $('#re_rule_move_down_form_' + values[1]).serialize(), null, 'script');    
  	return false;  
  });  

  // RULE HELP  
  $('a.re-rule-class-help').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=800', false);
    block_thickbox();
    $.get('/re_pipelines/' + values[0] + '/re_rules/help?rule_class_name=' + values[1], null, unblock_thickbox, 'script');
  	return false;  
  });  

  $("#re_rule_help_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('select#re_rule_class_list').live('change', function() {
    var name = $("select#re_rule_class_list option:selected").val().replace(" ", "_")
    $('.re-rule-class-list').each(function() {
      $(this).slideUp('slow');      
    })
    $('#re_rule_class_name_' + name).slideDown('slow');
    
  });
    
});


