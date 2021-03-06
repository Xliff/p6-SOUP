use v6.c;

use GLib::Raw::Definitions;
use GLib::Raw::Enums;
use GIO::Raw::Enums;

unit package SOUP::Raw::Enums;

constant SoupAddressFamily is export := gint32;
our enum SoupAddressFamilyEnum is export (
  SOUP_ADDRESS_FAMILY_INVALID => -1,
  SOUP_ADDRESS_FAMILY_IPV4    =>  (G_SOCKET_FAMILY_IPV4.Int + 0),
  SOUP_ADDRESS_FAMILY_IPV6    =>  (G_SOCKET_FAMILY_IPV6.Int + 0)
);

constant SoupCacheResponse is export := guint32;
our enum SoupCacheResponseEnum is export <
  SOUP_CACHE_RESPONSE_FRESH
  SOUP_CACHE_RESPONSE_NEEDS_VALIDATION
  SOUP_CACHE_RESPONSE_STALE
>;

constant SoupCacheType is export := guint32;
our enum SoupCacheTypeEnum is export <
  SOUP_CACHE_SINGLE_USER
  SOUP_CACHE_SHARED
>;

constant SoupCacheability is export := guint32;
our enum SoupCacheabilityEnum is export (
  SOUP_CACHE_CACHEABLE   => (1 +< 0),
  SOUP_CACHE_UNCACHEABLE => (1 +< 1),
  SOUP_CACHE_INVALIDATES => (1 +< 2),
  SOUP_CACHE_VALIDATES   => (1 +< 3),
);

constant SoupConnectionState is export := guint32;
our enum SoupConnectionStateEnum is export <
  SOUP_CONNECTION_NEW
  SOUP_CONNECTION_CONNECTING
  SOUP_CONNECTION_IDLE
  SOUP_CONNECTION_IN_USE
  SOUP_CONNECTION_REMOTE_DISCONNECTED
  SOUP_CONNECTION_DISCONNECTED
>;

constant SoupCookieJarAcceptPolicy is export := guint32;
our enum SoupCookieJarAcceptPolicyEnum is export <
  SOUP_COOKIE_JAR_ACCEPT_ALWAYS
  SOUP_COOKIE_JAR_ACCEPT_NEVER
  SOUP_COOKIE_JAR_ACCEPT_NO_THIRD_PARTY
>;

constant SoupDateFormat is export := guint32;
our enum SoupDateFormatEnum is export (
  SOUP_DATE_HTTP => 1,
  'SOUP_DATE_COOKIE',
  'SOUP_DATE_RFC2822',
  'SOUP_DATE_ISO8601_COMPACT',
  'SOUP_DATE_ISO8601_FULL',
  SOUP_DATE_ISO8601 => 5, # SOUP_DATE_ISO8601_FULL
  'SOUP_DATE_ISO8601_XMLRPC'
);


constant SoupEncoding is export := guint32;
our enum SoupEncodingEnum is export <
  SOUP_ENCODING_UNRECOGNIZED
  SOUP_ENCODING_NONE
  SOUP_ENCODING_CONTENT_LENGTH
  SOUP_ENCODING_EOF
  SOUP_ENCODING_CHUNKED
  SOUP_ENCODING_BYTERANGES
>;

constant SoupExpectation is export := guint32;
our enum SoupExpectationEnum is export (
  SOUP_EXPECTATION_UNRECOGNIZED => (1 +< 0),
  SOUP_EXPECTATION_CONTINUE     => (1 +< 1),
);

constant SoupHTTPVersion is export := guint32;
our enum SoupHTTPVersionEnum is export (
  SOUP_HTTP_1_0 => 0,
  SOUP_HTTP_1_1 => 1,
);

