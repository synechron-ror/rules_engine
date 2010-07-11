$(document).ready(function() {	  

  $('a#re_plan_publish_all').live('click', function() {    
    $.fancybox({ href: '#re_plan_publish_all_confirm'});
  	return false;  
  });  

  $("#re_plan_publish_all_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_plan_publish_all_ok').live('click', function() {
    $.re_block();
    $.post($('#re_plan_publish_all_form').attr('action'), $('#re_plan_publish_all_form').serialize(), null, 'script');    
    return false;
  });
});


