// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require masonry
//= require typeahead
//= require_tree .

var city_typeahead_selected_id = null;

$(document).ready(function() {

  $('.categories').masonry({
     columnWidth: 50
  });

  $.get('/api/categories/children.json', function(data) {
    loaded_data = data;
    data = $.map(data, function(n) { return {value: n.name + " [" + n.parent + "]", id: n.id}  });

    $('.typeahead').typeahead({
      source: function (typeahead, query) {
        return data;
      },

      onselect: function (obj) {
        $("#template_content").load('/ads/new?cid='+obj.id);
      }
    });
  });

  $('.city-typeahead').live('focus', function() {
    var _this = $(this);

    $(this).typeahead({
      source: function(typeahead, query) {
        if(query.length >= 1) {
          return $.get('/api/cities/search.json', { city: query }, function(data) {
            d = $.map(data, function(n) { return { value: n.name + ', ' + n.state.toLowerCase(), id: n.id } });
            return typeahead.process(d);
          });
        }
      },

      onselect: function(obj) {
        city_typeahead_selected_id = obj.id;
      }
    });
  });

});