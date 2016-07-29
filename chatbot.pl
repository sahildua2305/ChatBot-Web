#!/usr/bin/env perl

use Mojolicious::Lite;

use lib './lib';
use ChatBot::Simple;

{
    context '';
    pattern ['hi', 'hello']  => sub { context 'name' } => "hi! what's your name?";
}

{
    context 'name';
    pattern "my name is :name" => sub { context 'how_are_you' } => "Hello, :name! How are you?";
}

{
    context 'how_are_you';

    pattern 'fine'            => "that's great, :name!";
    pattern ':something_else' => 'why do you say that?';
}

{
    context 'global';

    transform 'goodbye', 'bye-bye', 'sayonara' => 'bye';
    pattern 'bye' => 'bye!';
}

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