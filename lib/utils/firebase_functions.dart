import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';

class FirebaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _isGoogleSignInInitialized = false;

  static Future<void> initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;
    await _googleSignIn.initialize(
      serverClientId: '799481483042-hh1ume638qvs47glja63rkdet4qnisiv.apps.googleusercontent.com',
    );
    _isGoogleSignInInitialized = true;
  }

  Future<UserCredential> signInWithGoogle() async {
    await initializeGoogleSignIn();

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    // Obtain the auth details from the request (synchronous now)
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
   Future<UserCredential?> signUpWithGoogle() async {
    try {
      // Open Google account selection
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn.instance.authenticate();

      // User cancelled the process
      if (googleUser == null) {
        return null;
      }

      // Get Google authentication information
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in / create Firebase account
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Firebase error: ${e.code}");
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static CollectionReference<UserModel> createUsersCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snap, op) {
        return UserModel.fromJson(snap.data()!);
      },
      toFirestore: (model, option) {
        return model.toJson();
      },
    );
  }

  static CollectionReference<EventModel> createEventsCollection() {
    return FirebaseFirestore.instance
        .collection("Events")
        .withConverter<EventModel>(
      fromFirestore: (snap, op) {
        return EventModel.fromJson(snap.data()!);
      },
      toFirestore: (model, option) {
        return model.toJson();
      },
    );
  }

  static void addEvent(EventModel model) {
    var collection = createEventsCollection();
    var docRef = collection.doc();
    model.id = docRef.id;
    docRef.set(model);
  }

  static updateEvent(EventModel model) {
    var collection = createEventsCollection();

    collection.doc(model.id).update(model.toJson());
  }

  static Stream<QuerySnapshot<EventModel>> getfavEvents() {
    var collection = createEventsCollection();

    return collection
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("isFavorite", isEqualTo: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<EventModel>> getEvents(String id) {
    var collection = createEventsCollection();
    if (id == "all") {
      return collection
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
    }
    return collection
        .where("category", isEqualTo: id)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static void addUserToDatabase(UserModel user) {
    var collection = createUsersCollection();
    var docRef = collection.doc(user.id);
    docRef.set(user);
  }

  static Future<UserModel?> readUser(String userId) async {
    var collection = createUsersCollection();
    DocumentSnapshot<UserModel> model = await collection.doc(userId).get();

    return model.data();
  }

  static void login(
      String username,
      String password,
      Function onSuccess,
      Function onError,
      ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      if (credential.user!.emailVerified) {
        onSuccess();
      } else {
        await FirebaseAuth.instance.signOut();
        onError("Please verify your email, check your mailbox");
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      onError(e.message);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  static void register(
      String name,
      String email,
      String password,
      Function onSuccess,
      Function onError,
      ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.updateDisplayName(name);
      await credential.user!.sendEmailVerification();
      //credential.user!.emailVerified;

      addUserToDatabase(
        UserModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          createdAt: DateTime.now().toString(),
        ),
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      onError(e.toString());
      print(e.toString());
    }
  }
  static Future<void> updateUserPhoto(String userId, String photoURL) {
    var collection = createUsersCollection();
    return collection.doc(userId).update({"photoURL": photoURL});
  }
}