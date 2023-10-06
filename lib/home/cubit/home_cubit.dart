import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_expense_tracker/utils/utils.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._sRepo) : super(const HomeState());
  final ServicesRepo _sRepo;

  Future<FutureOr<void>> getExpenseCategory() async {
    emit(state.copyWith(status: CurrentStatus.loading));
    var expenseCategory = await _sRepo.getExpenseCategory();
    if (expenseCategory.isEmpty) {
      await insertDefaultCategory();
      expenseCategory = await _sRepo.getExpenseCategory();
    }
    emit(
      state.copyWith(
        status: CurrentStatus.success,
        expenseCategory: expenseCategory,
      ),
    );
  }

  Future<FutureOr<void>> insertDefaultCategory() async {
    await _sRepo.insertDefaultCategory();
  }

  Future<FutureOr<void>> insertExpenses(JsonMap expens) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading));
      await _sRepo.insertExpenses(expens);
      await Future.delayed(const Duration(seconds: 2), () async {
        final expenses = await _sRepo.getExpenses();
        final expense = Expense.fromJson(expens);
        emit(
          state.copyWith(
            status: CurrentStatus.saved,
            expenses: [...expenses, expense],
          ),
        );
      });
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CurrentStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<FutureOr<void>> getExpenses() async {
    emit(state.copyWith(status: CurrentStatus.loading));
    final expenses = await _sRepo.getExpenses();
    emit(
      state.copyWith(
        status: CurrentStatus.success,
        expenses: expenses,
      ),
    );
  }

  Future<FutureOr<void>> deleteExpense(String id) async {
    emit(state.copyWith(status: CurrentStatus.loading));
    final expenses = await _sRepo.deleteExpense(id);
    emit(
      state.copyWith(
        status: CurrentStatus.success,
        expenses: expenses,
      ),
    );
  }
}