constant SoupKnownStatusCode is export := guint32;
our enum SoupKnownStatusCodeEnum is export (
  'SOUP_KNOWN_STATUS_CODE_NONE',
  SOUP_KNOWN_STATUS_CODE_CANCELLED                       =>   1,
  'SOUP_KNOWN_STATUS_CODE_CANT_RESOLVE',
  'SOUP_KNOWN_STATUS_CODE_CANT_RESOLVE_PROXY',
  'SOUP_KNOWN_STATUS_CODE_CANT_CONNECT',
  'SOUP_KNOWN_STATUS_CODE_CANT_CONNECT_PROXY',
  'SOUP_KNOWN_STATUS_CODE_SSL_FAILED',
  'SOUP_KNOWN_STATUS_CODE_IO_ERROR',
  'SOUP_KNOWN_STATUS_CODE_MALFORMED',
  'SOUP_KNOWN_STATUS_CODE_TRY_AGAIN',
  'SOUP_KNOWN_STATUS_CODE_TOO_MANY_REDIRECTS',
  'SOUP_KNOWN_STATUS_CODE_TLS_FAILED',
  SOUP_KNOWN_STATUS_CODE_CONTINUE                        => 100,
  SOUP_KNOWN_STATUS_CODE_SWITCHING_PROTOCOLS             => 101,
  SOUP_KNOWN_STATUS_CODE_PROCESSING                      => 102,
  SOUP_KNOWN_STATUS_CODE_OK                              => 200,
  SOUP_KNOWN_STATUS_CODE_CREATED                         => 201,
  SOUP_KNOWN_STATUS_CODE_ACCEPTED                        => 202,
  SOUP_KNOWN_STATUS_CODE_NON_AUTHORITATIVE               => 203,
  SOUP_KNOWN_STATUS_CODE_NO_CONTENT                      => 204,
  SOUP_KNOWN_STATUS_CODE_RESET_CONTENT                   => 205,
  SOUP_KNOWN_STATUS_CODE_PARTIAL_CONTENT                 => 206,
  SOUP_KNOWN_STATUS_CODE_MULTI_STATUS                    => 207,
  SOUP_KNOWN_STATUS_CODE_MULTIPLE_CHOICES                => 300,
  SOUP_KNOWN_STATUS_CODE_MOVED_PERMANENTLY               => 301,
  SOUP_KNOWN_STATUS_CODE_FOUND                           => 302,
  SOUP_KNOWN_STATUS_CODE_MOVED_TEMPORARILY               => 302,
  SOUP_KNOWN_STATUS_CODE_SEE_OTHER                       => 303,
  SOUP_KNOWN_STATUS_CODE_NOT_MODIFIED                    => 304,
  SOUP_KNOWN_STATUS_CODE_USE_PROXY                       => 305,
  SOUP_KNOWN_STATUS_CODE_NOT_APPEARING_IN_THIS_PROTOCOL  => 306,
  SOUP_KNOWN_STATUS_CODE_TEMPORARY_REDIRECT              => 307,
  SOUP_KNOWN_STATUS_CODE_BAD_REQUEST                     => 400,
  SOUP_KNOWN_STATUS_CODE_UNAUTHORIZED                    => 401,
  SOUP_KNOWN_STATUS_CODE_PAYMENT_REQUIRED                => 402,
  SOUP_KNOWN_STATUS_CODE_FORBIDDEN                       => 403,
  SOUP_KNOWN_STATUS_CODE_NOT_FOUND                       => 404,
  SOUP_KNOWN_STATUS_CODE_METHOD_NOT_ALLOWED              => 405,
  SOUP_KNOWN_STATUS_CODE_NOT_ACCEPTABLE                  => 406,
  SOUP_KNOWN_STATUS_CODE_PROXY_AUTHENTICATION_REQUIRED   => 407,
  SOUP_KNOWN_STATUS_CODE_PROXY_UNAUTHORIZED              => 407, #= SOUP_KNOWN_STATUS_CODE_PROXY_AUTHENTICATION_REQUIRED
  SOUP_KNOWN_STATUS_CODE_REQUEST_TIMEOUT                 => 408,
  SOUP_KNOWN_STATUS_CODE_CONFLICT                        => 409,
  SOUP_KNOWN_STATUS_CODE_GONE                            => 410,
  SOUP_KNOWN_STATUS_CODE_LENGTH_REQUIRED                 => 411,
  SOUP_KNOWN_STATUS_CODE_PRECONDITION_FAILED             => 412,
  SOUP_KNOWN_STATUS_CODE_REQUEST_ENTITY_TOO_LARGE        => 413,
  SOUP_KNOWN_STATUS_CODE_REQUEST_URI_TOO_LONG            => 414,
  SOUP_KNOWN_STATUS_CODE_UNSUPPORTED_MEDIA_TYPE          => 415,
  SOUP_KNOWN_STATUS_CODE_REQUESTED_RANGE_NOT_SATISFIABLE => 416,
  SOUP_KNOWN_STATUS_CODE_INVALID_RANGE                   => 416, #= SOUP_KNOWN_STATUS_CODE_REQUESTED_RANGE_NOT_SATISFIABLE
  SOUP_KNOWN_STATUS_CODE_EXPECTATION_FAILED              => 417,
  SOUP_KNOWN_STATUS_CODE_UNPROCESSABLE_ENTITY            => 422,
  SOUP_KNOWN_STATUS_CODE_LOCKED                          => 423,
  SOUP_KNOWN_STATUS_CODE_FAILED_DEPENDENCY               => 424,
  SOUP_KNOWN_STATUS_CODE_INTERNAL_SERVER_ERROR           => 500,
  SOUP_KNOWN_STATUS_CODE_NOT_IMPLEMENTED                 => 501,
  SOUP_KNOWN_STATUS_CODE_BAD_GATEWAY                     => 502,
  SOUP_KNOWN_STATUS_CODE_SERVICE_UNAVAILABLE             => 503,
  SOUP_KNOWN_STATUS_CODE_GATEWAY_TIMEOUT                 => 504,
  SOUP_KNOWN_STATUS_CODE_HTTP_VERSION_NOT_SUPPORTED      => 505,
  SOUP_KNOWN_STATUS_CODE_INSUFFICIENT_STORAGE            => 507,
  SOUP_KNOWN_STATUS_CODE_NOT_EXTENDED                    => 510,
);

