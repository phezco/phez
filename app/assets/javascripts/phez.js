var PhezApp = Class.extend({

  init: function(){
    this.logged_in = false;
  },

  pickSubphez: function(path) {
    $('#subphez_path').val(path);
  },

  suggestTitle: function() {
    var url = $('#post_url').val();
    if (url == '') {
      alert('Please enter a URL to suggest a title.');
      return
    }
    var href = '/posts/suggest_title?url=' + encodeURIComponent(url);
    $.ajax({
      type: "GET",
      url: href,
      success: Phez.handleSuggestedTitle,
      dataType: 'json'
    });
  },

  handleSuggestedTitle: function(data, textStatus, jq_xhr) {
    if (data.suggest == true) {
      $('#post_title').val(data.title);
    } else {
      $('#post_title').after('<br/>There was a problem getting a suggested title from the URL provided.');
    }
  },

  reply: function(comment_id) {
    $('#parent_id').val(comment_id);
    $('.loaded-comment-form').hide();
    var form_html = $('#comment-form').html();
    form_html = form_html.replace('inner-comment-form', 'loaded-comment-form');
    $('#comment-' + comment_id + '-actions').after(form_html);
  },

  edit: function(comment_id) {
    $('div#comment-' + comment_id).load('/comments/' + comment_id + '/edit');
  },

  cancel: function(comment_id) {
    $('div#comment-' + comment_id).load('/comments/' + comment_id);
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
    var new_count = base_count + increment_by;
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
    var new_count = base_count - decrement_by;
    $('#vote-count-' + data.post_id).html(new_count);
  },

  onDownvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  upvoteComment: function(comment_id) {
    if ($('.comment-upvote-' + comment_id).hasClass('voted')) {
      return
    }
    var href = "/comment_votes/upvote?comment_id=" + comment_id;
    $.ajax({
      type: "POST",
      url: href,
      success: Phez.onCommentUpvoteSuccess,
      statusCode: {
        400: Phez.onCommentUpvoteError
      },
      dataType: 'json'
    });
  },

  onCommentUpvoteSuccess: function(data, textStatus, jq_xhr) {
    console.log(data);
    if (data.success == true) {
      if ($('.comment-downvote-' + data.comment_id).hasClass('voted')) {
        var increment_by = 2;
      } else {
        var increment_by = 1;
      }
      $('.comment-upvote-' + data.comment_id).addClass('voted');
      $('.comment-downvote-' + data.comment_id).removeClass('voted');
      var base_count = parseFloat( $('#comment-vote-count-' + data.comment_id).html() );
      var new_count = base_count + increment_by;
      $('#comment-vote-count-' + data.comment_id).html(new_count);
    } else {
      alert('There was a problem saving your vote.');
    }
  },

  onCommentUpvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  downvoteComment: function(comment_id) {
    if ($('.comment-downvote-' + comment_id).hasClass('voted')) {
      return
    }
    var href = "/comment_votes/downvote?comment_id=" + comment_id;
    $.ajax({
      type: "POST",
      url: href,
      success: Phez.onCommentDownvoteSuccess,
      statusCode: {
        400: Phez.onCommentDownvoteError
      },
      dataType: 'json'
    });
  },

  onCommentDownvoteSuccess: function(data, textStatus, jq_xhr) {
    console.log(data);
    if (data.success == true) {
      if ($('.comment-upvote-' + data.comment_id).hasClass('voted')) {
        var decrement_by = 2;
      } else {
        var decrement_by = 1
      }
      $('.comment-downvote-' + data.comment_id).addClass('voted');
      $('.comment-upvote-' + data.comment_id).removeClass('voted');
      var base_count = parseFloat( $('#comment-vote-count-' + data.comment_id).html() );
      var new_count = base_count - decrement_by;
      $('#comment-vote-count-' + data.comment_id).html(new_count);
    } else {
      alert('There was a problem saving your vote.');
    }
  },

  onCommentDownvoteError: function(jq_xhr, textStatus, errorThrown) {
    alert('There was a problem saving your vote. Please try again later.');
  },

  applyClickHandlers: function() {

    $("#subphez_path").autocomplete({
      source: '/subphezes/autocomplete.json',
    });

  }

});
