import 'package:balance/ui/transaction/cubit/transaction_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({
    super.key,
    required this.oldAmount,
    required this.transactionId,
    required this.groupId,
    required this.bloc,
  });
  final int oldAmount;
  final String transactionId;
  final String groupId;
  final TransactionCubit bloc;

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Row(children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
            ],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              suffixText: "\$",
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              final amount = int.parse(_controller.text);
              widget.bloc.editTransaction(
                  transactionId: widget.transactionId,
                  newAmount: widget.oldAmount < 0 ? -amount : amount,
                  groupId: widget.groupId);
              Navigator.pop(context);
            },
            child: Text(
                widget.oldAmount < 0 ? "Change expense" : "Change income")),
      ]),
    );
  }
}
