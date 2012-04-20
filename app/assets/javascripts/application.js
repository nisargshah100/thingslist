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
//= require tinymce-jquery
//= require_tree .

var base_url = "http://localhost:3000"

// Serializes form to json
$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

var city_typeahead_selected_id = null;

$(document).ready(function() {

  $("a[href^='http:']:not([href*='" + window.location.host + "'])").each(function() {               
    $(this).live('click', function(e) {
      e.preventDefault();
      if (location.href.indexOf(base_url+"/redirect/") == 0) {
        location.href = $(this).attr('href');
      }
      else {
        location.href = '/redirect/?url='+$(this).attr('href');
      }
    });
  });

  // Organizes categories
  $('.categories').masonry({
     columnWidth: 50
  });

  // submits request for categories
  $.get('/api/categories/children.json', function(data) {
    loaded_data = data;
    data = $.map(data, function(n) { return {value: n.name + " [" + n.parent + "]", id: n.id}  });

    $('.categories-typeahead').typeahead({
      source: function (typeahead, query) {
        return data;
      },

      onselect: function (obj) {
        $("#template_content").load('/ads/new?cid='+obj.id);
      }
    });
  });

  // submits requests for cities
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

  // submits the new ad form
  $('#new_ad').live('submit', function(e) {
    e.preventDefault();

    var values = $(this).serializeObject();
    values["ad[city]"] = city_typeahead_selected_id;

    $.post('/api/ads.json', values, function(data) {
      if(data == true) {
        location.href = '/';
      }
      else {
        $("#error").html(data.join('<br />')).show('slow');
      }
    });
  });
});