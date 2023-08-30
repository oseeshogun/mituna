// Mocks generated by Mockito 5.4.2 from annotations
// in mituna/test/data/network/repositories/rewards_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mituna/data/network/entities/top_reward.dart' as _i6;
import 'package:mituna/data/network/entities/user_reward.dart' as _i8;
import 'package:mituna/data/network/services/create_reward.dart' as _i3;
import 'package:mituna/data/network/services/delete_rewards.dart' as _i9;
import 'package:mituna/data/network/services/top_rewards.dart' as _i5;
import 'package:mituna/data/network/services/user_reward.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:retrofit/retrofit.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeHttpResponse_0<T> extends _i1.SmartFake
    implements _i2.HttpResponse<T> {
  _FakeHttpResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CreateRewardService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreateRewardService extends _i1.Mock
    implements _i3.CreateRewardService {
  MockCreateRewardService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.HttpResponse<dynamic>> createReward(
    int? topaz,
    int? duration,
    String? date,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createReward,
          [
            topaz,
            duration,
            date,
          ],
        ),
        returnValue: _i4.Future<_i2.HttpResponse<dynamic>>.value(
            _FakeHttpResponse_0<dynamic>(
          this,
          Invocation.method(
            #createReward,
            [
              topaz,
              duration,
              date,
            ],
          ),
        )),
      ) as _i4.Future<_i2.HttpResponse<dynamic>>);
}

/// A class which mocks [TopRewardService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTopRewardService extends _i1.Mock implements _i5.TopRewardService {
  MockTopRewardService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.HttpResponse<List<_i6.TopRewardData>>> getTopRewards(
          String? period) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTopRewards,
          [period],
        ),
        returnValue:
            _i4.Future<_i2.HttpResponse<List<_i6.TopRewardData>>>.value(
                _FakeHttpResponse_0<List<_i6.TopRewardData>>(
          this,
          Invocation.method(
            #getTopRewards,
            [period],
          ),
        )),
      ) as _i4.Future<_i2.HttpResponse<List<_i6.TopRewardData>>>);
}

/// A class which mocks [UserRewardService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRewardService extends _i1.Mock implements _i7.UserRewardService {
  MockUserRewardService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.HttpResponse<_i8.UserRewardData>> getUserReward(
          String? period) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserReward,
          [period],
        ),
        returnValue: _i4.Future<_i2.HttpResponse<_i8.UserRewardData>>.value(
            _FakeHttpResponse_0<_i8.UserRewardData>(
          this,
          Invocation.method(
            #getUserReward,
            [period],
          ),
        )),
      ) as _i4.Future<_i2.HttpResponse<_i8.UserRewardData>>);
}

/// A class which mocks [DeleteRewardsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeleteRewardsService extends _i1.Mock
    implements _i9.DeleteRewardsService {
  MockDeleteRewardsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.HttpResponse<dynamic>> deleteRewards() => (super.noSuchMethod(
        Invocation.method(
          #deleteRewards,
          [],
        ),
        returnValue: _i4.Future<_i2.HttpResponse<dynamic>>.value(
            _FakeHttpResponse_0<dynamic>(
          this,
          Invocation.method(
            #deleteRewards,
            [],
          ),
        )),
      ) as _i4.Future<_i2.HttpResponse<dynamic>>);
}
