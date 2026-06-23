import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/admin_home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/order/presentation/pages/my_orders_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';

import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/product/presentation/pages/admin_product_list_page.dart';
import '../../features/product/presentation/pages/admin_product_form_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/products', builder: (context, state) => const ProductListPage()),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(path: '/orders', builder: (context, state) => const MyOrdersPage()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminHomePage()),
    GoRoute(
      path: '/admin/products',
      builder: (context, state) => const AdminProductListPage(),
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
