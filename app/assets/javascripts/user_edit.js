$(function() {
  $('#avatar-image-control').click(function(){
    $('#user_avatar').click();
  });

  $("#user_avatar").change(function(){
    readURL(this);
  });

  function readURL(input) {

    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        console.log($('#avatar-image-control').css('background-image'));
        $('#avatar-image-control').css('background-image', 'url(' + e.target.result + ')');
        console.log($('#avatar-image-control').css('background-image'));
      }

      reader.readAsDataURL(input.files[0]);
    }
  }
});