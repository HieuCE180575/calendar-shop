import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';
import '../../domain/entities/address.dart';

class AddEditAddressDialog extends ConsumerStatefulWidget {
  final Address? existingAddress;

  const AddEditAddressDialog({super.key, this.existingAddress});

  @override
  ConsumerState<AddEditAddressDialog> createState() => _AddEditAddressDialogState();
}

class _AddEditAddressDialogState extends ConsumerState<AddEditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _provinceController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  late TextEditingController _addressLineController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingAddress?.receiverName ?? '');
    _phoneController = TextEditingController(text: widget.existingAddress?.receiverPhone ?? '');
    _provinceController = TextEditingController(text: widget.existingAddress?.province ?? '');
    _districtController = TextEditingController(text: widget.existingAddress?.district ?? '');
    _wardController = TextEditingController(text: widget.existingAddress?.ward ?? '');
    _addressLineController = TextEditingController(text: widget.existingAddress?.addressLine ?? '');
    _isDefault = widget.existingAddress?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _addressLineController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final province = _provinceController.text.trim();
    final district = _districtController.text.trim();
    final ward = _wardController.text.trim();
    final addressLine = _addressLineController.text.trim();

    if (widget.existingAddress == null) {
      await ref.read(addressListProvider.notifier).addAddress(
            receiverName: name,
            receiverPhone: phone,
            province: province,
            district: district,
            ward: ward,
            addressLine: addressLine,
            isDefault: _isDefault,
          );
    } else {
      await ref.read(addressListProvider.notifier).updateAddress(
            addressId: widget.existingAddress!.addressId,
            receiverName: name,
            receiverPhone: phone,
            province: province,
            district: district,
            ward: ward,
            addressLine: addressLine,
            isDefault: _isDefault,
          );
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingAddress == null ? 'Them dia chi' : 'Sua dia chi'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ho ten nguoi nhan'),
                validator: (val) => (val == null || val.isEmpty) ? 'Bat buoc' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'So dien thoai'),
                keyboardType: TextInputType.phone,
                validator: (val) => (val == null || val.isEmpty) ? 'Bat buoc' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _provinceController,
                decoration: const InputDecoration(labelText: 'Tinh/Thanh pho'),
                validator: (val) => (val == null || val.isEmpty) ? 'Bat buoc' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'Quan/Huyen'),
                validator: (val) => (val == null || val.isEmpty) ? 'Bat buoc' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(labelText: 'Phuong/Xa (tuy chon)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressLineController,
                decoration: const InputDecoration(labelText: 'So nha, ten duong'),
                validator: (val) => (val == null || val.isEmpty) ? 'Bat buoc' : null,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Dat lam mac dinh'),
                value: _isDefault,
                onChanged: (val) => setState(() => _isDefault = val),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huy'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Luu'),
        ),
      ],
    );
  }
}
