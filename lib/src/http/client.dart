import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mituna/src/utils/logger.dart';

import 'exceptions.dart';

class ApiClient {
  final String baseUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ApiClient(this.baseUrl);

  Future<String?> _getToken() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return await currentUser.getIdToken();
    }
    return null;
  }

  Future<dynamic> get(String path, [Map<String, dynamic>? queryParameters]) async {
    final url = Uri.https(baseUrl, path, queryParameters);
    final token = await _getToken();
    final data = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).then((response){
      if (response.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException();
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw ServerException();
      } else if (response.statusCode == HttpStatus.badRequest) {
        throw BadRequestException();
      } else if (response.statusCode == HttpStatus.notFound) {
        throw NotFoundException();
      }
      return jsonDecode(response.body);
    }).catchError((error){
      if (error is SocketException) {
        throw NoConnectionException();
      } else if (error is FormatException) {
        throw DataParsingException();
      }
      throw error;
    });
    return data;
  }

  Future<dynamic> post(String path, dynamic body) async {
    final url = Uri.https(baseUrl, path);
    final token = await _getToken();
    final data = await http.post(url,  body: jsonEncode(body), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).then((response) {
      if (response.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException();
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw ServerException();
      } else if (response.statusCode == HttpStatus.badRequest) {
        throw BadRequestException();
      } else if (response.statusCode == HttpStatus.notFound) {
        throw NotFoundException();
      }
      logger.i(response.body);
      return jsonDecode(response.body);
    }).catchError((error) {
      if (error is SocketException) {
        throw NoConnectionException();
      } else if (error is FormatException) {
        throw DataParsingException();
      }
      throw error;
    });
    return data;
  }

  Future<dynamic> delete(String path) async {
    final url = Uri.https(baseUrl, path);
    final token = await _getToken();
    final data = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).then((response) {
      if (response.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException();
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw ServerException();
      } else if (response.statusCode == HttpStatus.badRequest) {
        throw BadRequestException();
      } else if (response.statusCode == HttpStatus.notFound) {
        throw NotFoundException();
      }
      return jsonDecode(response.body);
    }).catchError((error) {
      if (error is SocketException) {
        throw NoConnectionException();
      } else if (error is FormatException) {
        throw DataParsingException();
      }
      throw error;
    });
    return data;
  }
}