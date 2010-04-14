block_fetching_thickbox = function() {
  $('#TB_ajaxContent').block({'message' : 'loading'});
}

unblock_fetching_thickbox = function() {
  $('#TB_ajaxContent').unblock();
}

pipeline_action_confirm = function(id, title, action) {
  $('#pipeline_action_title').attr('class', 'pipeline-' + id + ' red');
  $('#pipeline_action_title').html(title);
  $('#pipeline_action_content_code').html($('#pipeline_code').html());
  $('#pipeline_action_content_title').html($('#pipeline_title').html());

  $('#pipeline_action_ok').attr('href', '#pipeline_' + id + '_form');
  $('#pipeline_action_ok').html("<span>" + action + "</span>")
  
  tb_show("", '#?TB_inline=true&inlineId=pipeline_action_confirm&height=160&width=600', false);
}


$(document).ready(function() {	  

  $('a.pipeline-action-edit').live('click', function() {    
    var pipeline = $(this).attr('href').replace('#', '');
      
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=800', false);
    block_fetching_thickbox();
    $.get('/re_pipelines/' + pipeline + '/edit', null, unblock_fetching_thickbox, 'script');
  	return false;  
  });  

  $("#pipeline_edit_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#pipeline_edit_update').live('click', function() {
    block_fetching_thickbox();    
    $.post($('#pipeline_edit_form').attr('action'), $('#pipeline_edit_form').serialize(), unblock_fetching_thickbox, 'script');    
    return false;
  });

  $('a.pipeline-action-activate').live('click', function() {    
    pipeline_action_confirm('activate', "Confirm Activate Pipeline", "Activate")
  	return false;  
  });  

  $('a.pipeline-action-deactivate').live('click', function() {    
    pipeline_action_confirm('deactivate', "Confirm Deactivate Pipeline", "Deactivate")
  	return false;  
  });  

  $('a.pipeline-action-revert').live('click', function() {    
    pipeline_action_confirm('revert', "Confirm Discard Pipeline Changed", "Discard Changes")
  	return false;  
  });  

  $('a.pipeline-action-delete').live('click', function() {    
    pipeline_action_confirm('delete', "Confirm Delete <strong>This cannot be undone !!!</strong>", "Delete Pipeline")
  	return false;  
  });  

  $("#pipeline_action_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#pipeline_action_ok').live('click', function() {
    var form_id = $(this).attr('href');
    $.post($(form_id).attr('action'), $(form_id).serialize(), unblock_fetching_thickbox, 'script');    
    return false;
  });

  // NEW RULE
  $('a.rule-class-new').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;

    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=780', false);
    block_fetching_thickbox();
    $.get('/re_pipelines/' + values[0] + '/re_rules/new?rule_class=' + values[1], null, unblock_fetching_thickbox, 'script');
  	return false;  
  });  

  $("#rule_new_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#rule_new_insert').live('click', function() {
    block_fetching_thickbox();    
    $.post($('#rule_new_form').attr('action'), $('#rule_new_form').serialize(), unblock_fetching_thickbox, 'script');    
    return false;
  });

  // RULE EDIT
  $('a.rule-edit').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;

    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=780', false);
    block_fetching_thickbox();
    $.get('/re_pipelines/' + values[0] + '/re_rules/' + values[1] + '/edit', null, unblock_fetching_thickbox, 'script');
  	return false;  
  });  

  $("#rule_edit_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#rule_edit_update').live('click', function() {
    block_fetching_thickbox();    
    $.post($('#rule_edit_form').attr('action'), $('#rule_edit_form').serialize(), unblock_fetching_thickbox, 'script');    
    return false;
  });

  // RULE DELETE
  $('a.rule-delete').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $('#rule_delete_ok').attr('href', '#rule_delete_form_' + values[1])  
    tb_show("", '#?TB_inline=true&inlineId=rule_delete_confirm&height=160&width=500', false);
  	return false;  
  });  

  $("#rule_delete_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#rule_delete_ok').live('click', function() {
    var form_id = $(this).attr('href');
    $.post($(form_id).attr('action'), $(form_id).serialize(), unblock_fetching_thickbox, 'script');    
    return false;
  });

  // RULE MOVE
  $('a.rule-move-up').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $(this).removeClass('rule-move-up');
    $(this).addClass('rule-move-up-off');
    
    $.post($('#rule_move_up_form_' + values[1]).attr('action'), $('#rule_move_up_form_' + values[1]).serialize(), null, 'script');    
  	return false;  
  });  

  $('a.rule-move-down').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    $(this).removeClass('rule-move-down');
    $(this).addClass('rule-move-down-off');
    
    $.post($('#rule_move_down_form_' + values[1]).attr('action'), $('#rule_move_down_form_' + values[1]).serialize(), null, 'script');    
  	return false;  
  });  

  // RULE HELP  
  $('a.rule-class-help').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    if (values.length != 2)
      return false;
      
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=800', false);
    block_fetching_thickbox();
    $.get('/re_pipelines/' + values[0] + '/re_rules/help?rule_class=' + values[1], null, unblock_fetching_thickbox, 'script');
  	return false;  
  });  

  $("#rule_help_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  


  // RULE LIST  
  $('a.rule-class-list-toggle').live('click', function() {    
    var $h5 = $(this).find('h5')
    var $list = $(this).next('.rule-class-list')
    if ($h5.hasClass('rule-class-list-down')) {
      $list.slideUp(150, function() {
        $h5.removeClass('rule-class-list-down');
        $h5.addClass('rule-class-list-right');
      });
    } else {
      $list.slideDown(150, function() {
        $h5.removeClass('rule-class-list-right');
        $h5.addClass('rule-class-list-down');
      });
    }
  });
  
});