constant SoupLoggerLogLevel is export := guint32;
our enum SoupLoggerLogLevelEnum is export <
  SOUP_LOGGER_LOG_NONE
  SOUP_LOGGER_LOG_MINIMAL
  SOUP_LOGGER_LOG_HEADERS
  SOUP_LOGGER_LOG_BODY
>;

constant SoupMemoryUse is export := guint32;
our enum SoupMemoryUseEnum is export <
  SOUP_MEMORY_STATIC
  SOUP_MEMORY_TAKE
  SOUP_MEMORY_COPY
  SOUP_MEMORY_TEMPORARY
>;

constant SoupMessageFlags is export := guint32;
our enum SoupMessageFlagsEnum is export (
  SOUP_MESSAGE_NO_REDIRECT              => (1 +< 1),
  SOUP_MESSAGE_CAN_REBUILD              => (1 +< 2),
  SOUP_MESSAGE_OVERWRITE_CHUNKS         => (1 +< 3),
  SOUP_MESSAGE_CONTENT_DECODED          => (1 +< 4),
  SOUP_MESSAGE_CERTIFICATE_TRUSTED      => (1 +< 5),
  SOUP_MESSAGE_NEW_CONNECTION           => (1 +< 6),
  SOUP_MESSAGE_IDEMPOTENT               => (1 +< 7),
  SOUP_MESSAGE_IGNORE_CONNECTION_LIMITS => (1 +< 8),
  SOUP_MESSAGE_DO_NOT_USE_AUTH_CACHE    => (1 +< 9),
);

constant SoupMessageHeadersType is export := guint32;
our enum SoupMessageHeadersTypeEnum is export <
  SOUP_MESSAGE_HEADERS_REQUEST
  SOUP_MESSAGE_HEADERS_RESPONSE
  SOUP_MESSAGE_HEADERS_MULTIPART
>;

constant SoupMessagePriority is export := guint32;
our enum SoupMessagePriorityEnum is export (
  SOUP_MESSAGE_PRIORITY_VERY_LOW  => 0,
  'SOUP_MESSAGE_PRIORITY_LOW',
  'SOUP_MESSAGE_PRIORITY_NORMAL',
  'SOUP_MESSAGE_PRIORITY_HIGH',
  'SOUP_MESSAGE_PRIORITY_VERY_HIGH'
);

