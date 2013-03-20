use Web::App::Dispatch;

module Web::App::Ballet;

my $app-transport;
my $app-object;
my $app-template-engine;

sub use-scgi (Int $port = 8118) is export
{
  require SCGI;
  $app-transport = ::('SCGI').new(:port($port));
}

sub use-http (Int $port = 8080) is export
{
  require HTTP::Easy::PSGI;
  $app-transport = ::('HTTP::Easy::PSGI').new(:port($port));
}

sub set-template-engine (Str $name, Str $path = './views') is export
{
  my $module = "Web::Template::$name";
  $app-template-engine = ::($module).new;
  $app-template-engine.set-path: $path;  
}

sub use-template6 (Str $path = './views') is export
{
  require Web::Template::Template6;
  set-template-engine('Template6', $path);
}

sub use-mojo (Str $path = './views') is export
{
  require Web::Template::Mojo;
  set-template-engine('Mojo', $path);
}

sub use-tal (Str $path = './views') is export
{
  require Web::Template::TAL;
  set-template-engine('TAL', $path);
}

sub use-html (Str $path = './views') is export
{
  require Web::Template::HTML;
  set-template-engine('HTML', $path);
}

## TODO: support Plosurin.

sub use-transport ($object) is export
{
  $app-transport = $object;
}

sub transport
{
  if ! $app-transport.defined
  {
    ## We default to HTTP::Easy if left unspecified.
    use-http;
  }
  return $app-transport;
}

sub template-engine is export
{
  if ! $app-template-engine.defined
  {
    ## We default to Template6 is left unspecified.
    use-template6;
  }
  return $app-template-engine;
}

sub app is export
{
  if ! $app-object.defined
  {
    $app-object = Web::App::Dispatch.new(transport);
  }
  return $app-object;
}

sub add-route (*%rules) is export
{
  app.add(|%rules);
}

sub handle-route (Pair $route, $method?)
{
  my %rules = { :path($route.key) };
  my $target = $route.value;
  if $target ~~ Str
  {
    %rules<redirect> = $target;
  }
  elsif $target ~~ Int
  {
    %rules<status> = $target;
  }
  else
  {
    %rules<handler> = $target;
  }
  if $method
  {
    %rules<method> = $method;
  }
  app.add(|%rules);
}

sub get (Pair $route) is export
{
  handle-route($route, 'GET');
}

sub post (Pair $route) is export
{
  handle-route($route, 'POST');
}

sub put (Pair $route) is export
{
  handle-route($route, 'PUT');
}

sub delete (Pair $route) is export
{
  handle-route($route, 'DELETE');
}

sub template (Str $template, *%named, *@positional)
{
  my $te = template-engine;
  $te.render($template, |%named, |@positional);
}

sub dance is export
{
  app.run;
}

