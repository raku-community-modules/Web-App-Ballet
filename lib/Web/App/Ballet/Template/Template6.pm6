class Web::App::Ballet::Template::Template6 does Web::App::Ballet::Template
{
  use Template6;
  
  has $!engine = Template6.new;

  method render ($template, *%named, *@positional)
  { ## Template6 uses named parameters only.
    $!engine.process($template, |%named);
  }

  method set-path ($template-path)
  {
    $!engine.add-path($path);
  }

}
