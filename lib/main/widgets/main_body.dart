import 'package:flutter/material.dart';
import 'package:my_expense_tracker/auth/authentication.dart';
import 'package:my_expense_tracker/home/home.dart';
import 'package:my_expense_tracker/main/cubit/cubit.dart';
import 'package:my_expense_tracker/settings/view/settings_page.dart';
import 'package:my_expense_tracker/stats/stats.dart';

/// {@template main_body}
/// Body of the MainPage.
///
/// Add what it does
/// {@endtemplate}
class MainBody extends StatefulWidget {
  /// {@macro main_body}
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    context.watch<AuthBloc>().state;
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    // Update the state when a tab is tapped

    setState(() {
      _selectedIndex = index;
    });
  }
}
