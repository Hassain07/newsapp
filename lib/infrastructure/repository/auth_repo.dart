import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapp/domain/data/login_data.dart';
import 'package:newsapp/domain/data/register_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/domain/models/user_model.dart';
import 'package:newsapp/domain/utils/email_validator.dart';

class UserNameUnavailable implements Exception {}

class UserNameNotRegistered implements Exception {}

// class InvalidEmail implements Exception {}

class AuthRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('user');
  DocumentReference _docRef(String uid) => usersCollection.doc(uid);
  Future<UserModel?> getUserModel(String uid) async {
    final doc = await _docRef(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(uid, doc.data()!);
    } else
      return null;
  }

  Future<List<UserModel>> getUserByUserName(String uName) async {
    final qSnap =
        await usersCollection.where('username', isEqualTo: uName).get();
    if (qSnap.size > 0) {
      final users =
          qSnap.docs.map((e) => UserModel.fromMap(e.id, e.data())).toList();
      return users;
    } else
      return [];
  }

  Future<LoginData?> register(RegisterData data) async {
    try {
      final temp = await getUserByUserName(data.uName!);
      if (temp.isEmpty) {
        throw UserNameUnavailable();
      }
      final User? user = (await auth.createUserWithEmailAndPassword(
        email: data.email!,
        password: data.password1!,
      ))
          .user;
      if (user != null) {
        final uModel = UserModel(
            uid: user.uid,
            username: data.uName!,
            email: data.email!,
            location: data.location!);
        await _docRef(uModel.uid).set(uModel.toMap());
        return LoginData(uName: data.email!, password: data.password1!);
      } else {
        return null;
      }
    } catch (e) {
      throw e;
      // switch (e.code) {
      //   case "email-already-in-use":
      //     throw EmailAlreadyRegistered();

      //   case "invalid-email":
      //     throw e;
      //   case "weak-password":
      //     throw e;
      //   default:
      // }
    }
  }

  Future<UserModel?> signIn(LoginData data) async {
    try {
      bool isMail = isEmail(data.uName);
      UserModel? userModel;
      if (!isMail) {
        final temp = await getUserByUserName(data.uName);
        if (temp.isEmpty) {
          throw UserNameNotRegistered();
        }
        userModel = temp.first;
      }

      final User? user = (await auth.signInWithEmailAndPassword(
        email: isMail ? data.uName : userModel!.email,
        password: data.password,
      ))
          .user;

      return isMail ? await getUserModel(user!.uid) : userModel;
    } catch (e) {
      throw e;
    }
  }
}
