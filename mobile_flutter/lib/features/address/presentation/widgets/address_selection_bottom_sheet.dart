import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';
import '../../domain/entities/address.dart';
import 'add_edit_address_dialog.dart';

class AddressSelectionBottomSheet extends ConsumerWidget {
  final Address? currentSelectedAddress;

  const AddressSelectionBottomSheet({super.key, this.currentSelectedAddress});

  String _formatAddress(Address addr) {
    final parts = [addr.addressLine, addr.ward, addr.district, addr.province];
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressListProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chon dia chi giao hang',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: addressState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Loi: $err')),
              data: (addresses) {
                if (addresses.isEmpty) {
                  return const Center(child: Text('Chua co dia chi nao.'));
                }
                return ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final isSelected = address.addressId == currentSelectedAddress?.addressId;

                    return Card(
                      color: isSelected ? Colors.deepOrange.shade50 : null,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isSelected ? Colors.deepOrange : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              address.receiverName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Text('| ${address.receiverPhone}'),
                            if (address.isDefault)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Mac dinh',
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              )
                          ],
                        ),
                        subtitle: Text(_formatAddress(address)),
                        onTap: () {
                          Navigator.of(context).pop(address);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddEditAddressDialog(existingAddress: address),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Them dia chi moi'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddEditAddressDialog(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
