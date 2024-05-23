$(document).ready(function(){
    
    // submission of model
    $('#frmModel').on('submit', function(e){
        e.preventDefault();

        // take all data from html form
        var formData = new FormData($(this)[0]);

        $.ajax({
            url: '/reports/experiments',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(res){                
                console.log('Model is inserted!');
            },
            error: function(err){
                console.log('Error: ' + err);
            }
        });
    });

    // submission of experiment
    $('#frmExperiment').on('submit', function(e){
        e.preventDefault();

        // take all data from html form
        var formData = new FormData($(this)[0]);

        $.ajax({
            url: '/reports/experiments',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(res){                
                console.log('Experiment is inserted!');
            },
            error: function(err){
                console.log('Error: ' + err);
            }
        });
    });

    // clear the register models form
    $('#btnClearModel').on('click', function(){
        $('#form_type').val('');
        $('#txtModelName').val('');
        $('#txtModelType').val('');
    });

    // clear the register experiments form
    $('#btnClearExp').on('click', function(){
        $('#form_type').val('');
        $('#txtExpDescription').val('');
        $('#file').val('');
        $('#cboModel').prop('selectedIndex', 0);
    })

});