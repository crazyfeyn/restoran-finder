import 'package:dars74_yandexmap/cubits/restoran_cubit.dart';
import 'package:dars74_yandexmap/models/restoran.dart';
import 'package:dars74_yandexmap/views/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddedNewRestaurant extends StatefulWidget {
  Restoran restaurant;
  AddedNewRestaurant({super.key, required this.restaurant});

  @override
  State<AddedNewRestaurant> createState() => _AddedNewRestaurantState();
}

class _AddedNewRestaurantState extends State<AddedNewRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("restaurant's name: ${widget.restaurant.restaurantName}"),
            Text(
                "restaurant's location name: ${widget.restaurant.locationName}"),
            Text(
                "restaurant's location latitude: ${widget.restaurant.latLng.latitude}"),
            Text(
                "restaurant's location longitude: ${widget.restaurant.latLng.longitude}"),
            const SizedBox(height: 30),
            Container(
              clipBehavior: Clip.hardEdge,
              width: 200,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.network(
                widget.restaurant.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: const Text('Back')),
                FilledButton(
                    onPressed: () {
                      print('--------');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    restaurantLocation:
                                        widget.restaurant
                                  )));
                    },
                    child: const Text('Go'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
