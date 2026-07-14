import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutPage extends StatelessWidget {
  final Widget child;

  const MainLayoutPage({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/products') && !location.contains('/admin')) {
      return 0; // Trang chủ
    }
    if (location.startsWith('/categories') && !location.contains('/admin')) {
      return 1; // Danh mục
    }
    if (location.startsWith('/cart')) {
      return 2; // Giỏ hàng
    }
    if (location.startsWith('/profile') || location.startsWith('/orders') || location.startsWith('/favorites')) {
      return 3; // Hồ sơ
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/products');
        break;
      case 1:
        context.go('/products'); 
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/orders'); 
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _calculateSelectedIndex(context),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Danh mục',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Giỏ hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
    );
  }
}
