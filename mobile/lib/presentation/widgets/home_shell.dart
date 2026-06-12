import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:igo_manager/core/constants/app_colors.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({required this.child, super.key});

  int _currentIndex(String location) {
    if (location.startsWith('/matriz')) return 1;
    if (location.startsWith('/planes')) return 2;
    if (location.startsWith('/perfil') || location.startsWith('/configuracion')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _currentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.of(context).textHint,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/iniciativas');
            case 1: context.go('/matriz');
            case 2: context.go('/planes');
            case 3: context.go('/perfil');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: 'Iniciativas'),
          BottomNavigationBarItem(icon: Icon(Icons.donut_large_outlined), label: 'Matriz IGO'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Planes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}
