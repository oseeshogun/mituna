import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseRepository {
  Future<Dio> client() async {
    final dio = Dio();
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    dio.options.headers["Authorization"] = "Bearer $token";
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
