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

sub use-template6 (Str $path = './templates') is export
{
  require Template6;
  $app-template-engine = ::('Template6').new;
  $app-template-engine.add-path: $path;
}

sub use-tal (Str $path = './templates') is export
{
  require Flower::TAL;
  $app-template-engine = ::('Flower::TAL').new;
  $app-template-engine.provider.add-path: $path;
}

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

sub template (Str $template, *%opts)
{
  my $te = template-engine;
  if $te.can('process')
  {
    return $te.process($template, |%opts);
  }
  elsif $te.can('get')
  {
    my $tmpl = $te.get($template);
    if $tmpl.can('render')
    {
      return $tmpl.render(|%opts);
    }
  }

  die "template engine is not supported.";
}

sub dance is export
{
  app.run;
}
