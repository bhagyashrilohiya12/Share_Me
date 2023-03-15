import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cpr_user/Constants/network_error_codes.dart';
import 'package:cpr_user/models/network_params.dart';
import 'package:cpr_user/helpers/params_to_url_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

const BASE_URL = "https://us-central1-clippicreview.cloudfunctions.net/";

enum RequestMethod {
  GET,
  POST,
  PUT,
  DELETE,
}

enum LocalStorageStrategy {
  SAVE,
  LOAD,
  CLEAR,
}

NetworkService networkService = new NetworkService();

class NetworkService {
  Future<dynamic> callApi(
      {required String url,
      NetworkParams? params,
      required RequestMethod requestMethod}) async {
    String token = "";

    var dio = Dio(baseOptions(token));
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
        request: false,
        requestBody: true,
      ));
    }

    switch (requestMethod) {
      case RequestMethod.GET:
        // var dio = Dio(baseOptions(token));
        String parmTU;
        if (params != null) {
          parmTU = paramsToUrl(url: url, params: params.toJson());
        } else {
          parmTU = url;
        }
        // print(parmTU);
        try {
          final response = await dio.get(parmTU);
          if (response.statusCode == 200) {
            log(url + "==>" + response.data.toString());
            return response.data;
          }
        } on SocketException catch (e) {
          return NetworkErrorCodes.SOCKET_EXCEPTION;
        } on FormatException catch (_) {
          throw FormatException("Unable to process the data");
        } catch (e) {
          if (Get.isOverlaysOpen) Get.back();
          if (e is DioError) {
            if (e.type == DioErrorType.connectionTimeout) {
              return NetworkErrorCodes.CONNECT_TIMEOUT;
            }
            if (e.type == DioErrorType.receiveTimeout) {
              return NetworkErrorCodes.RECEIVE_TIMEOUT;
            }
            if (e.type == DioErrorType.sendTimeout) {
              return NetworkErrorCodes.SEND_TIMEOUT;
            }
            if (e.type == DioErrorType.unknown) {
              return NetworkErrorCodes.SOCKET_EXCEPTION;
            }
//            Get.snackbar(e?.response?.statusMessage, "");
          } else {
            Get.snackbar("Unknown Error", "");
            throw e;
          }
        }

        break;
      case RequestMethod.POST:
        // var dio = Dio(baseOptions(''));
        // print(url + "," + params.toJson().toString());
        try {
          final response = await dio.post(url, data: jsonEncode(params));
          if (response.statusCode == 200) {
            log(url + "==>" + response.data.toString());
            return response.data;
          }
        } on SocketException catch (e) {
          return NetworkErrorCodes.SOCKET_EXCEPTION;
        } on FormatException catch (_) {
          throw FormatException("Unable to process the data");
        } catch (e) {
          if (Get.isOverlaysOpen) Get.back();
          if (e is DioError) {
            if (e.type == DioErrorType.connectionTimeout) {
              return NetworkErrorCodes.CONNECT_TIMEOUT;
            }
            if (e.type == DioErrorType.receiveTimeout) {
              return NetworkErrorCodes.RECEIVE_TIMEOUT;
            }
            if (e.type == DioErrorType.sendTimeout) {
              return NetworkErrorCodes.SEND_TIMEOUT;
            }
            if (e.type == DioErrorType.unknown) {
              return NetworkErrorCodes.SOCKET_EXCEPTION;
            }
//            Get.snackbar(e?.response?.statusMessage, "");
          } else {
            Get.snackbar("Unknown Error", "");
            throw e;
          }
          return null;
        }

        break;
      case RequestMethod.PUT:
        try {
          final response = await Dio(baseOptions(token)).put(url, data: params);
          if (response.statusCode == 200) {
            log(url + "==>" + response.data.toString());
            return response.data;
          }
        } on SocketException catch (e) {
          return NetworkErrorCodes.SOCKET_EXCEPTION;
        } on FormatException catch (_) {
          throw FormatException("Unable to process the data");
        } catch (e) {
          if (Get.isOverlaysOpen) Get.back();
          if (e is DioError) {
            if (e.type == DioErrorType.connectionTimeout) {
              return NetworkErrorCodes.CONNECT_TIMEOUT;
            }
            if (e.type == DioErrorType.receiveTimeout) {
              return NetworkErrorCodes.RECEIVE_TIMEOUT;
            }
            if (e.type == DioErrorType.sendTimeout) {
              return NetworkErrorCodes.SEND_TIMEOUT;
            }
            if (e.type == DioErrorType.unknown) {
              return NetworkErrorCodes.SOCKET_EXCEPTION;
            }
//            Get.snackbar(e?.response?.statusMessage, "");
          } else {
            Get.snackbar("Unknown Error", "");
            throw e;
          }
        }

        break;
      case RequestMethod.DELETE:
        String parmTU;
        if (params != null) {
          parmTU = paramsToUrl(url: url, params: params.toJson());
        } else {
          parmTU = url;
        }
        final response = await dio.delete(url, data: jsonEncode(params));
        try {
          if (response.statusCode == 200) {
            log(url + "==>" + response.data.toString());
            return response.data;
          } else {
            handlingException(response);
          }
        } on SocketException catch (e) {
          return NetworkErrorCodes.SOCKET_EXCEPTION;
        } on FormatException catch (_) {
          throw FormatException("Unable to process the data");
        } catch (e) {
          if (Get.isOverlaysOpen) Get.back();
          if (e is DioError) {
            if (e.type == DioErrorType.connectionTimeout) {
              return NetworkErrorCodes.CONNECT_TIMEOUT;
            }
            if (e.type == DioErrorType.receiveTimeout) {
              return NetworkErrorCodes.RECEIVE_TIMEOUT;
            }
            if (e.type == DioErrorType.sendTimeout) {
              return NetworkErrorCodes.SEND_TIMEOUT;
            }
            if (e.type == DioErrorType.unknown) {
              return NetworkErrorCodes.SOCKET_EXCEPTION;
            }
//            Get.snackbar(e?.response?.statusMessage, "");
          } else {
            Get.snackbar("Unknown Error", "");
            throw e;
          }
        }
        break;
    }
  }

  BaseOptions baseOptions(String token) => BaseOptions(
        connectTimeout: Duration(milliseconds: 40000),
        headers: {"Content-type": "application/json"},
      );

  void handlingException(var response) {
//    statusCodesDictionary(response)[response.statusCode]();
  }
}
