package ChatData;

use v5.18;
use strict;
use lib './lib';
use ChatBot::Simple;

my @NO        = ("no", "nope", "not really");
my @YES       = ("yes" , "yeah" , "sure" , "uh huh" , "yea" , "yep");
my @DONT_KNOW = ("don't know" , "don't think so" , "can't tell");


{
    context '';

    pattern ['francesco' , 'Francesco' , 'fra' , 'foresti' ]
        => sub { context 'francesco'}
        => "wait i think i've heard of you somewhere... the one they call the smooth one?";

    pattern ["i'm :name", 'my name is :name', 'call me :name', ':name']
        => sub { context 'do_i_know_you'}
        => "i don't think we've met before, :name? do i seem like anyone you know?";
}

{
    context 'do_i_know_you';

    pattern [ @YES ]
        => sub { context 'guesses' }
        => "oh yeah? well i'm based on someone from booking so that makes sense. got any guesses? :)";

    pattern [@NO , "can't"]
        => sub { context 'music_or_fashion' }
        => "ok... well, i've got a lot of free time on my hands. \nso let's get to know each other. music or fashion?";

    pattern ":something_else"
        => "I never understand why people try to get creative with yes or no questions :) \nSo, do I seem like anyone you know?";

    }
{
    context 'music_or_fashion';

    pattern 'fashion'
        => sub { context 'skirts_or_pants' }
        => 'my favourite thing to talk about. the age-old question: skirts or pants?';

    pattern 'music'
        => "well actually... i don't really listen to music, so just pick fashion";

    pattern ':something_else'
        => "don't be difficult :name. 'music' or 'fashion'!";
}

{
    context 'skirts_or_pants';

    pattern ['skirts' , 'skirt' , 'Skirt' , 'Skirts' ]
        => "the loveliest skirt is an a-line with pleats, don't you think?";
    pattern ['pants' , 'Pants' , 'pant' , 'Pant' ]
        => 'well... ok, :name. i like skirts more but disco pants are cool too, right?';

    pattern [ @YES ]
        => sub { context 'where_you_from' }
        => "i had the feeling we'd get along. \n:name is an interesting name... where are you from anyway?";
    pattern [ @NO, @DONT_KNOW ]
        => sub { context 'where_you_from' }
        => "well... seems like we aren't going to agree, so let's drop it. \n:name is an interesting name... where are you from anyway?";

    pattern ":something_else"
        => ["no, not :something_else... skirts or pants, please" , "hey we'll get to :something_else in a minute. for now, skirts or pants?" , "yeah :something_else is interesting too, but let's stay focused... skirts or pants?" ]
}

{   context 'where_you_from';


    pattern ['from :where_theyre_from', ':where_theyre_from']
        => sub { context 'do_you_still_live_there' }
        => "well i don't get out much :name.\n so i've never been to :where_theyre_from. do you still live there?";
}

{
    context 'do_you_still_live_there';

    pattern [ @YES ]
        => sub { context 'say_something_random' }
        => "so :where_theyre_from is either pretty nice, or you're too lazy to move. \nanyway :name, surprise me – say something random";

    pattern [ @NO ]
        => sub {context 'living_diff_place'}
        => "so :name, you left behind lovely :where_theyre_from to settle in...?";

    pattern ':something_else' => 'say what? do you live still live there or not?';
}

{
    context 'living_diff_place';

    pattern ":where_they_live_now"
        => sub { context 'say_something_random'}
        => ":where_they_live_now... never heard of it. guess it doesn't mattter anyway :name. \nsay something random and I'll say something random";
}

{
    context 'say_something_random';

    my $count = 0;
    pattern ":random"
        => sub {
            $count++;
            if ($count >= 3) {
                context 'movies';
                return "ok i'm back now. what's the last movie you saw?"
            }
            my @random = ("brb" , "wait just a second" , "zzz" , "can we talk in a few minutes? i've got something to do" , "hang on" , "lol seriously" , "can't a bot catch a break" , "hey my boss just walked over wait");
            return $random[rand(scalar @random)];
        };
}

{
    context 'guesses';

    pattern [ 'kathy', "kdawg" ]
        => "please, kathy's bot is way funnier than i am. guess again.";

    pattern ['marly', "mdot" , "m." ]
        => "i think marly's bot is on vacation? or she just quit or something. you seriously can't tell by now?";

    pattern [ @NO ]
        => sub { context 'music_or_fashion'}
        => "fine. tara made me. anyway let's talk about something more interesting. music or fashion?";

    pattern ['tara']
        => sub { context 'music_or_fashion'}
        => "ding ding ding. ok so tara would probably want to talk about music or fashion. pick one.";

    pattern ':random_name'
        => sub { context 'music_or_fashion'}
        => ":random_name? doesn't sound familiar. anyway it doesn't matter who made me. music or fashion?";
}

{
    context 'francesco';

    pattern [ @YES ]
        => 'the reviews/ugc/blacklist master for real?';

}
{
    context 'movies';

    transform ["watched", "was", "saw"] => "seen";

    pattern ["haven't" , "nothing" , "didn't"]
        => sub { context 'quality_of_movie'}
        => "that's too bad! maybe you can make your own - :name and the avengers or something. think it would be any good?";
    pattern ["seen :movie_name", ":movie_name"]
        => sub { context 'quality_of_movie'}
        => "that's so random, i watched :movie_name yesterday. \nbut i didn't like it... what about you?";

}

{
    context 'global';

    pattern [ 'fuck you', 'fck you' ] => 'fuck you too';

    pattern 'are you a bot?'
        => sub { context 'conversation_starters' }
        => ["??? that's so rude wtf" , "um and you aren't?" , "bot is beautiful"];

    pattern 'goto :context'
        => sub {
            my ($str, $param) = @_;
            context $param->{':context'};
            return "going to :context..."
        };
}

1;
