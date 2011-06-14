// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$j(document).ready(function(){//on document ready autocomplete
  jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
  });
  // Always send the authenticity_token with ajax
  $j(document).ajaxSend(function(event, request, settings) {
    if ( settings.type == 'post' ) {
      settings.data = (settings.data ? settings.data + "&" : "")
      + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
    }
  });
  

  function split( val ) {
    return val.split( /,\s*/ );
  }
  function extractLast( term ) {
    return split( term ).pop();
  }

  //Helper functions
  
  //Ajaxify links with class="rsj-delete"
  $j('a.ajax-destroy').live('click', function(event) {
    if ( confirm("Are you sure you want to delete this item?") )
      $j.ajax({
          url: this.href,
          type: 'post',
          dataType: 'script',
          data: { '_method': 'delete' },
          success: function() {
            // the item has been deleted
            // might want to remove it from the interface
            // or redirect or reload by setting window.location
          }
      });
      return false;
  });

  $j('input.autocomplete').each(function(){
    var input = $j(this);
    var url = input.attr('autocomplete-url');
    input.autocomplete({source : url });
  }); 

  $j("input.test-if-used").each(function(){
    var input = $j(this);
    var url = input.attr('test-if-used-url');
    input.blur(function() { 
      // $j("#vip_ipaddr").autocomplete("search","nomatchforthis");
      $j.ajax({
            url: $j(this).attr('test-if-used-url') + '?' + $j.param( { 'test_if_used' : input.val() } ),
            success: function(data) {
              $j("#ipaddr_warning").html(data)
            }
      });
    });
  });

  $j('input.autocomplete-with-commas').each(function(){
    var input = $j(this);
    var url = input.attr('autocomplete-url');

    input
      // don't navigate away from the field on tab when selecting an item
      .bind( "keydown", function( event ) {
        if (  event.keyCode === $j.ui.keyCode.TAB && input.data( "autocomplete" ).menu.active ) {
          event.preventDefault();
        }
      })
      .autocomplete({
        source: function(request, response){
                  $j.getJSON(url, {term: extractLast(request.term)}, response);
        },
        focus:  function() {
                  // prevent value inserted on focus
                  return false;
        },
        select: function( event, ui ) {
                  var terms = split( this.value );
                  // remove the current input
                  terms.pop();
                  // add the selected item
                  terms.push( ui.item.value );
                  // add placeholder to get the comma-and-space at the end
                  terms.push( "" );
                  this.value = terms.join( ", " );
                  return false;
        }
                                   
      },{
        matchContains:1,//also match inside of strings when caching
      // mustMatch:1,//allow only values from the list
        selectFirst:1,//select the first item on tab/enter
        removeInitialValue:0//when first applying $.autocomplete
      }); 
  }); 
});
      
