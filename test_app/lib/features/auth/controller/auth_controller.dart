
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/core/utils.dart';
import 'package:test_app/features/auth/repository/auth_repository.dart';
import 'package:test_app/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref)=> null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref)=>AuthController(
    authRepository: ref.watch(authRepositoryProvider), 
    ref: ref),
    );

final authStateChangeProvider = StreamProvider((ref){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;

});
final getAllUsers = StreamProvider((ref){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getAllUsers();

});

final getUserDataProvider = StreamProvider.family((ref, String uid){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController( {required AuthRepository authRepository, required Ref ref})
      :_authRepository = authRepository,
      _ref = ref,
      super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async{
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l)=>showSnackbar(context, l.message), 
      (userModel)=> _ref.read(userProvider.notifier).update((state)=> userModel),
    );
  }

  Stream<UserModel> getUserData(String uid){
    return _authRepository.getUserData(uid);
  }
  Stream<List<UserModel>> getAllUsers(){
    return _authRepository.getAllUsers();
  }

}