constant SoupRequestError is export := guint32;
our enum SoupRequestErrorEnum is export <
  SOUP_REQUEST_ERROR_BAD_URI
  SOUP_REQUEST_ERROR_UNSUPPORTED_URI_SCHEME
  SOUP_REQUEST_ERROR_PARSING
  SOUP_REQUEST_ERROR_ENCODING
>;

constant SoupRequesterError is export := guint32;
our enum SoupRequesterErrorEnum is export <
  SOUP_REQUESTER_ERROR_BAD_URI
  SOUP_REQUESTER_ERROR_UNSUPPORTED_URI_SCHEME
>;

constant SoupSameSitePolicy is export := guint32;
our enum SoupSameSitePolicyEnum is export <
  SOUP_SAME_SITE_POLICY_NONE
  SOUP_SAME_SITE_POLICY_LAX
  SOUP_SAME_SITE_POLICY_STRICT
>;

constant SoupServerListenOptions is export := guint32;
our enum SoupServerListenOptionsEnum is export (
  SOUP_SERVER_LISTEN_HTTPS     => (1 +< 0),
  SOUP_SERVER_LISTEN_IPV4_ONLY => (1 +< 1),
  SOUP_SERVER_LISTEN_IPV6_ONLY => (1 +< 2),
);

constant SoupSocketIOStatus is export := guint32;
our enum SoupSocketIOStatusEnum is export <
  SOUP_SOCKET_OK
  SOUP_SOCKET_WOULD_BLOCK
  SOUP_SOCKET_EOF
  SOUP_SOCKET_ERROR
>;

