$( document ).ready(function() {

// publiczne/niepubliczne

    $("a.publ").click(function(e){
      e.preventDefault();
      url = $(this).attr("href");
      that = this
      
      $.ajax({
        type: "POST",
        url: url,
        data: {},
        success: function(data, textStatus, jqXHR) {
          console.log(data)
          if (data.publiczny == 'tak') {
            publiczny = 'niepubliczny'
            nazwa_linka = "Uczyn niepublicznym"
          } else {
            publiczny = 'publiczny'
            nazwa_linka = "Uczyn publicznym"
          }
          $(that).attr("href", '/' + data.id + '/post/' + publiczny);
          $(that).html(nazwa_linka)
        },
        dataType: 'json'
      });
    });

// usuwanie

    $("a.del").click(function(e){
      e.preventDefault();
      url = $(this).attr("href");  
      that = this

      $.ajax({
        type: "GET", 
        url: url,
        data: {},
        success: function(data,textStatus, jqXHR){
          $(that).closest("li").remove()
        },
        dataType: 'json'
      });
    });

// komentarze

    $("form button.kom").click(function(e){
      e.preventDefault();
      url = $(this).parent('form').attr("action");
      // that = this
      $.ajax({
        type: "POST",
        url: url,
        data: {
          user: $('form #user').val(),
          komentarz: $('form #kom').val(),
          post_id: $('form #post_id').val()
        },
        success: function(data,textStatus,jqXHR){
          $('#koment').append(data)
        },
        error: function ( jqXHR, textStatus, errorThrown) {
          // console.log(jqXHR, textStatus, errorThrown)
          // $('.errors').html(errorThrown)
        },
        dataType: 'html'
      });
    });
});

