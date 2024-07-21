import 'dart:async';

import 'package:dars74_yandexmap/cubits/restoran_state.dart';
import 'package:dars74_yandexmap/models/restoran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class RestoranCubit extends Cubit<RestoranState> {
  RestoranCubit() : super(InitialState());
  static List<Restoran> restoransList = [];
  static Set<Point> restaurantPoints = {};

  Future<void> addRestoran(Restoran restaurant) async {
    try {
      emit(LoadingState());
      restoransList.add(restaurant);
      emit(LoadedState(restoransList: restoransList));
      restaurantPoints.add(restaurant.latLng);
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  List<Restoran> getRestaurants() {
    return restoransList;
  }

  Set<Point> getRestaurantsPoints() {
    return restaurantPoints;
  }

  Restoran? getInfoByPoint(Point infoPoint) {
    print(infoPoint);
    for (Restoran restaurant in restoransList) {
      if (restaurant.latLng.latitude == infoPoint.latitude &&
          restaurant.latLng.longitude == infoPoint.longitude) {
        return restaurant;
      }
    }
    print('-----null----');
    return null;
  }
}
