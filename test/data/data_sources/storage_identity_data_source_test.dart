import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/constants.dart';
import 'package:polygonid_flutter_sdk/data/identity/data_sources/storage_identity_data_source.dart';
import 'package:polygonid_flutter_sdk/data/identity/data_sources/storage_key_value_data_source.dart';
import 'package:polygonid_flutter_sdk/data/identity/dtos/identity_dto.dart';
import 'package:polygonid_flutter_sdk/domain/identity/exceptions/identity_exceptions.dart';
import 'package:sembast/sembast.dart';

import 'storage_identity_data_source_test.mocks.dart';

// Data
const privateKey = "thePrivateKey";
const identifier = "theIdentifier";
const authClaim = "theAuthClaim";
final mockGet = {
  'privateKey': privateKey,
  'identifier': identifier,
  'authClaim': authClaim
};
final identityDTO = IdentityDTO.fromJson(mockGet);
final exception = Exception();

// Dependencies
MockDatabase database = MockDatabase();
MockIdentityStoreRefWrapper storeRefWrapper = MockIdentityStoreRefWrapper();
MockStorageKeyValueDataSource storageKeyValueDataSource =
    MockStorageKeyValueDataSource();

// Tested instance
StorageIdentityDataSource dataSource = StorageIdentityDataSource(
    database, storeRefWrapper, storageKeyValueDataSource);

@GenerateMocks([Database, IdentityStoreRefWrapper, StorageKeyValueDataSource])
void main() {
  group("Get identity", () {
    test(
        "Given an identifier with an already stored identity, when I call getIdentity, then I expect an IdentityDTO to be returned",
        () async {
      // Given
      when(storeRefWrapper.get(any, any))
          .thenAnswer((realInvocation) => Future.value(mockGet));

      // When
      expect(await dataSource.getIdentity(identifier: identifier), identityDTO);

      // Then
      var captured =
          verify(storeRefWrapper.get(captureAny, captureAny)).captured;
      expect(captured[0], database);
      expect(captured[1], identifier);
    });

    test(
        "Given an identifier with no stored identity, when I call getIdentity, then I expect a null to be returned",
        () async {
      // Given
      when(storeRefWrapper.get(any, any))
          .thenAnswer((realInvocation) => Future.value(null));

      // When
      await dataSource
          .getIdentity(identifier: identifier)
          .then((_) => null)
          .catchError((error) {
        expect(error, isA<UnknownIdentityException>());
        expect(error.identifier, identifier);
      });

      // Then
      var captured =
          verify(storeRefWrapper.get(captureAny, captureAny)).captured;
      expect(captured[0], database);
      expect(captured[1], identifier);
    });

    test(
        "Given an identifier, when I call getIdentity and an error occurred, then I expect an exception to be thrown",
        () async {
      // Given
      when(storeRefWrapper.get(any, any))
          .thenAnswer((realInvocation) => Future.error(exception));

      // When
      await expectLater(
          dataSource.getIdentity(identifier: identifier), throwsA(exception));

      // Then
      var captured =
          verify(storeRefWrapper.get(captureAny, captureAny)).captured;
      expect(captured[0], database);
      expect(captured[1], identifier);
    });
  });

  group("Store identity", () {
    setUp(() {
      when(storageKeyValueDataSource.remove(
              key: anyNamed('key'), database: anyNamed('database')))
          .thenAnswer((realInvocation) => Future.value(identifier));
      when(storageKeyValueDataSource.store(
              key: anyNamed('key'),
              value: anyNamed('value'),
              database: anyNamed('database')))
          .thenAnswer((realInvocation) => Future.value(null));
    });

    test(
        "Given an identifier and an identity, when I call storeIdentity, then I expect the process to be completed",
        () async {
      // Given
      when(storeRefWrapper.put(any, any, any))
          .thenAnswer((realInvocation) => Future.value(mockGet));

      // When
      await expectLater(
          dataSource.storeIdentityTransact(
              transaction: database,
              identifier: identifier,
              identity: identityDTO),
          completes);

      // Then
      var capturedPut =
          verify(storeRefWrapper.put(captureAny, captureAny, captureAny))
              .captured;
      expect(capturedPut[0], database);
      expect(capturedPut[1], identifier);
      expect(capturedPut[2], identityDTO.toJson());

      var capturedRemove = verify(storageKeyValueDataSource.remove(
              key: captureAnyNamed('key'),
              database: captureAnyNamed('database')))
          .captured;
      expect(capturedRemove[0], currentIdentifierKey);
      expect(capturedRemove[1], database);

      var capturedStore = verify(storageKeyValueDataSource.store(
              key: captureAnyNamed('key'),
              value: captureAnyNamed('value'),
              database: captureAnyNamed('database')))
          .captured;
      expect(capturedStore[0], currentIdentifierKey);
      expect(capturedStore[1], identifier);
      expect(capturedStore[2], database);
    });

    test(
        "Given an identifier and an identity, when I call storeIdentity and an error occurred, then I expect an exception to be thrown",
        () async {
      // Given
      when(storeRefWrapper.put(any, any, any))
          .thenAnswer((realInvocation) => Future.error(exception));

      // When
      await expectLater(
          dataSource.storeIdentityTransact(
              transaction: database,
              identifier: identifier,
              identity: identityDTO),
          throwsA(exception));

      // Then
      var captured =
          verify(storeRefWrapper.put(captureAny, captureAny, captureAny))
              .captured;
      expect(captured[0], database);
      expect(captured[1], identifier);
      expect(captured[2], identityDTO.toJson());

      var capturedRemove = verify(storageKeyValueDataSource.remove(
              key: captureAnyNamed('key'),
              database: captureAnyNamed('database')))
          .captured;
      expect(capturedRemove[0], currentIdentifierKey);
      expect(capturedRemove[1], database);

      verifyNever(storageKeyValueDataSource.store(
          key: captureAnyNamed('key'),
          value: captureAnyNamed('value'),
          database: captureAnyNamed('database')));
    });
  });
}
