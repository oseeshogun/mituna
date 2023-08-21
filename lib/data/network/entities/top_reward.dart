import 'dart:async';

import 'package:chopper/chopper.dart';

class TopRewardData implements Converter {
  final int count;
  final int id;

  const TopRewardData({
    required this.count,
    required this.id,
  });

  @override
  FutureOr<Request> convertRequest(Request request) {
    return request;
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(Response response) {
    final body = (response.body as List).map((element) {
      final data = Map<String, dynamic>.from(element);
      return {...data, 'id': data['_id']};
    }).toList();
    return response.copyWith(body: body as dynamic);
  }
}
