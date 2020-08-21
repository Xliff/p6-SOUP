use v6.c;

use SOUP::Raw::Types;

use GLib::MainLoop;
use GLib::MappedFile;
use GLib::Markup;
use GIO::TlsCertificate;
use SOUP::Buffer;
use SOUP::Server;

sub get-directory-listing ($path) {
  my $display-path = $path.substr( $path.index('/') + 1 );
  my @entries = gather for $path.IO.dir -> {
    next if .absolute eq <. .. ./>.any;
    take GLib::Markup.escape-text(.absolute);
  }

  qq:to/LISTING/;
  <html>
    <head>
      <title>Index of { $display-path }</title>
    </head>
    <body>
      <h1>Index of { $display-path }</h1>
      { @entries.map(
          qq{    <a href="{ $_ }">{ $_ }</a><br>}
        ).join("\n") }
    </body>
  </html>
  LISTING
}

sub do-get ($server, $msg, $path) {
  my $r;
  {
    CATCH {
      when X::IO::DoesNotExist {
        $r = SOUP_STATUS_NOT_FOUND
      }
      default {
        $r = SOUP_STATUS_INTERNAL_SERVER_ERROR;
      }
    }
    my $is-r = try $path.IO.r;
    unless $is-r {
      $r = $path.e ?? SOUP_STATUS_FORBIDDEN
                   !! SOUP_STATUS_INTERNAL_SERVER_ERROR;
    }
  }
  return $msg.set-status($r) if $r;

  if $path.IO.d {
    if ( my $sl = $path.index('/') ) && $path.chars > $sl - 1 {
      $msg.set-redirect(SOUP_STATUS_MOVED_PERMANENTLY, "{ $msg.path }/");
      return;
    }

    if (my $index-path = "{ $path }/index.html").IO.r {
      do-get($server, $msg, $index-path);
      return;
    }

    $msg.set-response(
      'text/html',
      SOUP_MEMORY_TAKE,
      get-directory-listing($path)
    );
    $msg.status-code = SOUP_STATUS_OK;
    return;
  }

  if $msg.method == %SOUP-METHOD<GET> {
    my $mapping = GLib::MappedFile.new($path);
    unless $mapping {
      $msg.set-status(SOUP_STATUS_INTERNAL_SERVER_ERROR);
      return;
    }

    my $buffer = SOUP::Buffer.new-with-owner(
      $mapping.contents,
      $mapping,
      -> $ { $mapping.unref }
    );
    $msg.append-buffer($buffer);
    $buffer.free;
  } else {
    $msg.response-headers.append('Content-Length', $path.IO.l);
  }

  $msg.status-code = SOUP_STATUS_OK;
}

sub do-put ($server, $msg, $path) {
  my $created = True;

  if $path.IO.e {
    if $msg.request-headers.get-one('If-None-Match') -> $match {
      if $match eq '*' {
        $msg.set-status(SOUP_STATUS_CONFLICT);
        return;
      }
    }

    if $path.IO.d {
      $msg.set-status(SOUP_STATUS_FORBIDDEN);
      return;
    }
    $created = False;
  }

  my $r;
  try {
    CATCH {
      default { $r = SOUP_STATUS_INTERNAL_SERVER_ERROR }
    }
    my $f = $path.IO.spurt($msg.request-body.data);
  }

  $msg.set-status(
    $r ?? $r
       !! ( $created ?? SOUP_STATUS_CREATED !! SOUP_STATUS_OK )
  )
}

sub server-callback($server, $msg, $path, $query, $context, $data) {
  my $iter = $msg.request-headers.iter;
  my @headers = gather while $iter.next {
    take "{ .[0] }: { .[1] }";
  }

  say qq:to/HEADER/;
    { $msg.method } { $path } HTTP/1.{ $msg.http-version }
    { @headers.join("\n") }
    HEADER

  say $msg.request-body.data if $msg.request-body.length;

  given $msg.method {
    when    %SOUP-METHOD<GET HEAD>.any { do-get($server, $msg, $path) }
    when    %SOUP-METHOD<PUT>          { do-put($server, $msg, $path) }

    default { $msg.set-status(SOUP_STATUS_NOT_IMPLEMENTED) }
  }
  say "  -> { $msg.status-code } { $msg.reason-phrase }\n";
}

sub MAIN (
  :c(:$cert-file),    #= Use FILE as the TLS certificate file
  :k(:$key-file),     #= Use FILE as the TLS private key file
  :p(:$port)          #= Port to listen on
) {
  signal(SIGINT).tap: { exit 0 };

  my ($cert, $server);

  if $cert-file && $key-file {
    $cert = GIO::TlsCertificate.new-from-files($cert-file, $key-file);
    if $ERROR {
      $*ERR.say: "Unable to create server: { $ERROR.message }";
      exit 1;
    }
    $server = SOUP::Server.new(
      SOUP_SERVER_SERVER_HEADER,          'simple-httpd',
      SOUP_SERVER_TLS_CERTIFICATE, $cert,
    );
    $server.listen-all($port, SOUP_SERVER_LISTEN_HTTPS);
  } else {
    $server = SOUP::Server.new(
      SOUP_SERVER_SERVER_HEADER,          'simple-httpd',
    );
    $server.listen-all($port);
  }

  $server.add-handler(&server-callback);
  say "Listening on { $_ }" for $server.get-uris;

  say "\nWaiting for requests....\n";
  GLib::MainLoop.new.run;
}
