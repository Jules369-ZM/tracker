import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_expense_tracker/auth/bloc/auth_bloc.dart';
import 'package:my_expense_tracker/home/cubit/cubit.dart';
import 'package:my_expense_tracker/home/widgets/widgets.dart';
import 'package:my_expense_tracker/utils/utils.dart';
import 'package:my_expense_tracker/widgets/widgets.dart';

/// {@template home_body}
/// Body of the HomePage.
///
/// Add what it does
/// {@endtemplate}
class HomeBody extends StatefulWidget {
  /// {@macro home_body}
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getExpenses();
  }

  @override
  Widget build(BuildContext context_) {
    final user = context_.watch<AuthBloc>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          dense: true,
          title: const Text(
            'Welcome',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          subtitle: Text(
            user.displayName.isEmpty ? user.email : 'Uknown',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await showModalBottomSheet<dynamic>(
            context: context_,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return BlocProvider.value(
                value: context_.read<HomeCubit>(),
                child: const AddExpense(),
              );
            },
          ).then((value) {
            context_.read<HomeCubit>().getExpenses();
            if (mounted) setState(() {});
          });
        },
        splashColor: Theme.of(context_).splashColor,
        backgroundColor: Theme.of(context_).colorScheme.primary,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == CurrentStatus.loading) {
            return const LoadingScreen();
          }
          final expenses = state.expenses;
          if (expenses.isEmpty) {
            return const MessageScreen(message: 'You have no Expenses');
          }
          print(expenses);
          return Padding(
            padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
            child: ListView.separated(
              // key: UniqueKey(),
              shrinkWrap: true,
              itemCount: expenses.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 8);
              },
              itemBuilder: (BuildContext context, int index) {
                final exp = expenses[index];
                final img = exp.image;
                return Dismissible(
                  key: Key(exp.id.toString()),
                  onDismissed: (item) {
                    context.read<HomeCubit>().deleteExpense(exp.id.toString());
                  },
                  child: ListTile(
                    // dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage:
                          img.isEmpty ? null : MemoryImage(base64.decode(img)),
                      foregroundImage: img.isNotEmpty
                          ? null
                          : const AssetImage('assets/wallet.png'),
                    ),
                    title: Text(exp.category),
                    subtitle: Text(exp.date),
                    trailing: Text(formatMoney(double.parse(exp.amount))),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
