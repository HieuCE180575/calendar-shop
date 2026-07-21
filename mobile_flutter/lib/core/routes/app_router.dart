import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/main_scaffold.dart';

import '../../features/admin/domain/entities/admin_coupon.dart';
import '../../features/admin/presentation/pages/admin_coupon_form_page.dart';
import '../../features/admin/presentation/pages/admin_coupon_list_page.dart';
import '../../features/admin/presentation/pages/admin_home_page.dart';
import '../../features/admin/presentation/pages/admin_order_list_page.dart';
import '../../features/admin/presentation/pages/admin_statistics_page.dart';
import '../../features/admin/presentation/pages/admin_user_detail_page.dart';
import '../../features/admin/presentation/pages/admin_user_list_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/confirm_email_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/verify_reset_code_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/category/presentation/pages/admin_category_page.dart';
import '../../features/favorite/presentation/pages/favorites_page.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/presentation/pages/my_orders_page.dart';
import '../../features/order/presentation/pages/order_detail_page.dart';
import '../../features/order/presentation/pages/vnpay_waiting_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/admin_product_form_page.dart';
import '../../features/product/presentation/pages/admin_product_list_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordPage()),
    GoRoute(
      path: '/verify-reset-code',
      builder: (context, state) => VerifyResetCodePage(
        login: state.uri.queryParameters['login'],
      ),
    ),
    GoRoute(
      path: '/confirm-email',
      builder: (context, state) => ConfirmEmailPage(initialToken: state.uri.queryParameters['token']),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => ResetPasswordPage(initialToken: state.uri.queryParameters['token']),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(path: '/change-password', builder: (context, state) => const ChangePasswordPage()),
    
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(
          currentPath: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(path: '/products', builder: (context, state) => const ProductListPage()),
        GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
        GoRoute(path: '/favorites', builder: (context, state) => const FavoritesPage()),
        GoRoute(path: '/orders', builder: (context, state) => const MyOrdersPage()),
      ],
    ),
    
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(path: '/checkout', builder: (context, state) => const CheckoutPage()),
    GoRoute(
      path: '/vnpay-waiting/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return VNPayWaitingPage(orderId: id);
      },
    ),
    GoRoute(
      path: '/orders/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return OrderDetailPage(orderId: id);
      },
    ),
    
    GoRoute(path: '/admin', builder: (context, state) => const AdminHomePage()),
    GoRoute(path: '/admin/orders', builder: (context, state) => const AdminOrderListPage()),
    GoRoute(path: '/admin/users', builder: (context, state) => const AdminUserListPage()),
    GoRoute(
      path: '/admin/users/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return AdminUserDetailPage(userId: id);
      },
    ),
    GoRoute(path: '/admin/statistics', builder: (context, state) => const AdminStatisticsPage()),
    GoRoute(path: '/admin/coupons', builder: (context, state) => const AdminCouponListPage()),
    GoRoute(path: '/admin/coupons/new', builder: (context, state) => const AdminCouponFormPage()),
    GoRoute(
      path: '/admin/coupons/edit',
      builder: (context, state) {
        final coupon = state.extra as AdminCoupon?;
        return AdminCouponFormPage(coupon: coupon);
      },
    ),
    GoRoute(path: '/admin/products', builder: (context, state) => const AdminProductListPage()),
    GoRoute(path: '/admin/categories', builder: (context, state) => const AdminCategoryPage()),
    GoRoute(path: '/admin/products/new', builder: (context, state) => const AdminProductFormPage()),
    GoRoute(
      path: '/admin/products/edit',
      builder: (context, state) {
        final product = state.extra as Product?;
        return AdminProductFormPage(product: product);
      },
    ),
  ],
);
