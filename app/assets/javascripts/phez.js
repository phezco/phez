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
    $('.post-upvote-' + data.post_id).addClass('voted');
    $('.post-downvote-' + data.post_id).removeClass('voted');
  },

  onUpvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  downvote: function(post_id) {
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
    $('.post-downvote-' + data.post_id).addClass('voted');
    $('.post-upvote-' + data.post_id).removeClass('voted');
  },

  onDownvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  applyClickHandlers: function() {
  }

});
