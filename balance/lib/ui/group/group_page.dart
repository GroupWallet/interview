import 'package:balance/core/database/dao/groups_dao.dart';
import 'package:balance/core/database/dao/transactions_dao.dart';
import 'package:balance/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupPage extends StatefulWidget {
  final String groupId;
  const GroupPage(this.groupId, {super.key});

  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late final GroupsDao _groupsDao = getIt.get<GroupsDao>();
  late final TransactionsDao _transactionsDao = getIt.get<TransactionsDao>();

  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();
  final _editController = TextEditingController();

  Future<void> _displayTextInputDialog(
      BuildContext context, int amount, String id, int balance) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Amount'),
            content: TextFormField(
              controller: _editController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9, ^-\d+$ ]"))
              ],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                suffixText: "\$",
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  var inputValue = int.parse(_editController.text);

                  if (inputValue == amount) {
                    print('do nothing');
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue < 0 &&
                      amount < 0 &&
                      inputValue > amount) {
                    var totalValue = inputValue - (amount);
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + totalValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue < 0 &&
                      amount < 0 &&
                      inputValue < amount) {
                    var totalValue = inputValue - (amount);
                    // print(10 + (totalValue));

                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + (totalValue), widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue > 0 && amount < 0) {
                    var convertedAmount = amount.abs();
                    var totalValue = inputValue + convertedAmount;
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + totalValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue > 0 &&
                      amount > 0 &&
                      inputValue > amount) {
                    var totalValue = inputValue - amount;

                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + totalValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue > 0 &&
                      amount > 0 &&
                      inputValue < amount) {
                    var totalValue = inputValue - amount;
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + totalValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue < 0 && amount > 0) {
                    var totalValue = inputValue + (-amount);
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + totalValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue == 0 && amount > 0) {
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(balance - amount, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue == 0 && amount < 0) {
                    var convertedAmount = amount.abs();

                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + convertedAmount, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue > 0 && amount == 0) {
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + inputValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  } else if (inputValue < 0 && amount == 0) {
                    _transactionsDao.updateAmount(inputValue, id);
                    _groupsDao.adjustBalance(
                        balance + inputValue, widget.groupId);
                    return setState(() {
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Group details"),
        ),
        body: StreamBuilder(
          stream: _groupsDao.watchGroup(widget.groupId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }

            final balance = snapshot.data?.balance ?? 0;

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(snapshot.data?.name ?? ""),
                Text(snapshot.data?.balance.toString() ?? ""),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _incomeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      onPressed: () {
                        final amount = int.parse(_incomeController.text);
                        final balance = snapshot.data?.balance ?? 0;
                        _groupsDao.adjustBalance(
                            balance + amount, widget.groupId);
                        _transactionsDao.insert(widget.groupId, amount);
                        _incomeController.text = "";
                      },
                      child: Text("Add income")),
                ]),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expenseController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      onPressed: () {
                        final amount = int.parse(_expenseController.text);
                        final balance = snapshot.data?.balance ?? 0;
                        _transactionsDao.insert(widget.groupId, -amount);
                        _groupsDao.adjustBalance(
                            balance - amount, widget.groupId);
                        _expenseController.text = "";
                      },
                      child: Text("Add expense")),
                ]),
                const Padding(
                    padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                    child: Text(
                      'Transactions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                StreamBuilder(
                    stream: _transactionsDao.watchGroup(widget.groupId),
                    builder: (context, snapshot) {
                      print('test!');
                      print(snapshot.data);
                      if (!snapshot.hasData) {
                        return const Text("Loading...");
                      }
                      return Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.requireData.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 80,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column( 
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                           Text(
                                          snapshot.requireData[index].createdAt.toString(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                         Text(
                                          snapshot.requireData[index].amount
                                              .toString(),
                                          style: TextStyle(fontSize: 18),
                                        )
                                        ],),
                                        ElevatedButton(
                                            onPressed: () {
                                              _editController.text = snapshot
                                                  .requireData[index].amount
                                                  .toString();
                                              _displayTextInputDialog(
                                                  context,
                                                  snapshot.requireData[index]
                                                      .amount,
                                                  snapshot
                                                      .requireData[index].id,
                                                  balance);
                                            },
                                            child: const Text('Edit'))
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    })
              ],
            );
          },
        ),
      );

  // @pragma('vm:entry-point')
  //  Route<Object?> _dialogBuilder(
  //     BuildContext context, Object? arguments) {
  //   return DialogRoute<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Edit'),
  //         content: Expanded(
  //                   child: TextFormField(
  //                     controller: _incomeController,
  //                     keyboardType:
  //                         const TextInputType.numberWithOptions(decimal: true),
  //                     inputFormatters: [
  //                       FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
  //                     ],
  //                     decoration: const InputDecoration(
  //                       contentPadding: EdgeInsets.symmetric(vertical: 10),
  //                       suffixText: "\$",
  //                     ),
  //                   ),
  //                 ),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('Disable'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('Enable'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
