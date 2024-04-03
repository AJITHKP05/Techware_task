import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/product.dart';
import '../../services/Repository/firestore_repository.dart';

part 'product_add_state.dart';

class ProductAddCubit extends Cubit<ProductAddState> {
  ProductAddCubit() : super(ProductAddInitial());
  final _fire = FireStoreRepository();
  Future addProduct(Product data) async {
    emit(ProductAddLoading());
    try {
      _fire.addProduct(data);
      emit(ProductAddSuccess());
    } catch (e) {
      emit(ProductAddError(error: "Error, failed to add"));
    }
  }
}
