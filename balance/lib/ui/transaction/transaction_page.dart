import 'package:balance/ui/transaction/cubit/transaction_cubit_cubit.dart';
import 'package:balance/ui/transaction/widgets/transaction_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionPageProvider extends StatelessWidget {
  const TransactionPageProvider({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => TransactionCubit()..init(groupId)),
      child: const TransactionPage(),
    );
  }
}

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<TransactionCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Group transactions"),
      ),
      body: BlocBuilder<TransactionCubit, TransactionCubitState>(
        builder: (context, state) {
          if (state is TransactionCubitloaded) {
            return SingleChildScrollView(
              child: Column(children: [
                ...state.transactions.map(
                  (e) => ListTile(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => TransactionDialog(
                        oldAmount: e.amount,
                        transactionId: e.id,
                        groupId: e.groupId,
                        bloc: bloc,
                      ),
                    ),
                    title: Text(e.amount.toString()),
                    trailing: Text(e.createdAt.toString()),
                  ),
                )
              ]),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
