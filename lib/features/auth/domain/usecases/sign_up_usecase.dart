// lib/features/auth/domain/usecases/sign_up_usecase.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  // Usecase ini akan menerima email dan password, lalu memanggil repository
  Future<User?> call({required String email, required String password}) {
    // Pastikan method di repository juga mengembalikan User?
    return _repository.createUserWithEmailAndPassword(email, password);
  }
}
