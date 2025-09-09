import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/widget/common/app_spacing.dart';
// import 'package:geocoding/geocoding.dart'; // Tạm thời comment lại vì MissingPluginException

import 'package:myapp/widget/common/custom_card.dart';

class ShopMapAddress {
  final String address;
  final String phone;
  final String email;
  // Thêm tọa độ cho mỗi shop
  final double latitude;
  final double longitude;

  ShopMapAddress({
    required this.address,
    required this.phone,
    required this.email,
    required this.latitude, // Thêm vào
    required this.longitude, // Thêm vào
  });
}

class ShopMap extends StatefulWidget {
  const ShopMap({super.key, required this.title});
  final String title;

  @override
  State<ShopMap> createState() => _ShopMapState();
}

class _ShopMapState extends State<ShopMap> {
  GoogleMapController? _mapController;
  final Map<String, Marker> _markers = {}; // Sử dụng Set thay vì Map
  TextEditingController searchLocationController = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(16.0, 108.0),
    zoom: 5.5,
  );

  @override
  void initState() {
    super.initState();
    // Thêm markers khi widget được khởi tạo
    _addInitialMarkers();
  }

  void _addInitialMarkers() {
    // Lấy danh sách shops từ phương thức của bạn
    final shopAddresses = _getShopAddresses();

    // Tạo marker cho mỗi shop
    for (int i = 0; i < shopAddresses.length; i++) {
      final shop = shopAddresses[i];
      final markerId = MarkerId('shop_$i');

      final marker = Marker(
        markerId: markerId,
        position: LatLng(shop.latitude, shop.longitude),
        infoWindow: InfoWindow(
          title: 'Cửa hàng ${i + 1}',
          snippet: shop.address,
        ),
      );

      setState(() {
        _markers[markerId.value] = marker;
      });
    }
  }

  // Thêm phương thức này để chuyển đến vị trí của shop
  void _goToShopLocation(ShopMapAddress shop) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(shop.latitude, shop.longitude), zoom: 15),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật vị trí hiện tại'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lấy vị trí: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Thay đổi phương thức này để trả về danh sách ShopMapAddress
  List<ShopMapAddress> _getShopAddresses() {
    return [
      ShopMapAddress(
        address:
            '49/12 Đường 51, Phường 14, Quận Gò Vấp, Thành Phố Hồ Chí Minh',
        phone: '0123 456 789',
        email: 'shop@example.com',
        latitude: 10.762622, // Tọa độ giả định cho HCM
        longitude: 106.660172,
      ),
      ShopMapAddress(
        address: '456 Đường DEF, Quận UVW, Thành phố HN',
        phone: '0987 654 321',
        email: 'shopsaddasdas2@example.com',
        latitude: 21.028511, // Tọa độ giả định cho Hà Nội
        longitude: 105.804817,
      ),
      ShopMapAddress(
        address: '789 Đường GHI, Quận JKL, Đà Nẵng',
        phone: '0987 654 321',
        email: 'shop3@example.com',
        latitude: 16.047079, // Tọa độ giả định cho Đà Nẵng
        longitude: 108.206230,
      ),
      ShopMapAddress(
        address: '101 Đường MNO, Quận PQR, Cần Thơ',
        phone: '0987 654 321',
        email: 'shop4@example.com',
        latitude: 10.045162, // Tọa độ giả định cho Cần Thơ
        longitude: 105.746857,
      ),
    ];
  }

  List<Widget> _buildShopAddress(double paddingResponsive) {
    List<ShopMapAddress> shopAddresses = _getShopAddresses();

    return shopAddresses.map((shop) {
      return InkWell(
        onTap: () {
          // Khi tap vào shop, di chuyển camera đến vị trí của shop
          _goToShopLocation(shop);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Address row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        shop.address,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vertical(4),
                // Contact info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.black54,
                        ),
                        AppSpacing.horizontal(4),
                        Text(
                          shop.phone,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.horizontal(12),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: Colors.black54,
                          ),
                          AppSpacing.horizontal(4),
                          Flexible(
                            child: Text(
                              shop.email,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double paddingResponsive = DeviceSize.getResponsivePadding(
      MediaQuery.of(context).size.width,
    );

    return Stack(
      children: [
        Container(
          height: 450,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: _markers.values
                .toSet(), // Sử dụng Set<Marker> trực tiếp tại đây
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          right: 16,
          child: Row(
            children: [
              // Search TextField
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    controller: searchLocationController,
                    decoration: InputDecoration(
                      hintText: 'Chọn khu vực của bạn',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, size: 15),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: (value) {
                      // Có thể thêm logic tìm kiếm địa điểm ở đây sau
                    },
                  ),
                ),
              ),
              // Space between search and button
              AppSpacing.horizontalXS,
              // Location Button
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.my_location, color: Colors.black87, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Vị trí của tôi',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          height: 200,
          child: CustomCard.profile(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Các cửa hàng gần bạn nhất',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: _buildShopAddress(paddingResponsive),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
