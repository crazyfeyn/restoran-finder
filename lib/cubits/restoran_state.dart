import 'package:dars74_yandexmap/models/restoran.dart';

sealed class RestoranState {}

final class InitialState extends RestoranState {}

final class LoadingState extends RestoranState {}

final class LoadedState extends RestoranState {
  List<Restoran> restoransList = [];

  LoadedState({required this.restoransList});
}

final class ErrorState extends RestoranState {
  String message;

  ErrorState({required this.message});
}