constant SoupStatus is export := guint32;
our enum SoupStatusEnum is export (
  'SOUP_STATUS_NONE',
  SOUP_STATUS_CANCELLED                       =>   1,
  'SOUP_STATUS_CANT_RESOLVE',
  'SOUP_STATUS_CANT_RESOLVE_PROXY',
  'SOUP_STATUS_CANT_CONNECT',
  'SOUP_STATUS_CANT_CONNECT_PROXY',
  'SOUP_STATUS_SSL_FAILED',
  'SOUP_STATUS_IO_ERROR',
  'SOUP_STATUS_MALFORMED',
  'SOUP_STATUS_TRY_AGAIN',
  'SOUP_STATUS_TOO_MANY_REDIRECTS',
  'SOUP_STATUS_TLS_FAILED',
  SOUP_STATUS_CONTINUE                        => 100,
  SOUP_STATUS_SWITCHING_PROTOCOLS             => 101,
  SOUP_STATUS_PROCESSING                      => 102,
  SOUP_STATUS_OK                              => 200,
  SOUP_STATUS_CREATED                         => 201,
  SOUP_STATUS_ACCEPTED                        => 202,
  SOUP_STATUS_NON_AUTHORITATIVE               => 203,
  SOUP_STATUS_NO_CONTENT                      => 204,
  SOUP_STATUS_RESET_CONTENT                   => 205,
  SOUP_STATUS_PARTIAL_CONTENT                 => 206,
  SOUP_STATUS_MULTI_STATUS                    => 207,
  SOUP_STATUS_MULTIPLE_CHOICES                => 300,
  SOUP_STATUS_MOVED_PERMANENTLY               => 301,
  SOUP_STATUS_FOUND                           => 302,
  SOUP_STATUS_MOVED_TEMPORARILY               => 302,
  SOUP_STATUS_SEE_OTHER                       => 303,
  SOUP_STATUS_NOT_MODIFIED                    => 304,
  SOUP_STATUS_USE_PROXY                       => 305,
  SOUP_STATUS_NOT_APPEARING_IN_THIS_PROTOCOL  => 306,
  SOUP_STATUS_TEMPORARY_REDIRECT              => 307,
  SOUP_STATUS_BAD_REQUEST                     => 400,
  SOUP_STATUS_UNAUTHORIZED                    => 401,
  SOUP_STATUS_PAYMENT_REQUIRED                => 402,
  SOUP_STATUS_FORBIDDEN                       => 403,
  SOUP_STATUS_NOT_FOUND                       => 404,
  SOUP_STATUS_METHOD_NOT_ALLOWED              => 405,
  SOUP_STATUS_NOT_ACCEPTABLE                  => 406,
  SOUP_STATUS_PROXY_AUTHENTICATION_REQUIRED   => 407,
  SOUP_STATUS_PROXY_UNAUTHORIZED              => 407, #= SOUP_STATUS_PROXY_AUTHENTICATION_REQUIRED
  SOUP_STATUS_REQUEST_TIMEOUT                 => 408,
  SOUP_STATUS_CONFLICT                        => 409,
  SOUP_STATUS_GONE                            => 410,
  SOUP_STATUS_LENGTH_REQUIRED                 => 411,
  SOUP_STATUS_PRECONDITION_FAILED             => 412,
  SOUP_STATUS_REQUEST_ENTITY_TOO_LARGE        => 413,
  SOUP_STATUS_REQUEST_URI_TOO_LONG            => 414,
  SOUP_STATUS_UNSUPPORTED_MEDIA_TYPE          => 415,
  SOUP_STATUS_REQUESTED_RANGE_NOT_SATISFIABLE => 416,
  SOUP_STATUS_INVALID_RANGE                   => 416, #= SOUP_STATUS_REQUESTED_RANGE_NOT_SATISFIABLE
  SOUP_STATUS_EXPECTATION_FAILED              => 417,
  SOUP_STATUS_UNPROCESSABLE_ENTITY            => 422,
  SOUP_STATUS_LOCKED                          => 423,
  SOUP_STATUS_FAILED_DEPENDENCY               => 424,
  SOUP_STATUS_INTERNAL_SERVER_ERROR           => 500,
  SOUP_STATUS_NOT_IMPLEMENTED                 => 501,
  SOUP_STATUS_BAD_GATEWAY                     => 502,
  SOUP_STATUS_SERVICE_UNAVAILABLE             => 503,
  SOUP_STATUS_GATEWAY_TIMEOUT                 => 504,
  SOUP_STATUS_HTTP_VERSION_NOT_SUPPORTED      => 505,
  SOUP_STATUS_INSUFFICIENT_STORAGE            => 507,
  SOUP_STATUS_NOT_EXTENDED                    => 510,
);

constant SoupTLDError is export := guint32;
our enum SoupTLDErrorEnum is export <
  SOUP_TLD_ERROR_INVALID_HOSTNAME
  SOUP_TLD_ERROR_IS_IP_ADDRESS
  SOUP_TLD_ERROR_NOT_ENOUGH_DOMAINS
  SOUP_TLD_ERROR_NO_BASE_DOMAIN
  SOUP_TLD_ERROR_NO_PSL_DATA
>;

constant SoupWebsocketCloseCode is export := guint32;
our enum SoupWebsocketCloseCodeEnum is export (
  SOUP_WEBSOCKET_CLOSE_NORMAL           => 1000,
  SOUP_WEBSOCKET_CLOSE_GOING_AWAY       => 1001,
  SOUP_WEBSOCKET_CLOSE_PROTOCOL_ERROR   => 1002,
  SOUP_WEBSOCKET_CLOSE_UNSUPPORTED_DATA => 1003,
  SOUP_WEBSOCKET_CLOSE_NO_STATUS        => 1005,
  SOUP_WEBSOCKET_CLOSE_ABNORMAL         => 1006,
  SOUP_WEBSOCKET_CLOSE_BAD_DATA         => 1007,
  SOUP_WEBSOCKET_CLOSE_POLICY_VIOLATION => 1008,
  SOUP_WEBSOCKET_CLOSE_TOO_BIG          => 1009,
  SOUP_WEBSOCKET_CLOSE_NO_EXTENSION     => 1010,
  SOUP_WEBSOCKET_CLOSE_SERVER_ERROR     => 1011,
  SOUP_WEBSOCKET_CLOSE_TLS_HANDSHAKE    => 1015,
);

