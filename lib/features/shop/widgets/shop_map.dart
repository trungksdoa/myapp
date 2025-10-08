import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/features/home/service/branch_service';
import 'package:myapp/features/home/service/interface/branch.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Thêm import
import 'dart:io'; // ✅ Thêm import cho Platform

class ShopMap extends StatefulWidget {
  const ShopMap({super.key});

  @override
  State<ShopMap> createState() => _ShopMapState();
}

class _ShopMapState extends State<ShopMap> {
  GoogleMapController? _mapController;
  final Map<String, Marker> _markers = {};
  TextEditingController searchLocationController = TextEditingController();
  bool _isDisposed = false;

  final BranchService _branchService = BranchService();
  List<Branch>? _branches;
  bool _isLoadingBranches = false;
  bool _isGeocoding = false;

  bool _isExpanded = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.8231, 106.6297), // TP.HCM
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    setState(() {
      _isLoadingBranches = true;
    });

    try {
      final branches = await _branchService.fetchAllBranches();
      setState(() {
        _branches = branches;
        _isLoadingBranches = false;
      });
      print('✅ Loaded ${branches.length} branches');

      await _addMarkersFromBranches(branches);
    } catch (e) {
      setState(() {
        _isLoadingBranches = false;
      });
      print('❌ Error loading branches: $e');
    }
  }

  Future<void> _addMarkersFromBranches(List<Branch> branches) async {
    if (_isDisposed) return;

    setState(() {
      _isGeocoding = true;
    });

    for (int i = 0; i < branches.length; i++) {
      final branch = branches[i];

      try {
        List<Location> locations = await locationFromAddress(branch.address);
        if (locations.isNotEmpty) {
          final location = locations.first;

          final markerId = MarkerId('branch_${branch.id}');
          final marker = Marker(
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
              title: 'Chi nhánh ${i + 1}',
              snippet: branch.address,
            ),
          );

          if (mounted && !_isDisposed) {
            setState(() {
              _markers[markerId.value] = marker;
            });
          }

          print(
            '✅ Geocoded branch ${branch.id}: ${location.latitude}, ${location.longitude}',
          );
        }
      } catch (e) {
        print('❌ Error geocoding branch ${branch.id}: $e');
      }
    }

    setState(() {
      _isGeocoding = false;
    });
  }

  void _goToBranchLocation(Branch branch) async {
    if (_isDisposed || _mapController == null) return;

    try {
      List<Location> locations = await locationFromAddress(branch.address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Error geocoding for navigation: $e');
    }
  }

  // ✅ Method mở Google Maps để chỉ đường
  Future<void> _openGoogleMapsDirections(Branch branch) async {
    try {
      List<Location> locations = await locationFromAddress(branch.address);

      if (locations.isEmpty) {
        throw 'Không tìm thấy địa chỉ';
      }

      final lat = locations.first.latitude;
      final lng = locations.first.longitude;

      Uri mapsUrl;

      if (Platform.isIOS) {
        // ✅ iOS: Dùng Apple Maps scheme
        mapsUrl = Uri.parse('maps://?daddr=$lat,$lng&dirflg=d');
      } else {
        // ✅ Android: Dùng Google Maps web URL (hoặc có thể dùng 'geo:$lat,$lng?q=$lat,$lng' nếu muốn)
        mapsUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
        );
      }

      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Không thể mở ứng dụng bản đồ';
      }
    } catch (e) {
      print('❌ Error opening Maps: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở bản đồ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isDisposed) return;

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

      if (_isDisposed || _mapController == null) return;

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );

      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật vị trí hiện tại'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lấy vị trí: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ Update _buildBranchList với button chỉ đường
  List<Widget> _buildBranchList(double paddingResponsive) {
    if (_branches == null) {
      return [const Center(child: Text('Không có dữ liệu chi nhánh'))];
    }

    return _branches!.map((branch) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
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
              // Address
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
                      branch.address,
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

              // Phone
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: Colors.black54,
                  ),
                  AppSpacing.horizontal(4),
                  Text(
                    branch.phoneNumber,
                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ],
              ),
              AppSpacing.vertical(8),

              // ✅ Action buttons
              Row(
                children: [
                  // Button xem trên map
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _goToBranchLocation(branch),
                      icon: const Icon(Icons.map_outlined, size: 16),
                      label: const Text('Xem', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ✅ Button chỉ đường - MỞ GOOGLE MAPS
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openGoogleMapsDirections(branch),
                      icon: const Icon(Icons.directions, size: 16),
                      label: const Text(
                        'Chỉ đường',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    _mapController = null;
    _markers.clear();
    searchLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paddingResponsive = DeviceSize.getResponsivePadding(
      MediaQuery.of(context).size.width,
    );

    return Stack(
      children: [
        // Map
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
              if (!_isDisposed) {
                setState(() {
                  _mapController = controller;
                });
              }
            },
            markers: _markers.values.toSet(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
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

        // Dropdown chi nhánh
        Positioned(
          top: 20,
          left: 16,
          right: 16,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: _isExpanded ? 320 : 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Các chi nhánh gần bạn nhất',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_isLoadingBranches || _isGeocoding)
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 250),
                            turns: _isExpanded ? 0.5 : 0,
                            child: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  if (_isExpanded)
                    Expanded(
                      child: _isLoadingBranches
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              children: _buildBranchList(paddingResponsive),
                            ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Button "Vị trí của tôi"
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          top: _isExpanded ? 350 : 90,
          left: 16,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: _getCurrentLocation,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.my_location,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Vị trí của tôi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
