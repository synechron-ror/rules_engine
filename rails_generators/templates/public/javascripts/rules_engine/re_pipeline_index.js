$(document).ready(function() {	  

  $('a#re_pipeline_activate_all').live('click', function() {    
    $.fancybox({ href: '#re_pipeline_activate_all_confirm'});
  	return false;  
  });  

  $("#re_pipeline_activate_all_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_pipeline_activate_all_ok').live('click', function() {
    $.re_block();
    $.post($('#re_pipeline_activate_all_form').attr('action'), $('#re_pipeline_activate_all_form').serialize(), null, 'script');    
    return false;
  });

  // RULE LIST  
  $('a.re-pipeline-rule-list-toggle').live('click', function() {    
    var id = $(this).attr('href').replace('#', '');
    
    var $div = $(this).find('div:first')
    var $list = $('#re_pipeline_rule_list_' + id)
    if ($div.hasClass('re-pipeline-rule-list-down')) {
      $list.slideUp(150, function() {
        $div.removeClass('re-pipeline-rule-list-down');
        $div.addClass('re-pipeline-rule-list-right');
      });
    } else {
      $list.slideDown(150, function() {
        $div.removeClass('re-pipeline-rule-list-right');
        $div.addClass('re-pipeline-rule-list-down');
      });
    }
  });
  
});


