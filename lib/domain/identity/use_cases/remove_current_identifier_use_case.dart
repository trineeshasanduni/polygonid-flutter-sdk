import '../../common/domain_logger.dart';
import '../../common/use_case.dart';
import '../repositories/identity_repository.dart';

/// TODO: Remove this UC when we support multiple identity
class RemoveCurrentIdentityUseCase extends FutureUseCase<void, void> {
  final IdentityRepository _identityRepository;

  RemoveCurrentIdentityUseCase(this._identityRepository);

  @override
  Future<void> execute({void param}) {
    return _identityRepository
        .removeCurrentIdentity()
        .then((_) => logger().i(
            "[RemoveCurrentIdentifierUseCase] Current identity has been removed"))
        .catchError((error) {
      logger().e("[RemoveCurrentIdentifierUseCase] Error: $error");

      throw error;
    });
  }
}
