import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/addPlans_entity.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/entities/freeSpace_entity.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/usecases/addPlans_usecase.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard_bloc/dashboard_bloc.dart';

part 'add_plans_event.dart';
part 'add_plans_state.dart';

class AddPlansBloc extends Bloc<AddPlansEvent, AddPlansState> {
  final GenerateSecretsUsecase generateSecretsUsecase;
  final AddUserUsecase addUserUsecase;
  final CreateProofUsecase createProofUsecase;
  final VerifyUsecase verifyUsecase;
   final FreeSpaceUsecase freeSpaceUsecase;

  AddPlansBloc(this.generateSecretsUsecase,this.addUserUsecase, this.createProofUsecase,this.verifyUsecase,this.freeSpaceUsecase) : super(AddPlansInitial()) {
    on<GenerateSecretsEvent>(_handleGenerateSecrets); 
    on<addUserEvent>(_handleAddUser);
    on<createProofEvent>(_handleProof);
    on<verifyuserEvent>(_handleVerifyUser);
    on<freeSpaceEvent>(_handleFreeSpace);

  }

  Future<void> _handleGenerateSecrets(
      GenerateSecretsEvent event, Emitter<AddPlansState> emit) async {
    emit(AddPlansLoading());

    final failureOrGenerateSecrets = await generateSecretsUsecase();
    failureOrGenerateSecrets.fold(
      (failure) => emit(AddPlansFailure(failure.toString())),
      (generateSecrets) => emit(GenerateSecretsSuccess(generateSecrets)),
    );
  }

  Future<void> _handleAddUser(
      addUserEvent event, Emitter<AddPlansState> emit) async {
    emit(AddPlansLoading());

    final failureOrAddUser = await addUserUsecase(UseCaseParams(
          did: event.did,
          owner: event.owner,
          nullifier: event.nullifier,
          commitment: event.commitment));
        
    failureOrAddUser.fold(
      (failure) => emit(AddPlansFailure(failure.toString())),
      (addUser) => emit(AddUserSuccess(addUser)),
    );
  }

  Future<void> _handleProof(
      createProofEvent event, Emitter<AddPlansState> emit) async {
    emit(AddPlansLoading());

    final failureOrproof = await createProofUsecase(CreatProofParams(
          account: event.owner,
          txhash: event.txhash

         ));

          failureOrproof.fold(
      (failure) => emit(AddPlansFailure(failure.toString())),
      (proof) => emit(CreateProof(proof)),
    );
         
          
  }


  Future<void> _handleVerifyUser(
      verifyuserEvent event, Emitter<AddPlansState> emit) async {
    emit(AddPlansLoading());
    final failureOrVerifyUser = await verifyUsecase(VerifyParams(
          a: event.A,
          b: event.B,

          c: event.C,
          input: event.Inputs,
          owner: event.Owner,
          did: event.Did
          ));
         failureOrVerifyUser.fold(
      (failure) => emit(AddPlansFailure(failure.toString())),
      (verify) => emit(VerifyProof(verify)),
    );  
  }

  Future<void> _handleFreeSpace(
      freeSpaceEvent event, Emitter<AddPlansState> emit) async {
    emit(AddPlansLoading());
    final failureOrFreeSpace = await freeSpaceUsecase(FreeSpaceParams(

          did: event.did,
          owner: event.owner
          
          ));
         failureOrFreeSpace.fold(
      (failure) => emit(AddPlansFailure(failure.toString())),
      (freeSpace) => emit(FreeSpaceAdded(freeSpace)),
    );  
  }


}



