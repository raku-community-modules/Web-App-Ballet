class Web::App::Ballet::Template::HTML does Web::App::Ballet::Template
{
  use HTML::Template;

  has $!engine = HTML::Template;
  has $!path   = './views';

  method render ($template-name, *%named, *@positional)
  { ## HTML::Template uses named parameters.
    my $template = $!path ~ $template-name; 
    $!engine.from_file($template).with_params(%named).output;
  }

  method set-path ($template-path)
  {
    $!path = $template-path;
  }

}
