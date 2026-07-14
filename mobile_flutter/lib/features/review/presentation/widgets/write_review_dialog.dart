import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/review_provider.dart';

class WriteReviewDialog extends ConsumerStatefulWidget {
  final int orderItemId;
  final int productId;

  const WriteReviewDialog({
    super.key,
    required this.orderItemId,
    required this.productId,
  });

  @override
  ConsumerState<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends ConsumerState<WriteReviewDialog> {
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(reviewActionNotifierProvider);

    return AlertDialog(
      title: const Text('Đánh giá sản phẩm'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Bình luận (Tùy chọn)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          if (actionState.error != null) ...[
            const SizedBox(height: 8),
            Text(actionState.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: actionState.isLoading ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: actionState.isLoading
              ? null
              : () async {
                  final success = await ref
                      .read(reviewActionNotifierProvider.notifier)
                      .createReview(widget.orderItemId, _rating, _commentController.text, widget.productId);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')),
                    );
                    Navigator.pop(context);
                  }
                },
          child: actionState.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Gửi'),
        ),
      ],
    );
  }
}
