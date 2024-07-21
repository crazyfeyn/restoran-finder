import 'package:dars74_yandexmap/cubits/restoran_cubit.dart';
import 'package:dars74_yandexmap/models/restoran.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowRestaurantsList extends StatefulWidget {
  const ShowRestaurantsList({super.key});

  @override
  State<ShowRestaurantsList> createState() => _ShowRestaurantsListState();
}

class _ShowRestaurantsListState extends State<ShowRestaurantsList> {
  @override
  Widget build(BuildContext context) {
    final cubitController = context.read<RestoranCubit>();
    List<Restoran> restaurantsList = cubitController.getRestaurants();
    return cubitController.getRestaurants().isEmpty
        ? AlertDialog(
            content: Center(
            child: Text('Empty list'),
          ))
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                ...List.generate(restaurantsList.length, (int index) {
                  final Restoran restaurant = restaurantsList[index];
                  return ListTile(
                    leading: Container(
                      clipBehavior: Clip.hardEdge,
                      height: double.infinity,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        restaurant.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(restaurant.restaurantName),
                    subtitle: Text(restaurant.locationName),
                  );
                })
              ],
            ),
          );
  }
}
