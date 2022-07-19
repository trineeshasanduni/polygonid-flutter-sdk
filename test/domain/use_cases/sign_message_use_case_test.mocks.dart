// Mocks generated by Mockito 5.2.0 from annotations
// in polygonid_flutter_sdk/test/domain/use_cases/sign_message_use_case_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:polygonid_flutter_sdk/domain/identity/entities/circuit_data.dart'
    as _i5;
import 'package:polygonid_flutter_sdk/domain/identity/entities/identity.dart'
    as _i2;
import 'package:polygonid_flutter_sdk/domain/identity/repositories/identity_repository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeIdentity_0 extends _i1.Fake implements _i2.Identity {}

/// A class which mocks [IdentityRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIdentityRepository extends _i1.Mock
    implements _i3.IdentityRepository {
  MockIdentityRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<String> createIdentity({String? privateKey}) =>
      (super.noSuchMethod(
          Invocation.method(#createIdentity, [], {#privateKey: privateKey}),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
  @override
  _i4.Future<_i2.Identity> getIdentity({String? privateKey}) => (super
          .noSuchMethod(
              Invocation.method(#getIdentity, [], {#privateKey: privateKey}),
              returnValue: Future<_i2.Identity>.value(_FakeIdentity_0()))
      as _i4.Future<_i2.Identity>);
  @override
  _i4.Future<String> signMessage({String? identifier, String? message}) =>
      (super.noSuchMethod(
          Invocation.method(
              #signMessage, [], {#identifier: identifier, #message: message}),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
  @override
  _i4.Future<void> removeIdentity({String? identifier}) => (super.noSuchMethod(
      Invocation.method(#removeIdentity, [], {#identifier: identifier}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<String?> getCurrentIdentifier() =>
      (super.noSuchMethod(Invocation.method(#getCurrentIdentifier, []),
          returnValue: Future<String?>.value()) as _i4.Future<String?>);
  @override
  _i4.Future<void> removeCurrentIdentity() =>
      (super.noSuchMethod(Invocation.method(#removeCurrentIdentity, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<String> getAuthToken(
          {String? identifier,
          _i5.CircuitData? circuitData,
          String? message}) =>
      (super.noSuchMethod(
          Invocation.method(#getAuthToken, [], {
            #identifier: identifier,
            #circuitData: circuitData,
            #message: message
          }),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
}
