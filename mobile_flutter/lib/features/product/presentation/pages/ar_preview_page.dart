import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/product_provider.dart';

class ARPreviewPage extends ConsumerStatefulWidget {
  final int productId;

  const ARPreviewPage({super.key, required this.productId});

  @override
  ConsumerState<ARPreviewPage> createState() => _ARPreviewPageState();
}

class _ARPreviewPageState extends ConsumerState<ARPreviewPage> {
  // Trạng thái ảnh nền
  String _selectedBackgroundUrl = _backgroundTemplates[0]['url']!;

  // Danh sách các phòng mẫu (Unsplash High-Quality)
  static const List<Map<String, String>> _backgroundTemplates = [
    {
      'name': 'Bàn làm việc',
      'url': 'https://images.unsplash.com/photo-1493934558415-9d19f0b2b4d2?q=80&w=1000&auto=format&fit=crop'
    },
    {
      'name': 'Phòng khách',
      'url': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=1000&auto=format&fit=crop'
    },
    {
      'name': 'Kệ phòng ngủ',
      'url': 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=1000&auto=format&fit=crop'
    },
  ];

  // Trạng thái biến đổi lịch
  double _xPosition = 120.0;
  double _yPosition = 150.0;
  double _scale = 0.8;
  double _rotationX = 0.0; // Nghiêng lên/xuống (độ)
  double _rotationY = 0.0; // Nghiêng trái/phải (độ)
  double _rotationZ = 0.0; // Xoay tròn 2D (độ)

  bool _showGuide = true;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Không gian ảo AR Preview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              setState(() {
                _showGuide = !_showGuide;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetTransforms,
            tooltip: 'Đặt lại vị trí',
          ),
        ],
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(
          child: Text('Lỗi tải sản phẩm: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (product) {
          final isWallCalendar = product.calendarType.toLowerCase().contains('treo') || 
                                 product.calendarType.toLowerCase().contains('tường');

          return Stack(
            children: [
              // 1. Hình nền phòng ảo
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: _selectedBackgroundUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(color: Colors.white70),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[900],
                    child: const Icon(Icons.image_not_supported, color: Colors.white, size: 48),
                  ),
                ),
              ),

              // 2. Lớp tối phủ nhẹ để nổi bật Lịch
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                ),
              ),

              // 3. Widget lịch có thể kéo thả và xoay 3D
              Positioned(
                left: _xPosition,
                top: _yPosition,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _xPosition += details.delta.dx;
                      _yPosition += details.delta.dy;
                    });
                  },
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Điểm tụ tạo chiều sâu phối cảnh
                      ..rotateX(_rotationX)
                      ..rotateY(_rotationY)
                      ..rotateZ(_rotationZ)
                      ..scale(_scale),
                    alignment: Alignment.center,
                    child: _buildCalendarPreviewWidget(product.imageUrl, isWallCalendar),
                  ),
                ),
              ),

              // 4. Hướng dẫn sử dụng ban đầu
              if (_showGuide)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.gesture, color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Kéo lịch để di chuyển. Sử dụng các thanh trượt bên dưới để chỉnh kích thước và góc nghiêng 3D cho khớp với căn phòng.',
                            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                          onPressed: () {
                            setState(() {
                              _showGuide = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              // 5. Thanh điều khiển ở dưới đáy
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chọn phòng mẫu
                      const Text(
                        '1. Chọn không gian phòng mẫu',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 38,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _backgroundTemplates.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _backgroundTemplates.length) {
                              // Nút tải ảnh custom
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: OutlinedButton.icon(
                                  onPressed: _uploadCustomBackground,
                                  icon: const Icon(Icons.add_photo_alternate_outlined, size: 16, color: Colors.white70),
                                  label: const Text('Tải ảnh phòng', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                ),
                              );
                            }

                            final item = _backgroundTemplates[index];
                            final isSelected = _selectedBackgroundUrl == item['url'];

                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(item['name']!),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) {
                                    setState(() {
                                      _selectedBackgroundUrl = item['url']!;
                                    });
                                  }
                                },
                                selectedColor: AppColors.primary,
                                backgroundColor: Colors.grey[900],
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontSize: 12,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 20),

                      // Thanh điều hướng biến dạng 3D
                      const Text(
                        '2. Cấu hình vị trí & Phối cảnh 3D',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 10),

                      // Tỷ lệ kích thước (Scale)
                      _buildSliderRow(
                        label: 'Kích thước',
                        value: _scale,
                        min: 0.3,
                        max: 2.0,
                        onChanged: (val) => setState(() => _scale = val),
                      ),

                      // Xoay 3D trục Y (Perspective tilt)
                      _buildSliderRow(
                        label: 'Nghiêng Trái/Phải',
                        value: _rotationY,
                        min: -1.0,
                        max: 1.0,
                        onChanged: (val) => setState(() => _rotationY = val),
                      ),

                      // Xoay 3D trục X (Perspective tilt up/down)
                      _buildSliderRow(
                        label: 'Nghiêng Trên/Dưới',
                        value: _rotationX,
                        min: -1.0,
                        max: 1.0,
                        onChanged: (val) => setState(() => _rotationX = val),
                      ),

                      // Xoay 2D
                      _buildSliderRow(
                        label: 'Xoay nghiêng',
                        value: _rotationZ,
                        min: -0.5,
                        max: 0.5,
                        onChanged: (val) => setState(() => _rotationZ = val),
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: _takeSnapshot,
                          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                          label: const Text('Lưu ảnh thiết kế phòng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendarPreviewWidget(String? imageUrl, bool isWallCalendar) {
    // Tạo hiệu ứng đổ bóng lịch chân thực
    return Container(
      width: isWallCalendar ? 180 : 200,
      height: isWallCalendar ? 240 : 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWallCalendar ? 4 : 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(5, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isWallCalendar ? 4 : 8),
        child: Stack(
          children: [
            // Ảnh bìa cuốn lịch
            Positioned.fill(
              child: imageUrl != null && imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.calendar_month, size: 64, color: AppColors.primary),
                    ),
            ),

            // Nếu là lịch treo tường, vẽ cái dây treo móc lịch cho trực quan
            if (isWallCalendar)
              Positioned(
                top: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

            // Vẽ chân đế chữ A nếu là lịch để bàn
            if (!isWallCalendar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 16,
                  color: Colors.brown[700],
                  child: const Center(
                    child: Text(
                      'Calendar Stand',
                      style: TextStyle(color: Colors.white30, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetTransforms() {
    setState(() {
      _xPosition = 120.0;
      _yPosition = 150.0;
      _scale = 0.8;
      _rotationX = 0.0;
      _rotationY = 0.0;
      _rotationZ = 0.0;
    });
  }

  void _uploadCustomBackground() {
    // Cho phép người dùng nhập link ảnh phòng của họ hoặc tự giả lập
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nhập link ảnh phòng của bạn'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            hintText: 'Nhập địa chỉ ảnh HTTP hoặc HTTPS...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.trim().isNotEmpty) {
                setState(() {
                  _selectedBackgroundUrl = urlController.text.trim();
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  void _takeSnapshot() {
    // Giả lập chụp màn hình lưu thiết kế
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📸 Đã lưu ảnh phối cảnh thiết kế lịch vào bộ sưu tập!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
