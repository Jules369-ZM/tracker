// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:developer';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

import '../utils.dart';

part 'firebase_state.dart';

bool shouldUseFirebaseEmulator = false;

late final FirebaseApp firebaseApp;
late final fire_auth.FirebaseAuth authInstance;
late final FirebaseFirestore firebaseFirestore;

class FirebaseCubit extends Cubit<FirebaseState> {
  FirebaseCubit({this.authRepo, this.servicesRepo})
      : super(const FirebaseState());
  final AuthRepo? authRepo;
  final ServicesRepo? servicesRepo;

  ///Notifies about changes to the user's sign-in state
  ///(such as sign-in ?or sign-out).
  StreamSubscription<fire_auth.User?>? firebaseAuthStreamSubscription;
  @override
  Future<void> close() {
    firebaseAuthStreamSubscription?.cancel();
    return super.close();
  }

  /// monitors authStateChanges
  Future<void> monitorAuthStateChanges(
    FirebaseApp app,
    fire_auth.FirebaseAuth auth,
  ) async {
    firebaseAuthStreamSubscription = auth.authStateChanges().listen((fireUser) {
      log('firebaseAuthStreamSubscription');
      log('fireUser = $fireUser');

      if (fireUser != null) {
        emit(
          state.copyWith(
            message: 'Auth State Changed',
            status: CurrentStatus.signedIn,
            fireUser: fireUser,
            auth: auth,
            app: app,
          ),
        );
      } else {
        emit(
          state.copyWith(
            message: 'Auth State Changed user null',
            status: CurrentStatus.signedOut,
            fireUser: fireUser,
            auth: auth,
            app: app,
          ),
        );
      }
    });
  }

  /// add record to firbase
  FutureOr<void> addDocument(
    JsonMap data,
    String collectionPath,
  ) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));

      final docCollectionRef =
          firebaseFirestore.collection(collectionPath).doc();
      await docCollectionRef.set(data);
      emit(
        state.copyWith(
          status: CurrentStatus.success,
          message: 'success',
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CurrentStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  /// read a list record from firbase
  Stream<List<JsonMap>> readDocuments({required String collectionPath}) =>
      firebaseFirestore.collection(collectionPath).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc.data()).toSet().toList(),
          );

  // ignore: comment_references
  /// read records [where] from firbase
  Future<List<JsonMap>> readDocumentsWhere({
    required String collectionPath,
    required String field,
    required String value,
    required String mapKey,
    required String message,
  }) async {
    emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
    final documents = <Map<String, dynamic>>[];
    try {
      final querySnapshot = await firebaseFirestore
          .collection(collectionPath)
          .where(
            field,
            isEqualTo: value,
          )
          .get();
      final data_ = querySnapshot.docs.map((e) => e.data()).toList();
      documents.addAll(data_);
      final data = <String, dynamic>{mapKey: documents};
      if (state.data != null) {
        data.addAll(state.data!);
      }
      emit(
        state.copyWith(
          data: data,
          message: message,
          status: CurrentStatus.success,
        ),
      );
    } catch (e) {
      log('Error getting documents: $e');
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
    return documents;
  }

  // Function to get documents based on user UID
  Future<List<Map<String, dynamic>>> getDocumentsByUserId({
    required String collectionPath,
    required String userUid,
    required String mapKey,
    required String message,
  }) async {
    emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
    final documents = <Map<String, dynamic>>[];

    try {
      final querySnapshot = await firebaseFirestore
          .collection(collectionPath)
          .where('userUid', isEqualTo: userUid)
          .get();

      for (final document in querySnapshot.docs) {
        documents.add(document.data());
      }
      final data = <String, dynamic>{mapKey: documents};
      if (state.data != null) {
        data.addAll(state.data!);
      }
      emit(
        state.copyWith(
          data: data,
          message: message,
          status: CurrentStatus.success,
        ),
      );
    } catch (e) {
      log('Error getting documents: $e');
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
    return documents;
  }

  /// read one record from firbase
  Future<JsonMap?> readDocument({
    required String collectionPath,
    required String id,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

  /// update record in firbase
  Future<void> updateDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    await ref.update(data);
  }

  /// replace record in firbase
  Future<void> replaceDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    await ref.set(data);
  }

  /// delete record in firbase
  Future<void> deleteDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    await ref.delete();
  }
}

abstract class OurDatabase {
  static final db = firebaseFirestore;

  static Future<void> create(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(document).set(data);
  }

  static Future<Map<String, dynamic>?> read(
    String collection,
    String document,
  ) async {
    final snapshot = await db.collection(collection).doc(document).get();
    return snapshot.data();
  }

  static Future<void> update(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(document).update(data);
  }

  static Future<void> replace(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(document).set(data);
  }

  static Future<void> delete(String collection, String document) async {
    await db.collection(collection).doc(document).delete();
  }
}
