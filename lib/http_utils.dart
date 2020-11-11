import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'log_utils.dart';

const GET = 'GET';
const POST = 'POST';
const PUT = 'PUT';
const DELETE = 'DELETE';

const NO_INTERNET_CONNECTION = 'NO_INTERNET_CONNECTION';
const CONNECTION_TIMEOUT = 'CONNECTION_TIMEOUT';

const TYPE_APPLICATION_JSON = 'application/json';
const TYPE_MULTIPART_FORM_DATA = 'multipart/form-data';
const TYPE_X_AUTHORIZATION = 'x-authorization';

const JSON_HEADERS = const {
  HttpHeaders.contentTypeHeader: TYPE_APPLICATION_JSON,
  HttpHeaders.acceptHeader: TYPE_APPLICATION_JSON,
};

const Duration DEFAULT_TIMEOUT_DURATION = const Duration(seconds: 30);

void get({
  @required final ValueChanged<http.Response> onResponse,
  @required final VoidCallback onTimeout,
  @required final String tag,
  @required final String url,
  final Map<String, String> headers = JSON_HEADERS,
  final Map<String, String> params,
  final Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) {
  String fullUrl = url;

  if (params != null && params.isNotEmpty && params.length > 0) {
    fullUrl += '?';
    params.forEach((key, value) {
      if (fullUrl[fullUrl.length - 1] != '?') {
        fullUrl += '&';
      }
      fullUrl += key + '=' + value;
    });
  }

  http.get(fullUrl, headers: headers).timeout(
    timeoutDuration,
    onTimeout: () {
      LogUtils.printDebugLog(
        tag,
        '\nRequest URL: $fullUrl'
        '\nRequest Method: $GET'
        '\nRequest Headers: ${headers?.toString()}'
        '\nRequest Params: ${params?.toString()}'
        '\nRequest Timeout: $fullUrl',
      );

      if (onTimeout != null) {
        onTimeout();
      }

      return null;
    },
  ).then((http.Response response) {
    LogUtils.printDebugLog(
      tag,
      '\nRequest URL: $fullUrl'
      '\nRequest Method: $GET'
      '\nRequest Headers: ${headers?.toString()}'
      '\nRequest Params: ${params?.toString()}'
      '\nResponse Code: ${response?.statusCode}'
      '\nResponse Body: ${response?.body}',
    );

    if (onResponse != null) {
      onResponse(response);
    }

    return response;
  });
}

void post({
  @required final ValueChanged<http.Response> onResponse,
  @required final VoidCallback onTimeout,
  @required final String tag,
  @required final String url,
  final Map<String, String> headers = JSON_HEADERS,
  final dynamic body,
  final Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) {
  http.post(url, headers: headers, body: body).timeout(
    timeoutDuration,
    onTimeout: () {
      LogUtils.printDebugLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: $POST'
        '\nRequest Headers: ${headers?.toString()}'
        '\nRequest Body: $body'
        '\nRequest Timeout: $url',
      );

      if (onTimeout != null) {
        onTimeout();
      }

      return null;
    },
  ).then((http.Response response) {
    LogUtils.printDebugLog(
      tag,
      '\nRequest URL: $url'
      '\nRequest Method: $POST'
      '\nRequest Headers: ${headers?.toString()}'
      '\nRequest Body: $body'
      '\nResponse Code: ${response?.statusCode}'
      '\nResponse Body: ${response?.body}',
    );

    if (onResponse != null) {
      onResponse(response);
    }

    return response;
  });
}

void postFormData({
  @required final ValueChanged<http.StreamedResponse> onResponse,
  @required final VoidCallback onTimeout,
  @required String tag,
  @required String url,
  Map<String, String> headers = JSON_HEADERS,
  Map<String, String> params,
  String key,
  List<String> filePaths,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  var request = http.MultipartRequest(POST, Uri.parse(url));
  request.headers.addAll(headers);

  if (params != null && params.isNotEmpty && params.length > 0) {
    params.forEach((key, value) {
      request.fields[key] = value;
    });
  }

  if (filePaths != null && filePaths.isNotEmpty && filePaths.length > 0) {
    for (String path in filePaths) {
      if (path != null && path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          key,
          path,
          filename: path.split('/').last,
          contentType: MediaType('application', 'x-tar'),
        ));
      }
    }
  }

  request.send().timeout(
    timeoutDuration,
    onTimeout: () {
      LogUtils.printDebugLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: $POST'
        '\nRequest Headers: $headers'
        '\nRequest Key: $key'
        '\nRequest Files: ${filePaths?.toString()}'
        '\nRequest Body: ${params?.toString()}'
        '\nRequest Timeout: $url',
      );

      if (onTimeout != null) {
        onTimeout();
      }

      return null;
    },
  ).then((http.StreamedResponse response) {
    LogUtils.printDebugLog(
      tag,
      '\nRequest URL: $url'
      '\nRequest Method: $POST'
      '\nRequest Headers: $headers'
      '\nRequest Key: $key'
      '\nRequest Files: ${filePaths?.toString()}'
      '\nRequest Body: ${params?.toString()}'
      '\nResponse Code: ${response?.statusCode}'
      '\nResponse Body: ${response?.toString()}',
    );

    if (onResponse != null) {
      onResponse(response);
    }

    return response;
  });
}

void put({
  @required final ValueChanged<http.Response> onResponse,
  @required final VoidCallback onTimeout,
  @required final String tag,
  @required final String url,
  final Map<String, String> headers = JSON_HEADERS,
  final dynamic body,
  final Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) {
  http.put(url, headers: headers, body: body).timeout(
    timeoutDuration,
    onTimeout: () {
      LogUtils.printDebugLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: $PUT'
        '\nRequest Headers: ${headers?.toString()}'
        '\nRequest Body: $body'
        '\nRequest Timeout: $url',
      );

      if (onTimeout != null) {
        onTimeout();
      }

      return null;
    },
  ).then((http.Response response) {
    LogUtils.printDebugLog(
      tag,
      '\nRequest URL: $url'
      '\nRequest Method: $PUT'
      '\nRequest Headers: ${headers?.toString()}'
      '\nRequest Body: $body'
      '\nResponse Code: ${response?.statusCode}'
      '\nResponse Body: ${response?.body}',
    );

    if (onResponse != null) {
      onResponse(response);
    }

    return response;
  });
}

void delete({
  @required final ValueChanged<http.Response> onResponse,
  @required final VoidCallback onTimeout,
  @required final String tag,
  @required final String url,
  final Map<String, String> headers = JSON_HEADERS,
  final dynamic body,
  final Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) {
  http.delete(url, headers: headers).timeout(timeoutDuration, onTimeout: () {
    LogUtils.printDebugLog(
      tag,
      '\nRequest URL: $url'
      '\nRequest Method: $DELETE'
      '\nRequest Headers: ${headers?.toString()}'
      '\nRequest Body: $body'
      '\nRequest Timeout: $url',
    );

    if (onTimeout != null) {
      onTimeout();
    }

    return null;
  }).then((http.Response response) {
    LogUtils.printDebugLog(
      tag,
      '\nRequest URL: $url'
      '\nRequest Method: $DELETE'
      '\nRequest Headers: ${headers?.toString()}'
      '\nRequest Body: $body'
      '\nResponse Code: ${response?.statusCode}'
      '\nResponse Body: ${response?.body}',
    );

    if (onResponse != null) {
      onResponse(response);
    }

    return response;
  });
}
