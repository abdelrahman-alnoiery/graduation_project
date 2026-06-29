import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/api_manger.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../models/order_model.dart';
import 'my_orders_remote_datasource.dart';

class MyOrdersRemoteDatasourceImpl implements MyOrdersRemoteDatasource {
  @override
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await ApiManager.get(EndPoints.myOrders);
      print('✅ My Orders Response: ${response.data}');

      List data = [];
      if (response.data is List) {
        data = response.data as List;
      } else if (response.data is Map) {
        data =
            (response.data['orders'] ??
                    response.data['data'] ??
                    response.data['myOrders'] ??
                    [])
                as List;
      }

      return data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
