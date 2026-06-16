import 'dart:io';

import 'package:graduation_project/features/add_product/data/models/add_product_request_model.dart';

import '../../models/add_product_response_model.dart';

abstract class AddProductRemoteDatasource {
  Future<AddProductResponseModel> addProduct({
    required AddProductRequestModel request,
    required List<File> images,
  });
}
