import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final message = _controller.text;
    if (message.trim().isEmpty) return;
    _controller.clear();
    await ref.read(chatNotifierProvider.notifier).sendMessage(message);
    if (_scrollController.hasClients) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);

    ref.listen<ChatState>(chatNotifierProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Trợ lý cửa hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(chatNotifierProvider.notifier).clearChat(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới đoạn chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Bạn có thể hỏi về sản phẩm, giá, tồn kho, coupon và khuyến mãi đang áp dụng.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= chatState.messages.length) {
                  return const _TypingBubble();
                }

                final message = chatState.messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: 'Hỏi về lịch, tồn kho, coupon...',
                        filled: true,
                        fillColor: const Color(0xFFF3F5F8),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: chatState.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageItem message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor = message.isUser ? AppColors.primary : Colors.white;
    final textColor = message.isUser ? Colors.white : AppColors.textPrimary;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: message.isUser ? null : Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FormattedMessageText(
                text: message.text,
                color: textColor,
                enableMarkdown: !message.isUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormattedMessageText extends StatelessWidget {
  final String text;
  final Color color;
  final bool enableMarkdown;

  const _FormattedMessageText({
    required this.text,
    required this.color,
    required this.enableMarkdown,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      color: color,
      fontSize: 14,
      height: 1.45,
    );

    if (!enableMarkdown || !text.contains('**')) {
      return Text(text, style: baseStyle);
    }

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: _buildMarkdownSpans(text, baseStyle),
      ),
    );
  }

  List<TextSpan> _buildMarkdownSpans(String value, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final boldPattern = RegExp(r'\*\*([\s\S]+?)\*\*');
    var currentIndex = 0;

    for (final match in boldPattern.allMatches(value)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: value.substring(currentIndex, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: baseStyle.copyWith(fontWeight: FontWeight.w700),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < value.length) {
      spans.add(TextSpan(text: value.substring(currentIndex)));
    }

    return spans;
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 110,
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text('Đang trả lời...'),
          ),
        ),
      ),
    );
  }
}
