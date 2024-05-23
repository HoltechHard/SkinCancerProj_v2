$(document).ready(function(){ 

    // establish web socket connection
    const socket = io();
    let startTime, endTime, timeExpend;

    // socket take answer from backend and send to frontend
    socket.on('response', function(data){        
        // actions for chatbot answer
        if(data.type == 'chatbot_answer'){            
            endTime = new Date().getTime();
            timeExpend = (endTime - startTime)/(1000 * 60);
            showChatbotAnswer(data.message, timeExpend.toFixed(2));            
        }else{
            console.log('Answer was not processed...')
        }
    });

    // function to send frontend message to server
    function sendMessage(type, message){
        socket.emit('user_question', {type: type, message: message});
    }

    // function to socket send user-question from frontend to the backend
    function chatInteraction(){
        // get the input from textarea
        var question = $('#txtUserQuestion').val().trim();
        // show the question
        showUserQuestion(question);
        // initialize time to proceed answer
        startTime = new Date().getTime();
        // send user-question to server
        sendMessage('user_question', question);
    }

    // function to show user question in chat
    function showUserQuestion(input){
        if(input != ''){
            $.ajax({
                url: '/assistant/user_question',
                type: 'GET',
                success: function(data){
                    // append content to chat container
                    $('#chatContainerMsg').append(data);
                    // set question text to blocknote
                    $('#chatContainer .lbl-user-question .message').last().text(input);
                    // scroll to bottom of chatContainer
                    $('#chatContainer').scrollTop($('#chatContainer')[0].scrollHeight);    
                    // clear the text area
                    $('#txtUserQuestion').val('');    
                }
            });
        }
    }

    // function to show chatbot answer in chat
    function showChatbotAnswer(response, timer){
        if(response == ''){
            response = 'Chatbot cant answer the current question';
        }
    
        $.ajax({
            url: "/assistant/chatbot_answer",
            type: "GET",
            success: function(data){
                console.log('chatbot answer is processing')
                // append content to chat container
                $('#chatContainerMsg').append(data);
                // set chatbot answer to blocknote
                $('#chatContainer .lbl-chatbot-answer .message').last().text(response.answer);
                // set chatbot reference to span
                $('#chatContainer .lbl-chatbot-answer .reference').last().text(response.reference);
                // set chatbot date of answer
                $('#chatContainer .lbl-chatbot-answer h4.date').last().text(response.answer_date);
                // set chatbot time of answer
                $('#chatContainer .lbl-chatbot-answer .month').last().text(response.answer_time);
                // show time expended
                $('#chatContainer .lbl-chatbot-answer .timer').last().text("Processing time: " + timer + " min");
                // scroll to bottom of chatContainer
                $('#chatContainer').scrollTop($('#chatContainer')[0].scrollHeight);    
            }
        }); 
    }

    // jquery process after click ask button
    $('#btnAsk').on('click', function(){
        chatInteraction();
    });

});
