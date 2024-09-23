
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/core/constant/constants.dart';
import 'package:test_app/core/constant/firebase_constants.dart';
import 'package:test_app/core/failure.dart';
import 'package:test_app/core/providers/firebase_provider.dart';
import 'package:test_app/core/type_defs.dart';
import 'package:test_app/models/user_model.dart';

final authRepositoryProvider = Provider(
         (ref)=>AuthRepository(
           firestore: ref.read(firestoreProvider), 
           firebaseauth: ref.read(authProvider), 
           googlesignin: ref.read(googleSignInProvider),
           ),
        );

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseauth,
    required GoogleSignIn googlesignin,
  }) : _firebaseAuth = firebaseauth,
       _firestore = firestore,
       _googleSignIn = googlesignin;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChanges =>  _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle()async{
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential = await _firebaseAuth.signInWithCredential(credential);
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      String? deviceToken = await messaging.getToken();

       UserModel userModel;

      if(userCredential.additionalUserInfo!.isNewUser){
        userModel = UserModel(
          name: userCredential.user!.displayName?? 'no name',
          profilePic: userCredential.user!.photoURL?? Constants.avatarDefault,
          banner: Constants.bannerDefault, 
          uid: userCredential.user!.uid, 
          isAuthenticated: true, 
          karma: 0, 
          awards: [
            'aweseomeAns',
            'glod',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ], deviceToken: deviceToken?? 'null',
        );

        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        
      }else{
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    }  on FirebaseException catch (e) {
      throw e.message!;
    } 
    catch (e) {
      return left(Failure(e.toString()));
    }
  }
Stream<UserModel> getUserData(String uid){
  return _users.doc(uid).snapshots().map((event)=> UserModel.fromMap(event.data() as Map<String, dynamic>));
}
Stream<List<UserModel>> getAllUsers(){
  return _users.snapshots().map((event)=> event.docs.map((e)=> UserModel.fromMap(e.data() as Map<String, dynamic>)).toList());
}

}


