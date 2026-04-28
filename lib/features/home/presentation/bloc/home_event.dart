abstract class HomeEvent {
  const HomeEvent();
}

class GetProductsEvent extends HomeEvent {
  const GetProductsEvent();
}

class GetBestPriceEvent extends HomeEvent {
  const GetBestPriceEvent();
}

class GetBrandsEvent extends HomeEvent {
  const GetBrandsEvent();
}

class GetTrendsEvent extends HomeEvent {
  const GetTrendsEvent();
}

class SearchProductsEvent extends HomeEvent {
  final String query;
  const SearchProductsEvent(this.query);
}

class GetHomeDataEvent extends HomeEvent {
  const GetHomeDataEvent();
}
