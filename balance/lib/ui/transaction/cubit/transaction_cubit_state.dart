part of 'transaction_cubit_cubit.dart';

@immutable
sealed class TransactionCubitState {}

final class TransactionCubitInitial extends TransactionCubitState {}

final class TransactionCubitloaded extends TransactionCubitState {
  final List<Transaction> transactions;
  TransactionCubitloaded({required this.transactions});
}
