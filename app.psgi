use strict;
use warnings;

use Plack::Builder;

# add data base conection
use Plack::Request;
use Plack::Request::Upload;
use Plack::Session;
use Plack::App::File;
use Data::Dumper;
use lib ( 'Controller', 'Lib' );
use Utils qw(load_params response load_plugins upload_file
  load_routes);

use PdfUploader;
use ShowPdf;

my $plugins = load_plugins();
my $apps    = load_routes(
  {
    PdfUploader => 'pdf_upload.tt',
    ShowPdf     => 'main.tt',
  }
);

builder {
  mount "/js" =>
    Plack::App::File->new( root => './Templates/static/jquery.min.js' )
    ->to_app();
  mount "/css" =>
    Plack::App::File->new( file => './Templates/static/css/style.css' )
    ->to_app();
  mount "/pdf" =>
    Plack::App::File->new( file => './Pdf/CV-Trif-Dragos-Dorin.pdf' )->to_app();
  mount "/javascript" =>
    Plack::App::File->new( file => './Templates/static/javascript.js' )
    ->to_app();

  mount '/admin' => builder {
    enable $plugins->{AUTHORIZATION}->();
    $apps->{PdfUploader};
  };

  mount '/public' => $apps->{ShowPdf};
};
