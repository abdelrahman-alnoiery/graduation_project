import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories_usecase.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesBloc({required this.getCategoriesUseCase})
    : super(const CategoriesInitialState()) {
    on<GetCategoriesEvent>(_onGetCategories);
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoadingState());
    final result = await getCategoriesUseCase();
    result.fold(
      (failure) => emit(CategoriesErrorState(failure)),
      (categories) => emit(CategoriesSuccessState(categories)),
    );
  }
}
