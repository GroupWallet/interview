import 'dart:ffi';

import 'package:balance/core/database/database.dart';
import 'package:balance/core/database/tables/transactions.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

part 'transactions_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<Database>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

//  Future insert(String name) {
//     return into(transactions).insert(GroupsCompanion.insert(id: const Uuid().v1(), name: name));
//   }

  // Future insert(String groupId, int amount){
  //   return into(transactions).insert(TransactionsCompanion.insert(
  //       id: const Uuid().v1(), createdAt: DateTime.now(), groupId: groupId, amount:Value(amount)));
  // }
  
   Future updateAmount(int amount, String id) async {
    final companion = TransactionsCompanion(amount: Value(amount));
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(companion);
  }
  Future insert(String groupId, int amount){
    print('add transactions');
    return into(transactions).insert(TransactionsCompanion.insert(id: const Uuid().v1(), createdAt: DateTime.now(), groupId: groupId, amount: Value(amount)));
  }

  Stream<List<Transaction>> watch() => select(transactions).watch();


   
  // get Transactions By Group Id 
  Stream<List<Transaction>> watchGroup(String groupId) {
    return (select(transactions)..where((tbl) => tbl.groupId.equals(groupId))).watch();
  }

  // Stream<Transaction?> watchGroup(String groupId) {
  //   return (select(transactions)..where((tbl) => tbl.id.equals(groupId))).watchSingleOrNull();
  // }
}
