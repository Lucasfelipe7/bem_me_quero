import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? usuario;
  bool isLoading = true;

  AuthService() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      usuario = user;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      isLoading = false;
      notifyListeners();

      return credential;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      String errorMessage = 'Erro ao fazer login';

      if (e.code == 'user-not-found') {
        errorMessage = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta';
      }
      throw Exception(errorMessage);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    usuario = null;
    notifyListeners();
  }
}