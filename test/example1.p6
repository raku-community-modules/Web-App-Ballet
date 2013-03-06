use v6;

use lib './lib';

use Web::App::Ballet;

use-scgi; ## HTTP::Easy is currently broken.

get '/' => sub ($c)
{
  $c.content-type: 'text/plain';
  my $name = $c.get(:default<World>, 'name');
  $c.send("Hello $name");
}

dance;

