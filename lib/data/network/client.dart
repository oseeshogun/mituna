import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static Dio create() {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          options.headers["Authorization"] = "Bearer $token";
          return handler.next(options);
        } catch (e) {
          debugPrint(e.toString());
        }
        return handler.next(options);
      },
    ));
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        error: true,
        compact: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
    return dio;
  }
}
