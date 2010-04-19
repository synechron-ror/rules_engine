
block_fetching_thickbox = function() {
  $('#TB_ajaxContent').block({'message' : 'loading'});
}

unblock_fetching_thickbox = function() {
  $('#TB_ajaxContent').unblock();
}

$(document).ready(function() {	  
  
  $('a.re-pipeline-new').live('click', function() {    
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=800', false);
    block_fetching_thickbox();
    $.get('/re_pipelines/new', null, unblock_fetching_thickbox, 'script');
  	return false;  
  });  


  $("#re_pipeline_new_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_pipeline_new_insert').live('click', function() {
    block_fetching_thickbox();
    
    $.post($('#re_pipeline_new_form').attr('action'), $('#re_pipeline_new_form').serialize(), unblock_fetching_thickbox, 'script');
    
    return false;
  });
});


