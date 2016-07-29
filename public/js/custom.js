var chat_log;

$(document).ready(function () {
	$('#sendMessage').click(function () {
		console.log("send message");

		var html_message = "<div class='me'>" + $('#message').val() + "</div>";
		var message = $('#message').val();

		var new_chat_content = ($('#chat_messages').html() != "") ? $('#chat_messages').html() + html_message : html_message;

		$('#chat_messages').html(new_chat_content);
		$('#message').val('');

		// send ajax request to /chat endpoint to receive the response using ChatBot::Simple
		$.ajax({
			url: '/chat',
			data: {
				message: message,
				chat_log: chat_log
			},
			method: 'POST',
			success: function (json_response) {
				chat_log = json_response.chat_log;
				console.log(json_response);
				var prev = $('#chat_messages').html();
				$('#chat_messages').html(prev + "<div class='bot'>" + json_response.response + "</div>");
			},
			fail: function (err) {
				console.log(err);
			}
		});
		
		// focus on the input field
		// $('#message').focus();
	});
});
