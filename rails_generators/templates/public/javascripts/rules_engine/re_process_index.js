re_process_list_get = function(page) {
  var plan_id = $('.re-menu-process-list:first').attr('id').replace('re_menu_process_list_', '')
  
  if (plan_id.length == 0 || plan_id == "0")
    $.get('/re_processes?page=' + page, null, null, 'script');
  else
    $.get('/re_plans/' + plan_id + '/re_process?page=' + page, null, null, 'script');
}  

$(document).ready(function() {	  
  
  re_process_list_get(1);
  
  $('.re-xtra-process-next-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_process_list').hide();
    $('#re_process_list_pending').show();
    
    re_process_list_get(page);
    return false;  
  });  
  
  $('.re-xtra-process-next-disabled').live('click', function() {    
    return false;
  });  

  $('.re-xtra-process-prev-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_process_list').hide();
    $('#re_process_list_pending').show();
    
    re_process_list_get(page);
    return false;  
  });  
  
  $('.re-xtra-process-prev-disabled').live('click', function() {    
    return false;
  });  
});


