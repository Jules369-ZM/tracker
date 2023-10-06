part of 'home_cubit.dart';

/// {@template home}
/// HomeState description
/// {@endtemplate}
class HomeState extends Equatable {
  /// {@macro home}
  const HomeState({
    this.message = 'Home',
    this.data,
    this.status = CurrentStatus.initial,
    this.expenseCategory = const [],
    this.expenses = const [],
  });

  /// A description for message
  final String message;
  final JsonMap? data;
  final CurrentStatus status;
  final List<ExpenseCategory> expenseCategory;
  final List<Expense> expenses;

  @override
  List<Object> get props => [message, status, data ?? '', expenses];

  /// Creates a copy of the current HomeState with property changes
  HomeState copyWith({
    String? message,
    JsonMap? data,
    CurrentStatus? status,
    List<ExpenseCategory>? expenseCategory,
    List<Expense>? expenses,
  }) {
    return HomeState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      expenses: expenses ?? this.expenses,
    );
  }
}
