$(document).ready(function() {	  
  
  $('a.re-pipeline-new').live('click', function() {    
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=300&width=800', false);
    block_thickbox();
    $.get('/re_pipelines/new', null, unblock_thickbox, 'script');
  	return false;  
  });  


  $("#re_pipeline_new_cancel").live('click', function() {
    self.parent.tb_remove();
    return false;
  });  

  $('#re_pipeline_new_insert').live('click', function() {
    block_thickbox();
    
    $.post($('#re_pipeline_new_form').attr('action'), $('#re_pipeline_new_form').serialize(), unblock_thickbox, 'script');
    
    return false;
  });
});


