use v6;

use lib './lib';

use Web::App::Ballet;

use-template6 './test/views';

get '/' => sub ($c)
{
  $c.content-type: 'text/plain';
  my $name = $c.get(:default<World>, 'name');
  $c.send("Hello $name");
}

get '/test/' => sub ($c)
{
  my $who = $c.get(:default<Bob>, 'who');
  ### There is a bug, we should be able to do the following line:
  #template 'help', :$who;
  ### But until implicit content is working again, we have to use this:
  $c.send(template('help', :$who));
}

dance;

