part of 'product_add_cubit.dart';

@immutable
sealed class ProductAddState {}

final class ProductAddInitial extends ProductAddState {}

final class ProductAddLoading extends ProductAddState {}

final class ProductAddSuccess extends ProductAddState {}

final class ProductAddError extends ProductAddState {
  final String error;

  ProductAddError({required this.error});
}
