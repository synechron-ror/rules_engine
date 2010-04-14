block_fetching_thickbox = function() {
  $('#TB_ajaxContent').block({'message' : 'loading'});
}

unblock_fetching_thickbox = function() {
  $('#TB_ajaxContent').unblock();
}

get_job_list = function(page) {
  $.get('/re_jobs?page=' + page, null, null, 'script');
}


$(document).ready(function() {	  
  
  $('a.pipeline-job-detail').live('click', function() {    
    var job = $(this).attr('href').replace('#', '');
      
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=450&width=800', false);
    block_fetching_thickbox();
    $.get('/re_jobs/' + job, null, unblock_fetching_thickbox, 'script');
    
  	return false;  
  });  


  $('a.job-page-prev-enabled').live('click', function() {
    var page = $(this).attr('href').replace('#', ''); 
    
    $('#job_list').hide();
    $('#job_list_pending').show();
    get_job_list(page);  
    
  	return false;  
  });  

  $('a.job-page-prev-disabled').live('click', function() {
    return false;
  });
  

  $('a.job-page-next-enabled').live('click', function() {
    var page = $(this).attr('href').replace('#', ''); 
    
    $('#job_list').hide();
    $('#job_list_pending').show();
    get_job_list(page);  
    
  	return false;  
  });  

  $('a.job-page-next-disabled').live('click', function() {
    return false;
  });
  
  
});


