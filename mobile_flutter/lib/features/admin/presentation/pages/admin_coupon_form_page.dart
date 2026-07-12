import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_coupon.dart';
import '../providers/admin_coupon_provider.dart';

class AdminCouponFormPage extends ConsumerStatefulWidget {
  final AdminCoupon? coupon;

  const AdminCouponFormPage({super.key, this.coupon});

  @override
  ConsumerState<AdminCouponFormPage> createState() => _AdminCouponFormPageState();
}

class _AdminCouponFormPageState extends ConsumerState<AdminCouponFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _minOrderValueController = TextEditingController();
  final _usageLimitController = TextEditingController();

  String _discountType = 'Percent';
  String _status = 'Active';
  DateTime? _startDate;
  DateTime? _endDate;

  bool get _isEditing => widget.coupon != null;

  @override
  void initState() {
    super.initState();
    final coupon = widget.coupon;
    if (coupon != null) {
      _codeController.text = coupon.code;
      _descriptionController.text = coupon.description ?? '';
      _discountValueController.text = coupon.discountValue.toString();
      _minOrderValueController.text = coupon.minOrderValue.toString();
      _usageLimitController.text = coupon.usageLimit?.toString() ?? '';
      _discountType = coupon.discountType;
      _status = coupon.status;
      _startDate = coupon.startDate.toLocal();
      _endDate = coupon.endDate.toLocal();
    } else {
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = _startDate!.add(const Duration(days: 7));
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderValueController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(adminCouponActionNotifierProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Chỉnh sửa mã giảm giá' : 'Tạo mã giảm giá'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Mã giảm giá',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mã giảm giá.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _discountType,
              decoration: const InputDecoration(
                labelText: 'Loại giảm giá',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Percent', child: Text('Phần trăm')),
                DropdownMenuItem(value: 'Amount', child: Text('Số tiền')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _discountType = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountValueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText:
                    _discountType == 'Percent' ? 'Phần trăm giảm' : 'Số tiền giảm',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Vui lòng nhập giá trị giảm hợp lệ.';
                }
                if (_discountType == 'Percent' && parsed > 100) {
                  return 'Phần trăm giảm không được vượt quá 100.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _minOrderValueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Đơn tối thiểu',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed < 0) {
                  return 'Vui lòng nhập đơn tối thiểu hợp lệ.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Ngày bắt đầu',
                    value: _startDate == null
                        ? 'Chọn ngày'
                        : dateFormat.format(_startDate!),
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    label: 'Ngày kết thúc',
                    value:
                        _endDate == null ? 'Chọn ngày' : dateFormat.format(_endDate!),
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usageLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giới hạn sử dụng (để trống nếu không giới hạn)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return null;
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return 'Giới hạn sử dụng phải lớn hơn 0.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Trạng thái',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Active', child: Text('Active')),
                DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _status = value);
              },
            ),
            if (actionState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                actionState.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: actionState.isLoading ? null : _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: actionState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Lưu thay đổi' : 'Tạo mã giảm giá'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = DateTime(picked.year, picked.month, picked.day);
        if (_endDate != null && !_endDate!.isAfter(_startDate!)) {
          _endDate = _startDate!.add(const Duration(days: 1));
        }
      } else {
        _endDate = DateTime(picked.year, picked.month, picked.day);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      _showMessage('Vui lòng chọn ngày bắt đầu và ngày kết thúc.');
      return;
    }
    if (!_endDate!.isAfter(_startDate!)) {
      _showMessage('Ngày kết thúc phải sau ngày bắt đầu.');
      return;
    }

    final usageLimit = _usageLimitController.text.trim().isEmpty
        ? null
        : int.parse(_usageLimitController.text.trim());

    final notifier = ref.read(adminCouponActionNotifierProvider.notifier);

    final success = _isEditing
        ? await notifier.updateCoupon(
            widget.coupon!.couponId,
            code: _codeController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            discountType: _discountType,
            discountValue: double.parse(_discountValueController.text.trim()),
            minOrderValue: double.parse(_minOrderValueController.text.trim()),
            startDate: _startDate!,
            endDate: _endDate!,
            usageLimit: usageLimit,
            status: _status,
          )
        : await notifier.createCoupon(
            code: _codeController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            discountType: _discountType,
            discountValue: double.parse(_discountValueController.text.trim()),
            minOrderValue: double.parse(_minOrderValueController.text.trim()),
            startDate: _startDate!,
            endDate: _endDate!,
            usageLimit: usageLimit,
            status: _status,
          );

    if (!mounted) return;

    if (success) {
      _showMessage(
        _isEditing ? 'Đã cập nhật mã giảm giá.' : 'Đã tạo mã giảm giá.',
      );
      Navigator.of(context).pop();
    } else {
      _showMessage(
        ref.read(adminCouponActionNotifierProvider).error ??
            'Thao tác thất bại.',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(value),
      ),
    );
  }
}
