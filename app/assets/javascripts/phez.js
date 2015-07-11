var PhezApp = Class.extend({

  init: function(){
    this.logged_in = false;
  },

  reply: function(comment_id) {
    $('#parent_id').val(comment_id);
    $('.loaded-comment-form').hide();
    var form_html = $('#comment-form').html();
    form_html = form_html.replace('inner-comment-form', 'loaded-comment-form');
    $('#comment-' + comment_id + '-actions').after(form_html);
  },

  upvote: function(post_id) {
    if ($('.post-upvote-' + post_id).hasClass('voted')) {
      return
    }
    var href = "/votes/upvote?post_id=" + post_id;
    $.ajax({
      type: "POST",
      url: href,
      success: Phez.onUpvoteSuccess,
      statusCode: {
        400: Phez.onUpvoteError
      },
      dataType: 'json'
    });
  },

  onUpvoteSuccess: function(data, textStatus, jq_xhr) {
    if ($('.post-downvote-' + data.post_id).hasClass('voted')) {
      var increment_by = 2;
    } else {
      var increment_by = 1;
    }
    $('.post-upvote-' + data.post_id).addClass('voted');
    $('.post-downvote-' + data.post_id).removeClass('voted');
    var base_count = parseFloat( $('#vote-count-' + data.post_id).html() );
    console.log(' base count: ' + base_count);
    var new_count = base_count + increment_by;
    console.log(' new count: ' + new_count);
    $('#vote-count-' + data.post_id).html(new_count);
  },

  onUpvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  downvote: function(post_id) {
    if ($('.post-downvote-' + post_id).hasClass('voted')) {
      return
    }
    var href = "/votes/downvote?post_id=" + post_id;
    $.ajax({
      type: "POST",
      url: href,
      success: Phez.onDownvoteSuccess,
      statusCode: {
        400: Phez.onDownvoteError
      },
      dataType: 'json'
    });
  },

  onDownvoteSuccess: function(data, textStatus, jq_xhr) {
    if ($('.post-upvote-' + data.post_id).hasClass('voted')) {
      var decrement_by = 2;
    } else {
      var decrement_by = 1
    }
    $('.post-downvote-' + data.post_id).addClass('voted');
    $('.post-upvote-' + data.post_id).removeClass('voted');
    var base_count = parseFloat( $('#vote-count-' + data.post_id).html() );
    console.log(' base count: ' + base_count);
    var new_count = base_count - decrement_by;
    console.log(' new count: ' + new_count);
    $('#vote-count-' + data.post_id).html(new_count);
  },

  onDownvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  applyClickHandlers: function() {
  }

});