constant SoupWebsocketConnectionType is export := guint32;
our enum SoupWebsocketConnectionTypeEnum is export <
  SOUP_WEBSOCKET_CONNECTION_UNKNOWN
  SOUP_WEBSOCKET_CONNECTION_CLIENT
  SOUP_WEBSOCKET_CONNECTION_SERVER
>;

constant SoupWebsocketDataType is export := guint32;
our enum SoupWebsocketDataTypeEnum is export (
  SOUP_WEBSOCKET_DATA_TEXT   => 0x01,
  SOUP_WEBSOCKET_DATA_BINARY => 0x02,
);

constant SoupWebsocketError is export := guint32;
our enum SoupWebsocketErrorEnum is export <
  SOUP_WEBSOCKET_ERROR_FAILED
  SOUP_WEBSOCKET_ERROR_NOT_WEBSOCKET
  SOUP_WEBSOCKET_ERROR_BAD_HANDSHAKE
  SOUP_WEBSOCKET_ERROR_BAD_ORIGIN
>;

constant SoupWebsocketState is export := guint32;
our enum SoupWebsocketStateEnum is export (
  SOUP_WEBSOCKET_STATE_OPEN    => 1,
  SOUP_WEBSOCKET_STATE_CLOSING => 2,
  SOUP_WEBSOCKET_STATE_CLOSED  => 3,
);

constant SoupXMLRPCError is export := guint32;
our enum SoupXMLRPCErrorEnum is export <
  SOUP_XMLRPC_ERROR_ARGUMENTS
  SOUP_XMLRPC_ERROR_RETVAL
>;

constant SoupXMLRPCFault is export := gint32;
our enum SoupXMLRPCFaultEnum is export (
  SOUP_XMLRPC_FAULT_PARSE_ERROR_NOT_WELL_FORMED                => -32700,
  SOUP_XMLRPC_FAULT_PARSE_ERROR_UNSUPPORTED_ENCODING           => -32701,
  SOUP_XMLRPC_FAULT_PARSE_ERROR_INVALID_CHARACTER_FOR_ENCODING => -32702,
  SOUP_XMLRPC_FAULT_SERVER_ERROR_INVALID_XML_RPC               => -32600,
  SOUP_XMLRPC_FAULT_SERVER_ERROR_REQUESTED_METHOD_NOT_FOUND    => -32601,
  SOUP_XMLRPC_FAULT_SERVER_ERROR_INVALID_METHOD_PARAMETERS     => -32602,
  SOUP_XMLRPC_FAULT_SERVER_ERROR_INTERNAL_XML_RPC_ERROR        => -32603,
  SOUP_XMLRPC_FAULT_APPLICATION_ERROR                          => -32500,
  SOUP_XMLRPC_FAULT_SYSTEM_ERROR                               => -32400,
  SOUP_XMLRPC_FAULT_TRANSPORT_ERROR                            => -32300,
);

# For testing purposes ONLY!
constant SoupTestRequestFlags is export := guint32;
our enum SoupTestRequestFlagsEnum is export (
  SOUP_TEST_REQUEST_NONE                     =>        0,
  SOUP_TEST_REQUEST_CANCEL_MESSAGE           => (1 +< 0),
  SOUP_TEST_REQUEST_CANCEL_CANCELLABLE       => (1 +< 1),
  SOUP_TEST_REQUEST_CANCEL_SOON              => (1 +< 2),
  SOUP_TEST_REQUEST_CANCEL_IMMEDIATE         => (1 +< 3),
  SOUP_TEST_REQUEST_CANCEL_PREEMPTIVE        => (1 +< 4),
  SOUP_TEST_REQUEST_CANCEL_AFTER_SEND_FINISH => (1 +< 5),
);

constant SoupTestServerOptions is export := guint32;
our enum SoupTestServerOptionsEnum is export (
  SOUP_TEST_SERVER_DEFAULT             =>        0,
  SOUP_TEST_SERVER_IN_THREAD           => (1 +< 0),
  SOUP_TEST_SERVER_NO_DEFAULT_LISTENER => (1 +< 1),
);
