import 'package:balance/core/database/database.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../tables/transactions.dart';

part 'transactions_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<Database>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future insert(String groupId, DateTime createdAt, int amount) {
    return into(transactions).insert(
      TransactionsCompanion.insert(
        id: const Uuid().v1(),
        groupId: groupId,
        createdAt: createdAt,
        amount: Value(amount),
      ),
    );
  }

  Future adjustTransaction({
    required int newTransactionVal,
    required String transactionId,
  }) async {
    final companion = TransactionsCompanion(amount: Value(newTransactionVal));
    return (update(transactions)..where((tbl) => tbl.id.equals(transactionId)))
        .write(companion);
  }

  Stream<List<Transaction>> watchTransaction(String groupId) {
    return (select(transactions)..where((tbl) => tbl.groupId.equals(groupId)))
        .watch();
  }
}
