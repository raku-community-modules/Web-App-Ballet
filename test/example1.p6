use v6;

use lib './lib';

use WWW::App::Ballet;

get '/' => sub ($c)
{
  $c.content-type: 'text/plain';
  my $name = $c.get(:default<World>, 'name');
  $c.send("Hello $name");
}

dance;
