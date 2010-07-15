re_get_publication_show = function(page) {
  var id = $('.re-menu-publication-show:first').attr('id').replace('re_menu_publication_show_', '')
  $.get('/re_publications/' + id + '?page=' + page, null, null, 'script');
}


$(document).ready(function() {	  
  
  re_get_publication_show(1);
  
  $('.re-xtra-publication-next-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_publication_show').hide();
    $('#re_publication_show_pending').show();
    
    re_get_publication_show(page);
    return false;  
  });  
  $('.re-xtra-publication-next-disabled').live('click', function() {    
    return false;
  });  

  $('.re-xtra-publication-prev-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_publication_show').hide();
    $('#re_publication_show_pending').show();
    
    re_get_publication_show(page);
    return false;  
  });  
  $('.re-xtra-publication-prev-disabled').live('click', function() {    
    return false;
  });  

});


