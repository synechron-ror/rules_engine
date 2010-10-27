re_history_list_get = function(page) {
  var plan_id = $('.re-menu-history-list:first').attr('id').replace('re_menu_process_list_', '')
  
  if (plan_id.length == 0 || plan_id == "0")
    $.get('/re_history?page=' + page, null, null, 'script');
  else
    $.get('/re_plans/' + plan_id + '/history?page=' + page, null, null, 'script');
}  

$(document).ready(function() {	  
  
  re_history_list_get(1);
  
  $('.re-xtra-history-next-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_history_list').hide();
    $('#re_history_list_pending').show();
    
    re_history_list_get(page);
    return false;  
  });  
  
  $('.re-xtra-history-next-disabled').live('click', function() {    
    return false;
  });  

  $('.re-xtra-history-prev-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_history_list').hide();
    $('#re_history_list_pending').show();
    
    re_history_list_get(page);
    return false;  
  });  
  
  $('.re-xtra-history-prev-disabled').live('click', function() {    
    return false;
  });  
});


