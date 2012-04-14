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

$(document).ready(function() {
  $('.categories').masonry({
     columnWidth: 50
  });

  $.get('/api/categories/children.json', function(data) {
    data = $.map(data, function(n) { return n.name + " [" + n.parent + "]" });

    $('.typeahead').typeahead({
      source: function (typeahead, query) {
        return data;
      },

      onselect: function (obj) {
        alert('Selected '+obj)
      }
    });
  });

});