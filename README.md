# WWW::App::Ballet

## Introduction

An extension to [WWW::App](https://github.com/supernovus/www-app/) which
adds an interface similar to Dancer or Bailador.

It currently supports SCGI and HTTP::Easy as transports, and Template6
and Flower::TAL as template engines. It will gain more as I develop it further.

It's very much experimental, and not nearly as feature complete as I'd like.

It will assist me in expanding WWW::App itself, as I figure out what features
are required to make this really useful.

## Example Application Script

```perl
  use WWW::App::Ballet;

  get '/' => sub ($c) {
    $c.content-type: 'text/plain';
    my $name = $c.get(:default<World>, 'name');
    $c.send("Hello $name"); ## Explicit context output specified.
  }

  get '/perl6' => 'http://perl6.org/'; ## A redirect statement.

  get '/about' => sub ($c) {
    template 'about.tt', { :ver<1.0.0> }; ## Implicit output.
  }

  dance;

```

## TODO

 * Add more Transport handlers.
 * Add more Template engines.
 * Make it more useful (i.e. make the context object optional.)

## Author

Timothy Totten, supernovus on #perl6, https://github.com/supernovus/

## License

[Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0)

