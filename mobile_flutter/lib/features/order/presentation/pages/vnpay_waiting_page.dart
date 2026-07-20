import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/order_provider.dart';

class VNPayWaitingPage extends ConsumerStatefulWidget {
  final int orderId;
  const VNPayWaitingPage({super.key, required this.orderId});

  @override
  ConsumerState<VNPayWaitingPage> createState() => _VNPayWaitingPageState();
}

class _VNPayWaitingPageState extends ConsumerState<VNPayWaitingPage> {
  Timer? _timer;
  bool _isCancelling = false;
  
  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final orderDetail = await ref.read(getOrderDetailUseCaseProvider)(widget.orderId);
        if (orderDetail.status == 'Confirmed') {
          timer.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanh toán VNPay thành công!')),
            );
            context.go('/orders');
          }
        } else if (orderDetail.status == 'Cancelled') {
          timer.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đơn hàng đã bị hủy do thanh toán thất bại hoặc quá hạn.')),
            );
            context.go('/orders');
          }
        }
      } catch (e) {
        // Bỏ qua lỗi trong quá trình polling (ví dụ lỗi mạng), thử lại ở lần tick tiếp theo
      }
    });
  }

  Future<void> _cancelOrder() async {
    setState(() => _isCancelling = true);
    try {
      await ref.read(myOrdersProvider.notifier).cancelOrder(widget.orderId, 'Người dùng hủy thanh toán VNPay');
      _timer?.cancel();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã hủy giao dịch và đơn hàng.')),
        );
        context.go('/orders');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hủy đơn hàng thất bại: $e')),
        );
        setState(() => _isCancelling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang chờ thanh toán'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              const Text(
                'Vui lòng hoàn tất thanh toán trên màn hình VNPay.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Hệ thống đang chờ xác nhận thanh toán...\n(Đơn hàng sẽ tự động hủy sau 24h nếu chưa thanh toán)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isCancelling ? null : _cancelOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isCancelling
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                        )
                      : const Text(
                          'Hủy giao dịch',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
