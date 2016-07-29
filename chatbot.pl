#!/usr/bin/env perl

use Mojolicious::Lite;

use lib './lib';
use ChatBot::Simple;

{
	context '';
	pattern 'hi' => 'hello';
	pattern ':something_else' => [ 'foo', 'bar', 'baz' ];
}

{
	get '/' => 'index';

	any '/chat' => sub {
		my ($c) = @_;

		my $chat_log = $c->param('chat_log');
		my $message  = $c->param('message');

		my @chat_log = split(/\|/, $chat_log);

		for my $past_message (@chat_log) {
			ChatBot::Simple::process($past_message);
		}

		my $response = ChatBot::Simple::process($message);

		$chat_log = $chat_log ? "$chat_log|$message" : $message;

		$c->render( json => { 'response' => $response, 'chat_log' => $chat_log });
	};
}

app->start();