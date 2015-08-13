$(document).ready(function() {
  $("#loader").hide();
  $("#success").hide();
  $('.button-field').prop('disabled', true);

  var tweet_array = [];


  $("#tweet_textarea").keyup(function(){

    if ($("#tweet_textarea").val().match(/\S/)){

      $('.button-field').prop('disabled', false);
    }else{
      $('.button-field').prop('disabled', true);

    }



  });

  setInterval(function () {

    for (var i = 0; i < tweet_array.length; i++){

     if (tweet_array[i].completed == "false"){

        $.ajax({
          type: "post",
          async: false,
          url: "/status/"+tweet_array[i].job_id,

          success: function(return_value){
            console.log("result return from status inquiry : "+ return_value);
            if (return_value == "true" ){
              console.log("value of i is "+i );

              tweet_array[i].completed = "true";
              $("#queue_tweets").append("<b> Status " +tweet_array[i].status + " posted successfully!!! </b><br>");
              tweet_array.shift();

            }
          },

          fail: function(e){
            console.log("ERROR - "+e);
          }
        });

     }

    }


  }, 2000);



  $("#tweet_post_form").submit(function(e){
    e.preventDefault();

    $("#loader").show();
    input = $(this).serialize()

    var tweet = new Object();
    tweet["status"] = $("#tweet_textarea").val();
    tweet["completed"] = "false";


    $.ajax({

       type: $(this).attr('method'),
        url: $(this).attr('action'),
        data: input,

        success: function(return_value){
          $("#loader").hide();
          $("#success").show();
          tweet["job_id"] = return_value;
          tweet_array.push(tweet);
          console.log("ajax called success with counter " + return_value);

          $("#success").show();
          $("#success").fadeOut(1000);

        },
        fail: function(e){
          $loading.hide();
          console.log(e);
        }
    });



  });

});
