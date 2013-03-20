class Web::App::Ballet::Template::Mojo does Web::App::Ballet::Template
{
  use Template::Mojo;

  has $!engine = Template::Mojo;
  has $!path   = './views';

  method render ($template-name, *%named, *@positional)
  { ## Template::Mojo uses positional paramemters.
    my $template = slurp($!path ~ $template-name); 
    $!engine.new($template).render(|@positional);
  }

  method set-path ($template-path)
  {
    $!path = $template-path;
  }

}
