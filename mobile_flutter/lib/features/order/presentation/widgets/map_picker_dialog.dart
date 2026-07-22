import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';

class MapAddressResult {
  final String fullAddress;
  final String province;
  final String district;
  final String ward;
  final String addressLine;

  const MapAddressResult({
    required this.fullAddress,
    required this.province,
    required this.district,
    required this.ward,
    required this.addressLine,
  });
}

class MapPickerDialog extends StatefulWidget {
  const MapPickerDialog({super.key});

  @override
  State<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<MapPickerDialog> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  // Tọa độ mặc định (Bưu điện Trung tâm Sài Gòn, TP.HCM)
  final LatLng _initialCenter = const LatLng(10.7798, 106.6990);
  
  String _address = 'Đang xác định vị trí...';
  Map<String, dynamic>? _currentAddressObj;
  bool _isGeocoding = false;
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Lấy địa chỉ của vị trí mặc định lúc khởi tạo
    _fetchAddress(_initialCenter.latitude, _initialCenter.longitude);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // 1. Dịch tọa độ sang địa chỉ (Reverse Geocoding)
  Future<void> _fetchAddress(double latitude, double longitude) async {
    if (!mounted) return;
    setState(() {
      _isGeocoding = true;
      _address = 'Đang dịch tọa độ sang địa chỉ...';
    });

    try {
      final dio = Dio();
      dio.options.headers['User-Agent'] = 'CalendarShopMobile/1.0 (contact@calendarshop.com)';
      
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': latitude,
          'lon': longitude,
          'zoom': 18,
          'addressdetails': 1,
          'accept-language': 'vi',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final displayName = response.data['display_name'] as String?;
        final addressDetails = response.data['address'] as Map<String, dynamic>?;
        if (displayName != null) {
          setState(() {
            _address = displayName;
            _currentAddressObj = addressDetails;
          });
          return;
        }
      }
      
      setState(() {
        _address = 'Tọa độ: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
        _currentAddressObj = null;
      });
    } catch (e) {
      setState(() {
        _address = 'Không tìm thấy địa chỉ. Nhấp vào đây để tự nhập.';
        _currentAddressObj = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGeocoding = false;
        });
      }
    }
  }

  // 2. Tìm kiếm địa chỉ sang tọa độ (Geocoding)
  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isSearching = true;
    });

    try {
      final dio = Dio();
      dio.options.headers['User-Agent'] = 'CalendarShopMobile/1.0 (contact@calendarshop.com)';
      
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 1,
          'addressdetails': 1,
          'accept-language': 'vi',
        },
      );

      if (response.statusCode == 200 && response.data is List && (response.data as List).isNotEmpty) {
        final firstMatch = response.data[0];
        final lat = double.parse(firstMatch['lat'] as String);
        final lon = double.parse(firstMatch['lon'] as String);
        final displayName = firstMatch['display_name'] as String;
        final addressDetails = firstMatch['address'] as Map<String, dynamic>?;

        final targetLatLng = LatLng(lat, lon);
        
        // Di chuyển bản đồ đến tọa độ vừa tìm được
        _mapController.move(targetLatLng, 16.0);
        
        setState(() {
          _address = displayName;
          _currentAddressObj = addressDetails;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không tìm thấy địa điểm này. Vui lòng thử lại với từ khóa khác.'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối khi tìm kiếm: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    // Chỉ cập nhật khi người dùng kéo tay (tránh vòng lặp vô tận khi gọi controller.move)
    if (!hasGesture) return;

    final center = position.center;
    if (center == null) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _fetchAddress(center.latitude, center.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Stack(
            children: [
              // 1. Bản đồ OpenStreetMap
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialCenter,
                  initialZoom: 16.0,
                  maxZoom: 19.0,
                  minZoom: 5.0,
                  onPositionChanged: _onPositionChanged,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.fpt.calendar_shop',
                  ),
                ],
              ),

              // 2. Ghim đỏ đặt cố định ở tâm bản đồ
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 38.0),
                  child: Icon(
                    Icons.location_on,
                    size: 44,
                    color: Colors.red[700],
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),

              // 3. Thanh tìm kiếm địa chỉ nổi trên bản đồ (Top Search Bar)
              Positioned(
                top: 12,
                left: 12,
                right: 60, // Để chừa chỗ cho nút đóng Dialog ở góc phải
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _searchAddress,
                    decoration: InputDecoration(
                      hintText: 'Tìm địa điểm, đường phố...',
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      prefixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              ),
                            )
                          : const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
              ),

              // 4. Khung hiển thị địa chỉ và nút xác nhận dưới đáy
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.my_location,
                              size: 16,
                              color: _isGeocoding ? AppColors.primary : Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Địa chỉ giao hàng được chọn:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            if (_isGeocoding) ...[
                              const Spacer(),
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _address,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey[300]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Hủy', style: TextStyle(color: Colors.black54)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isGeocoding
                                    ? null
                                    : () {
                                        final result = _parseAddressDetails(_address, _currentAddressObj);
                                        Navigator.pop(context, result);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'Xác nhận',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Nút Đóng Dialog ở góc trên bên phải
              Positioned(
                top: 12,
                right: 12,
                child: FloatingActionButton.small(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 3,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MapAddressResult _parseAddressDetails(String displayName, Map<String, dynamic>? rawAddressObj) {
    String province = '';
    String district = '';
    String ward = '';
    String addressLine = '';

    if (rawAddressObj != null) {
      province = (rawAddressObj['city'] ??
              rawAddressObj['province'] ??
              rawAddressObj['state'] ??
              rawAddressObj['region'] ??
              '')
          .toString();

      district = (rawAddressObj['district'] ??
              rawAddressObj['city_district'] ??
              rawAddressObj['county'] ??
              rawAddressObj['town'] ??
              rawAddressObj['suburb'] ??
              '')
          .toString();

      ward = (rawAddressObj['ward'] ??
              rawAddressObj['quarter'] ??
              rawAddressObj['village'] ??
              rawAddressObj['commune'] ??
              rawAddressObj['suburb'] ??
              '')
          .toString();

      final houseNumber = rawAddressObj['house_number']?.toString() ?? '';
      final road = rawAddressObj['road']?.toString() ??
          rawAddressObj['pedestrian']?.toString() ??
          rawAddressObj['building']?.toString() ??
          '';

      if (road.isNotEmpty) {
        addressLine = houseNumber.isNotEmpty ? '$houseNumber $road' : road;
      }
    }

    if (displayName.isNotEmpty) {
      final parts = displayName.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      if (parts.isNotEmpty && parts.last.toLowerCase().contains('việt nam')) {
        parts.removeLast();
      }

      if (province.isEmpty && parts.isNotEmpty) {
        province = parts.removeLast();
      }
      if (district.isEmpty && parts.isNotEmpty) {
        district = parts.removeLast();
      }
      if (ward.isEmpty && parts.isNotEmpty) {
        ward = parts.removeLast();
      }
      if (addressLine.isEmpty && parts.isNotEmpty) {
        addressLine = parts.join(', ');
      }
    }

    if (addressLine.isEmpty) {
      addressLine = displayName;
    }

    return MapAddressResult(
      fullAddress: displayName,
      province: province,
      district: district,
      ward: ward,
      addressLine: addressLine,
    );
  }
}
