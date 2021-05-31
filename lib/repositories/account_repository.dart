import 'package:authentication_bloc/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class BaseAccountRepository {
  streamMyAccount();
  getAccount(String id);
  createAccount(Account account);
  updateAccount(Account account);
  deleteAccount(Account account);
}

class AccountRepository extends BaseAccountRepository {
  AccountRepository(this.uid);

  final String uid;

  final refAccount = FirebaseFirestore.instance.collection('accounts').withConverter<Account>(
        fromFirestore: (snapshot, _) => Account.fromMap(snapshot.data()!),
        toFirestore: (account, _) => account.toMap(),
      );

  @override
  createAccount(Account account) => refAccount.doc(refAccount.id).set(account);

  @override
  deleteAccount(Account account) => refAccount.doc(account.uid).delete();

  @override
  updateAccount(Account account) => refAccount.doc(refAccount.id).set(account);

  @override
  getAccount(String id) => refAccount.doc(id).get();

  @override
  streamMyAccount() {
    // TODO: implement streamMyAccount
    throw UnimplementedError();
  }
}
