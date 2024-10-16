class FilterModel {
  double? minPrice;
  double? maxPrice;
  String? sortBy;
  bool sortAscendant;

  FilterModel({
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.sortAscendant = true,
  });
}
