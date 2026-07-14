import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/pages/admin_home_page.dart';
import '../../features/admin/presentation/pages/admin_coupon_form_page.dart';
import '../../features/admin/presentation/pages/admin_coupon_list_page.dart';
import '../../features/admin/presentation/pages/admin_statistics_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/order/presentation/pages/my_orders_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/favorite/presentation/pages/favorites_page.dart';

import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/product/presentation/pages/admin_product_list_page.dart';
import '../../features/product/presentation/pages/admin_product_form_page.dart';
import '../../features/category/presentation/pages/admin_category_page.dart';
import '../../features/admin/domain/entities/admin_coupon.dart';
import '../presentation/pages/main_layout_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    
    // Khối ShellRoute chứa Bottom Navigation Bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayoutPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductListPage(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartPage(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const MyOrdersPage(),
        ),
      ],
    ),
    
    // Trang chi tiết nằm ngoài ShellRoute để không hiển thị BottomNavigationBar
    GoRoute(
      path: '/products/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailPage(productId: id);
      },
    ),
    
    GoRoute(path: '/admin', builder: (context, state) => const AdminHomePage()),
    GoRoute(
      path: '/admin/statistics',
      builder: (context, state) => const AdminStatisticsPage(),
    ),
    GoRoute(
      path: '/admin/coupons',
      builder: (context, state) => const AdminCouponListPage(),
    ),
    GoRoute(
      path: '/admin/coupons/new',
      builder: (context, state) => const AdminCouponFormPage(),
    ),
    GoRoute(
      path: '/admin/coupons/edit',
      builder: (context, state) {
        final coupon = state.extra as AdminCoupon?;
        return AdminCouponFormPage(coupon: coupon);
      },
    ),
    GoRoute(
      path: '/admin/products',
      builder: (context, state) => const AdminProductListPage(),
    ),
    GoRoute(
      path: '/admin/categories',
      builder: (context, state) => const AdminCategoryPage(),
    ),
    GoRoute(
      path: '/admin/products/new',
      builder: (context, state) => const AdminProductFormPage(),
    ),
    GoRoute(
      path: '/admin/products/edit',
      builder: (context, state) {
        final product = state.extra as Product?;
        return AdminProductFormPage(product: product);
      },
    ),
  ],
);
