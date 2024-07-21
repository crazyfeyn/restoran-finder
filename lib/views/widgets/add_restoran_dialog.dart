import 'package:dars74_yandexmap/cubits/restoran_cubit.dart';
import 'package:dars74_yandexmap/cubits/restoran_state.dart';
import 'package:dars74_yandexmap/models/restoran.dart';
import 'package:dars74_yandexmap/views/widgets/added_new_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddRestoranDialog extends StatefulWidget {
  final String locationName;
  final Point latLng;

  AddRestoranDialog({
    super.key,
    required this.locationName,
    required this.latLng,
  });

  @override
  State<AddRestoranDialog> createState() => _AddRestoranDialogState();
}

class _AddRestoranDialogState extends State<AddRestoranDialog> {
  final _restaurantNameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubitController = context.read<RestoranCubit>();
    return AlertDialog(
      title: Text(widget.locationName),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Latitude: ${widget.latLng.latitude}"),
              Text("Longitude: ${widget.latLng.longitude}"),
              SizedBox(height: 10),
              TextFormField(
                controller: _restaurantNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Restaurant Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a restaurant name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Restoran\'s image url',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image url';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubitController.addRestoran(Restoran(
                        restaurantName: _restaurantNameController.text,
                        locationName: widget.locationName,
                        latLng: widget.latLng,
                        imageUrl: _imageUrlController.text));
                      
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddedNewRestaurant(
                                restaurant: Restoran(
                                    restaurantName:
                                        _restaurantNameController.text,
                                    locationName: widget.locationName,
                                    latLng: widget.latLng, imageUrl: _imageUrlController.text))));
                  }
                },
                child: Text('Add Restaurant'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    super.dispose();
  }
}
