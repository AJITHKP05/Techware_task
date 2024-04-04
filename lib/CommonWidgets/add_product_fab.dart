import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/Utils/toast.dart';
import 'package:task/model/product.dart';

import '../BlockPattern/product_add_cubit/product_add_cubit.dart';

class AddProductFab extends StatelessWidget {
  const AddProductFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: BlocProvider(
                  create: (context) => ProductAddCubit(),
                  child: const AddProductBottomSheet(),
                ));
          },
        );
      },
      tooltip: 'Add Product',
      child: const Icon(Icons.add),
    );
  }
}

class AddProductBottomSheet extends StatefulWidget {
  const AddProductBottomSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductBottomSheetState createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _measurementController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductAddCubit, ProductAddState>(
      listener: (context, state) {
        if (state is ProductAddSuccess) {
          successToast("Product added", context);
          Navigator.pop(context);
        }
        if (state is ProductAddError) {
          errorToast(state.error, context);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _measurementController,
                  decoration: const InputDecoration(labelText: 'Measurement'),
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter measurement';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  ],
                  controller: _priceController,
                  
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter price';
                    }
                    if (!RegExp(r'^-?\d*\.?\d+$').hasMatch(value ?? "")) {
                      return "Please provide a valid value";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: (state is ProductAddLoading)
                      ? null
                      : () {
                          
                            if (_formKey.currentState!.validate()) {
                              String productName = _productNameController.text;
                              String measurement = _measurementController.text;
                              double price =
                                  double.parse(_priceController.text);

                              context.read<ProductAddCubit>().addProduct(
                                  Product(
                                      measurement: measurement,
                                      name: productName,
                                      price: price));
                            }
                        },
                  child: (state is ProductAddLoading)
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Add',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _measurementController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
