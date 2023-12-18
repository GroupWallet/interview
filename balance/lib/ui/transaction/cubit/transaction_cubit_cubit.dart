import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/database/dao/groups_dao.dart';
import '../../../core/database/dao/transactions_dao.dart';
import '../../../core/database/database.dart';
import '../../../main.dart';

part 'transaction_cubit_state.dart';

class TransactionCubit extends Cubit<TransactionCubitState> {
  TransactionCubit() : super(TransactionCubitInitial());

  final TransactionsDao _transactionsDao = getIt.get<TransactionsDao>();
  final GroupsDao _groupsDao = getIt.get<GroupsDao>();

  List<Transaction> _transactions = [];

  void init(String groupId) {
    _transactionsDao.watchTransaction(groupId).listen((event) {
      _transactions = event;
      emit(TransactionCubitloaded(transactions: event));
    });
  }

  void editTransaction(
      {required String transactionId,
      required int newAmount,
      required String groupId}) async {
    int sum = 0;
    for (int i = 0; i < _transactions.length; i++) {
      if (_transactions[i].id == transactionId) {
        await _transactionsDao.adjustTransaction(
            newTransactionVal: newAmount, transactionId: transactionId);
        sum += newAmount;
      } else {
        sum += _transactions[i].amount;
      }
    }
    await _groupsDao.adjustBalance(sum, groupId);
  }
}
