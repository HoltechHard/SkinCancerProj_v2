$(document).ready(function() {

    // hidden components
    $('#alertIngest').hide();
    $('#progress').hide();

    // Initialize Dropzone to store files
    Dropzone.autoDiscover = false;

    var myDropzone = new Dropzone("form.dropzone", {
      url: "/assistant/private_data",
      method: "post",
      paramName: "file",
      parallelUploads: 10,
      maxFiles: 10,
      acceptedFiles: ".pdf",
      init: function() {
        this.on("addedfile", function(file) {
          console.log("Added file: " + file.name);
        });
        this.on("removedfile", function(file) {
          console.log("Removed file: " + file.name);
        });
        this.on("success", function(file, response) {
          console.log("File uploaded successfully: " + file.name);
        });
        this.on("error", function(file, errorMessage) {
          console.log("Error uploading file: " + file.name + " - " + errorMessage);
        });
      }
    });

    // ingest files
    $('#btnIngest').on('click', function(){

        // show the progress bar
        $('#progress').show();

        $.ajax({
          type: 'POST',
          url: '/assistant/ingest',          
          success: function(response) {
            console.log(response.message);
            // show that ingest process is finished
            $('#alertIngest').show();
            $('#progress').hide();
          },
          error: function(xhr, status, error) {
            console.log('Error executing ingest script:', error);
          } 
        });
    });

  });