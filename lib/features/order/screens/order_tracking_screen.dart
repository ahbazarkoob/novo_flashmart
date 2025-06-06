import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:novo_flashMart/features/location/controllers/location_controller.dart';
import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/features/notification/domain/models/notification_body_model.dart';
import 'package:novo_flashMart/features/address/domain/models/address_model.dart';
import 'package:novo_flashMart/features/chat/domain/models/conversation_model.dart';
import 'package:novo_flashMart/features/order/controllers/order_controller.dart';
import 'package:novo_flashMart/features/order/domain/models/order_model.dart';
import 'package:novo_flashMart/features/store/domain/models/store_model.dart';
import 'package:novo_flashMart/helper/address_helper.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/helper/route_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/images.dart';
import 'package:novo_flashMart/common/widgets/custom_app_bar.dart';
import 'package:novo_flashMart/common/widgets/menu_drawer.dart';
import 'package:novo_flashMart/features/order/widgets/track_details_view_widget.dart';
import 'package:novo_flashMart/features/order/widgets/tracking_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../util/app_constants.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final String? contactNumber;
  const OrderTrackingScreen(
      {super.key, required this.orderID, this.contactNumber});

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  final Set<Polyline> _polyline = <Polyline>{};
  // List<MarkerData> _customMarkers = [];
  Timer? _timer;

  void _loadData() async {
    await Get.find<OrderController>().trackOrder(widget.orderID, null, true,
        contactNumber: widget.contactNumber);
    await Get.find<LocationController>().getCurrentLocation(true,
        notify: false,
        defaultLatLng: LatLng(
          double.parse(AddressHelper.getUserAddressFromSharedPref()!.latitude!),
          double.parse(
              AddressHelper.getUserAddressFromSharedPref()!.longitude!),
        ));
  }

  void _startApiCall() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().timerTrackOrder(widget.orderID.toString(),
          contactNumber: widget.contactNumber);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
    _startApiCall();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _timer?.cancel();
  }

  // Widget _customMarker(String path) {
  //   return Stack(
  //     children: [
  //       Image.asset(Images.locationMarker, height: 40, width: 40),
  //       Positioned(top: 3, left: 0, right: 0, child: Center(
  //         child: ClipOval(child: CustomImage(image: path, placeholder: Images.userMarker, height: 20, width: 20, fit: BoxFit.cover)),
  //       )),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order_tracking'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<OrderController>(builder: (orderController) {
        OrderModel? track;
        if (orderController.trackModel != null) {
          track = orderController.trackModel;

          /*if(_controller != null && GetPlatform.isWeb) {
            if(_track.deliveryAddress != null) {
              _controller.showMarkerInfoWindow(MarkerId('destination'));
            }
            if(_track.store != null) {
              _controller.showMarkerInfoWindow(MarkerId('store'));
            }
            if(_track.deliveryMan != null) {
              _controller.showMarkerInfoWindow(MarkerId('delivery_boy'));
            }
          }*/
        }

        return track != null
            ? Center(
                child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Stack(children: [
                      GoogleMap(
                        polylines: _polyline,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(track.deliveryAddress!.latitude!),
                              double.parse(track.deliveryAddress!.longitude!),
                            ),
                            zoom: 16),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        zoomControlsEnabled: true,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          _isLoading = false;
                          setMarker(
                            track!.orderType == 'parcel'
                                ? Store(
                                    latitude: track.receiverDetails!.latitude,
                                    longitude: track.receiverDetails!.longitude,
                                    address: track.receiverDetails!.address,
                                    name: track
                                        .receiverDetails!.contactPersonName)
                                : track.store,
                            track.deliveryMan,
                            track.orderType == 'take_away'
                                ? Get.find<LocationController>()
                                            .position
                                            .latitude ==
                                        0
                                    ? track.deliveryAddress
                                    : AddressModel(
                                        latitude: Get.find<LocationController>()
                                            .position
                                            .latitude
                                            .toString(),
                                        longitude:
                                            Get.find<LocationController>()
                                                .position
                                                .longitude
                                                .toString(),
                                        address: Get.find<LocationController>()
                                            .address,
                                      )
                                : track.deliveryAddress,
                            track.orderStatus!,
                            track.orderType == 'take_away',
                            track.orderType == 'parcel',
                            track.moduleType == 'food',
                          );
                        },
                      ),

                      /* CustomGoogleMapMarkerBuilder(
            customMarkers: _customMarkers,
            builder: (context, markers) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(
                  double.parse(track!.deliveryAddress!.latitude!), double.parse(track.deliveryAddress!.longitude!),
                ), zoom: 16),
                minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                zoomControlsEnabled: true,
                markers: markers ?? HashSet(),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _isLoading = false;
                  setMarker(
                    track!.orderType == 'parcel' ? Store(latitude: track.receiverDetails!.latitude, longitude: track.receiverDetails!.longitude,
                        address: track.receiverDetails!.address, name: track.receiverDetails!.contactPersonName) : track.store, track.deliveryMan,
                    track.orderType == 'take_away' ? Get.find<LocationController>().position.latitude == 0 ? track.deliveryAddress : AddressModel(
                      latitude: Get.find<LocationController>().position.latitude.toString(),
                      longitude: Get.find<LocationController>().position.longitude.toString(),
                      address: Get.find<LocationController>().address,
                    ) : track.deliveryAddress, track.orderType == 'take_away', track.orderType == 'parcel',
                  );
                },
              );
            },
          ),*/

                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox(),
                      Positioned(
                        top: Dimensions.paddingSizeSmall,
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                        child: TrackingStepperWidget(
                            status: track.orderStatus,
                            takeAway: track.orderType == 'take_away'),
                      ),
                      Positioned(
                        bottom: Dimensions.paddingSizeSmall,
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                        child: TrackDetailsViewWidget(
                            status: track.orderStatus,
                            track: track,
                            callback: () async {
                              _timer?.cancel();
                              await Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBodyModel(
                                    deliverymanId: track!.deliveryMan!.id,
                                    orderId: int.parse(widget.orderID!)),
                                user: User(
                                    id: track.deliveryMan!.id,
                                    fName: track.deliveryMan!.fName,
                                    lName: track.deliveryMan!.lName,
                                    image: track.deliveryMan!.image),
                              ));
                              _startApiCall();
                            }),
                      ),
                    ])))
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void setMarker(
      Store? store,
      DeliveryMan? deliveryMan,
      AddressModel? addressModel,
      String orderStatus,
      bool takeAway,
      bool parcel,
      bool isRestaurant) async {
    try {
      Uint8List restaurantImageData = await convertAssetToUnit8List(
          parcel
              ? Images.userMarker
              : isRestaurant
                  ? Images.restaurantMarker
                  : Images.markerStore,
          width: (isRestaurant || parcel) ? 100 : 150);
      Uint8List deliveryBoyImageData =
          await convertAssetToUnit8List(Images.deliveryManMarker, width: 100);
      Uint8List destinationImageData = await convertAssetToUnit8List(
        takeAway ? Images.myLocationMarker : Images.userMarker,
        width: takeAway ? 50 : 100,
      );
      debugPrint("Order Status == $orderStatus");

      // Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if (_controller != null) {
        if (double.parse(addressModel!.latitude!) <
            double.parse(store!.latitude!)) {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
            northeast: LatLng(
                double.parse(store.latitude!), double.parse(store.longitude!)),
          );
          rotation = 0;
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(
                double.parse(store.latitude!), double.parse(store.longitude!)),
            northeast: LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
          );
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 17)));
      if (!ResponsiveHelper.isWeb()) {
        zoomToFit(_controller, bounds, centerBounds, padding: 1.5);
      }

      /// user for normal order , but sender for parcel order
      _markers = HashSet<Marker>();
      // _customMarkers = [];
      addressModel != null
          ? _markers.add(Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(double.parse(addressModel.latitude!),
                  double.parse(addressModel.longitude!)),
              infoWindow: InfoWindow(
                title: parcel ? 'Sender' : 'Destination',
                snippet: addressModel.address,
              ),
              icon: GetPlatform.isWeb
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.bytes(destinationImageData),
            ))
          : const SizedBox();
      /*addressModel != null ? _customMarkers.add(MarkerData(
        marker: Marker(markerId: const MarkerId('destination'),
          position: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
          infoWindow: InfoWindow(
            title: parcel ? 'Sender' : 'Destination',
            snippet: addressModel.address,
          ),
        ),
        child:  GetPlatform.isWeb ? const Icon(Icons.location_on, size: 18) : _customMarker('${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${''}'),
      )) : const SizedBox();*/

      ///store for normal order , but receiver for parcel order
      store != null
          ? _markers.add(Marker(
              markerId: const MarkerId('store'),
              position: LatLng(double.parse(store.latitude!),
                  double.parse(store.longitude!)),
              infoWindow: InfoWindow(
                title: parcel
                    ? 'Receiver'
                    : Get.find<SplashController>()
                            .configModel!
                            .moduleConfig!
                            .module!
                            .showRestaurantText!
                        ? 'store'.tr
                        : 'store'.tr,
                snippet: store.address,
              ),
              icon: GetPlatform.isWeb
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.bytes(restaurantImageData),
            ))
          : const SizedBox();

      /*store != null ? _customMarkers.add(MarkerData(
        marker: Marker(markerId: const MarkerId('store'),
          position: LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
          infoWindow: InfoWindow(
            title: parcel ? 'Receiver' : Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'store'.tr : 'store'.tr,
            snippet: store.address,
          ),
        ),
        child: GetPlatform.isWeb ? const Icon(Icons.location_on, size: 18) : _customMarker('${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store.logo}'),
      )) : const SizedBox();*/

      deliveryMan != null
          ? _markers.add(Marker(
              markerId: const MarkerId('delivery_boy'),
              position: LatLng(double.parse(deliveryMan.lat ?? '0'),
                  double.parse(deliveryMan.lng ?? '0')),
              infoWindow: InfoWindow(
                title: 'delivery_man'.tr,
                snippet: deliveryMan.location,
              ),
              rotation: 0,
              icon: GetPlatform.isWeb
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.bytes(deliveryBoyImageData),
            ))
          : const SizedBox();

      if (orderStatus == 'pending' ||
          orderStatus == 'accepted' ||
          orderStatus == 'confirmed' ||
          orderStatus == 'processing') {
        if (store != null && addressModel != null) {
          debugPrint('before store await');
          debugPrint("Store   lat: ${store.latitude} long: ${store.longitude}");
          await _addPolylineUsingOSRM(
              LatLng(double.parse(store.latitude!),
                  double.parse(store.longitude!)),
              LatLng(double.parse(addressModel.latitude!),
                  double.parse(addressModel.longitude!)),
              Colors.blue,
              "storeToUserPolyline");
          debugPrint('after store await');
        }
        // store != null && addressModel != null
        //     ? _polyline.add(Polyline(
        //         polylineId: const PolylineId('storeToUserPolyline'),
        //         visible: true,
        //         points: [
        //           LatLng(double.parse(store.latitude!),
        //               double.parse(store.longitude!)),
        //           LatLng(double.parse(addressModel.latitude!),
        //               double.parse(addressModel.longitude!))
        //         ],
        //         color: Colors.blue,
        //         width: 1,
        //         patterns: [PatternItem.dash(15), PatternItem.gap(10)]))
        //     : const SizedBox();
      } else if (orderStatus == 'accepted' ||
          orderStatus == 'confirmed' ||
          orderStatus == 'processing' ||
          orderStatus == 'handover' ||
          orderStatus == 'picked_up' ||
          orderStatus == 'delivered') {
        if (deliveryMan != null && addressModel != null) {
          debugPrint('before  deliveryMan await');
          debugPrint(
              "DeliveryMan   lat: ${deliveryMan.lat} long: ${deliveryMan.lng}");
          await _addPolylineUsingOSRM(
            LatLng(
                double.parse(deliveryMan.lat!), double.parse(deliveryMan.lng!)),
            LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
            Colors.red,
            'deliverPersonToUserPolyline',
          );
          debugPrint('after deliveryMan await');
        }
      }

      /*deliveryMan != null ? _customMarkers.add(MarkerData(
        marker: Marker(markerId: const MarkerId('delivery_boy'),
          position: LatLng(double.parse(deliveryMan.lat ?? '0'), double.parse(deliveryMan.lng ?? '0')),
          infoWindow: InfoWindow(
            title: 'delivery_man'.tr,
            snippet: deliveryMan.location,
          ),
        ),
        child: GetPlatform.isWeb ? const Icon(Icons.location_on, size: 18) : _customMarker('${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${deliveryMan.image}'),
      )) : const SizedBox();*/
    } catch (e) {
      debugPrint("Error in setMarker: $e");
    }
    setState(() {});
  }

  Future<void> _addPolylineUsingOSRM(
      LatLng start, LatLng end, Color color, String polylineId) async {
    final response = await http.get(
      Uri.parse(
          '${AppConstants.polyLineUri}${start.longitude},${start.latitude};${end.longitude},${end.latitude}?alternatives=3&overview=full'),
    );
    debugPrint('polyLine Response   ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final polyline = data['routes'][0]['geometry'];
        debugPrint('polyline $polyline');
        final decodedPolyline = _decodePolyline(polyline);
        debugPrint('decoded Polyline $decodedPolyline');
        setState(() {
          _polyline.add(Polyline(
            polylineId: PolylineId(polylineId),
            visible: true,
            points: decodedPolyline,
            color: color,
            width: 4,
          ));
        });
      } else {
        debugPrint('No routes found in OSRM Response');
      }
    } else {
      debugPrint("Failed to load route : ${response.statusCode}");
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds,
      LatLng centerBounds,
      {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if (fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
