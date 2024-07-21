import 'package:dars74_yandexmap/cubits/restoran_cubit.dart';
import 'package:dars74_yandexmap/cubits/restoran_state.dart';
import 'package:dars74_yandexmap/models/restoran.dart';
import 'package:dars74_yandexmap/services/yandex_map_service.dart';
import 'package:dars74_yandexmap/views/widgets/add_restoran_dialog.dart';
import 'package:dars74_yandexmap/views/widgets/show_restaurants_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeScreen extends StatefulWidget {
  Restoran? restaurantLocation;
  HomeScreen({super.key, this.restaurantLocation});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YandexMapController mapController;
  String currentLocationName = "";
  Set<PlacemarkMapObject> markers = {};
  List<PolylineMapObject> polylines = [];
  List<Point> positions = [];
  Point? myLocation;
  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );
  List<SearchItem> searchResults = [];
  RestoranCubit? cubitController;

  final Map<MapObjectId, Restoran> markerInfoMap = {};

  Future<void> searchLocation(Point point) async {
    try {
      final searchResultWithSession = await YandexSearch.searchByPoint(
        point: point,
        searchOptions: const SearchOptions(),
      );

      final searchResult = await searchResultWithSession.$2;

      setState(() {
        searchResults = searchResult.items ?? [];
      });
    } catch (e) {
      setState(() {
        searchResults = [];
      });
    }
  }

  void searchLocationByName(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      final searchResultWithSession = await YandexSearch.searchByText(
        searchText: query,
        geometry: Geometry.fromBoundingBox(
          const BoundingBox(
            northEast: Point(latitude: 55.771899, longitude: 37.632206),
            southWest: Point(latitude: 55.771000, longitude: 37.631000),
          ),
        ),
        searchOptions: const SearchOptions(),
      );

      final searchResult = await searchResultWithSession.$2;

      setState(() {
        searchResults = searchResult.items ?? [];
      });
    } catch (e) {
      setState(() {
        searchResults = [];
      });
    }
  }

  void showDistancePolylines(Point restaurantLocation) async {
    polylines =
        await YandexMapService.getDirection(myLocation!, restaurantLocation);

    setState(() {
      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: restaurantLocation,
            zoom: 20,
          ),
        ),
      );
    });
  }

  Future<void> onMapCreated(YandexMapController controller) async {
    mapController = controller;

    if (widget.restaurantLocation != null) {
      polylines = await YandexMapService.getDirection(
          najotTalim,
          Point(
              latitude: widget.restaurantLocation!.latLng.latitude,
              longitude: widget.restaurantLocation!.latLng.longitude));

      setState(() {
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                  latitude: widget.restaurantLocation!.latLng.latitude,
                  longitude: widget.restaurantLocation!.latLng.longitude),
              zoom: 20,
            ),
          ),
        );
      });
    } else {
      mapController.moveCamera(
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1,
        ),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: najotTalim,
            zoom: 18,
          ),
        ),
      );
    }

    Set<Point> restaurantPoints = cubitController!.getRestaurantsPoints();
    List<Point> lst = restaurantPoints.toList();
    if (lst.isNotEmpty) {
      List.generate(restaurantPoints.length, (int index) {
        addMarker(
            Point(
                latitude: lst[index].latitude, longitude: lst[index].longitude),
            cubitController!.getInfoByPoint(lst[index])!);
      });
    }
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finish,
  ) {
    myLocation = position.target;
    setState(() {});
  }

  void addMarker(Point location, Restoran restoran) async {
    final mapObjectId = MapObjectId(UniqueKey().toString());
    markers.add(
      PlacemarkMapObject(
        text: PlacemarkText(
            style: const PlacemarkTextStyle(), text: restoran.restaurantName),
        onTap: (mapObject, point) {
          final restoranInfo = markerInfoMap[mapObjectId];
          if (restoranInfo != null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "restaurant's name: ${restoranInfo.restaurantName}"),
                        Text(
                            "restaurant's location name: ${restoranInfo.locationName}"),
                        Text(
                            "restaurant's location latitude: ${restoranInfo.latLng.latitude}"),
                        Text(
                            "restaurant's location longitude: ${restoranInfo.latLng.longitude}"),
                        const SizedBox(height: 30),
                        Container(
                          clipBehavior: Clip.hardEdge,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.network(
                            restoranInfo.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok')),
                          ],
                        )
                      ],
                    ),
                  );
                });
          } else {
            print('Restaurant info not found');
          }
        },
        mapId: mapObjectId,
        point: location,
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              "assets/placemark.png",
            ),
            scale: 0.5,
          ),
        ),
      ),
    );

    markerInfoMap[mapObjectId] = restoran;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    cubitController = context.read<RestoranCubit>();
    return Scaffold(
      body: BlocBuilder<RestoranCubit, RestoranState>(
        builder: (context, state) {
          return Stack(
            children: [
              YandexMap(
                onMapCreated: onMapCreated,
                onCameraPositionChanged: onCameraPositionChanged,
                mapType: MapType.map,
                mapObjects: [
                  PlacemarkMapObject(
                    onTap: (mapObject, point) {
                      print('object');
                    },
                    mapId: const MapObjectId("najotTalim"),
                    point: najotTalim,
                    opacity: 1,
                    icon: PlacemarkIcon.single(
                      PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage(
                          "assets/placemark.png",
                        ),
                        scale: 0.5,
                      ),
                    ),
                  ),
                  ...markers,
                  ...polylines,
                ],
              ),
              const Align(
                child: Icon(
                  Icons.place,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1B1C1F),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const ShowRestaurantsList();
                    });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                await searchLocation(myLocation!);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddRestoranDialog(
                      locationName: searchResults.first.name,
                      latLng: myLocation!,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
