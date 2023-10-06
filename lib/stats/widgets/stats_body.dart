import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker/stats/cubit/cubit.dart';
import 'package:my_expense_tracker/stats/widgets/tx_bar_chart.dart';
import 'package:my_expense_tracker/utils/size_config.dart';

/// {@template stats_body}
/// Body of the StatsPage.
///
/// Add what it does
/// {@endtemplate}
class StatsBody extends StatefulWidget {
  /// {@macro stats_body}
  const StatsBody({super.key});

  @override
  State<StatsBody> createState() => _StatsBodyState();
}

class _StatsBodyState extends State<StatsBody> {
  String _frequency = 'Weekly';
  List<String> items = [
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  String _subtitle = 'Last 7 days';
  List<String> subtitles = [
    'Last 7 days',
    'This Month',
    'This Year',
  ];
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateFormat('E, d MMMM', 'en_US').format(now);
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        var income = 0.0;
        var expenses = 0.0;
        final inCategories = <String>{};
        final exCategories = <String>{};
        var formattedDateRange = '';
        for (final tx in state.expenses) {
          const duration = Duration(days: 7);
          var date = now.subtract(duration);
          formattedDateRange = formatDateRange(date, now);

          if (_frequency == 'Monthly') {
            date = DateTime(DateTime.now().year, DateTime.now().month);
            formattedDateRange =
                formatDateRange(now.subtract(const Duration(days: 30)), now);
          }
          if (_frequency == 'Yearly') {
            date = DateTime(DateTime.now().year);
            formattedDateRange =
                formatDateRange(now.subtract(const Duration(days: 365)), now);
          }
          final txDate = DateTime.tryParse(tx.date) ?? DateTime.now();
          if (txDate!.isAfter(date)) {
            income += double.parse(tx.amount);
          }
        }
        return ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenHeight(10),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: DropdownButton<String>(
                    value: _frequency,
                    underline: Container(),
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    items: items.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _frequency = newValue!;
                        final i = items.indexOf(_frequency);
                        if (i >= 0) {
                          _subtitle = subtitles[i];
                        }
                      });
                    },
                  ),
                ),
                Text(formattedDateRange),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 192,
              child: TxBarChart.withData(
                state.expenses,
                filter: _frequency,
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

String formatDateRange(DateTime start, DateTime end) {
  final startMonth = DateFormat.MMM().format(start);
  final endMonth = DateFormat.MMM().format(end);
  final startDay = DateFormat.d().format(start);
  final endDay = DateFormat.d().format(end);

  if (startMonth == endMonth) {
    return '$startMonth $startDay - $endDay';
  } else {
    return '$startMonth $startDay - $endMonth $endDay';
  }
}
