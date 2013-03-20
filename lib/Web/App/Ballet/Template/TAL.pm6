class Web::App::Ballet::Template::TAL does Web::App::Ballet::Template
{
  use Flower::TAL;
  
  has $!engine = Flower::TAL.new;

  method render ($template, *%named, *@positional)
  { ## Flower::TAL uses named parameters only.
    $!engine.process($template, |%named);
  }

  method set-path ($template-path)
  {
    $!engine.provider.add-path($path);
  }

}
