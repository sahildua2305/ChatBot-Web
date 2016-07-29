#!/usr/bin/env perl

use Mojolicious::Lite;

use ChatData;

use lib './lib';
use ChatBot::Simple;

{
	get '/' => 'index';

	any '/chat' => sub {
		my ($c) = @_;

		my $chat_log = $c->param('chat_log') || '';
		my $message  = $c->param('message')  || '';
		chomp $message;

		my @chat_log = split(/\|/, $chat_log);

		context '';
		for my $past_message (@chat_log) {
			app->log->debug($past_message);
			my $r = ChatBot::Simple::process($past_message);
			app->log->debug($r);
		}

		app->log->debug($message);
		my $response = ChatBot::Simple::process($message);
		app->log->debug($response);

		$chat_log = $chat_log ? "$chat_log|$message" : $message;

		$c->render( json => { 'response' => $response, 'chat_log' => $chat_log });
	};
}

app->start();