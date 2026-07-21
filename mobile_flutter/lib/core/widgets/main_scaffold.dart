import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../theme/app_colors.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;
  final String currentPath;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  int _calculateSelectedIndex(String path) {
    if (path.startsWith('/products') || path == '/') return 0;
    if (path.startsWith('/favorites')) return 1;
    if (path.startsWith('/cart')) return 2;
    if (path.startsWith('/orders')) return 3;
    if (path.startsWith('/profile') || path.startsWith('/admin')) return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/products');
        break;
      case 1:
        context.go('/favorites');
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
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartCount = cartState.value?.length ?? 0;
    final userState = ref.watch(authNotifierProvider);
    final isAdmin = userState.user?.role == 'Admin';
    final selectedIndex = _calculateSelectedIndex(currentPath);

    String title = 'Calendar Shop';
    if (currentPath.startsWith('/favorites')) title = 'Sản phẩm yêu thích';
    if (currentPath.startsWith('/cart')) title = 'Giỏ hàng ($cartCount)';
    if (currentPath.startsWith('/orders')) title = 'Đơn hàng của tôi';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () => context.push('/cart'),
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
            ),
          ),
          if (isAdmin)
            IconButton(
              onPressed: () => context.go('/admin'),
              icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primary),
              tooltip: 'Trang quản trị',
            ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.textPrimary),
            tooltip: 'Hồ sơ',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Ưa thích',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Giỏ hàng',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Đơn hàng',
            ),
          ],
        ),
      ),
    );
  }
}
