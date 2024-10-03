import 'package:unitrade/screens/home/models/filter_model.dart';
import 'package:unitrade/screens/home/models/product_model.dart';

class FilterViewModel {
  static List<ProductModel> filterProducts({
    required List<ProductModel> allProducts,
    required String selectedCategory,
    required String searchQuery,
    required FilterModel filters,
    required List<String> userCategories,
  }) {
    return allProducts.where((product) {
      // Filtrar por categoría si hay una seleccionada
      if (selectedCategory == 'For You') {
        bool matchesUserCategories = product.categories
            .any((category) => userCategories.contains(category));
        if (!matchesUserCategories) {
          return false;
        }
      } else {
        // Filtrar por categoría si hay una seleccionada y no es "For You"
        if (selectedCategory != '' &&
            !product.categories.contains(selectedCategory)) {
          return false;
        }
      }

      // Filtrar por el texto de búsqueda (case-insensitive)
      if (searchQuery != '' &&
          !product.name.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }

      // Filtrar por precio mínimo
      if (filters.minPrice != null && product.price < filters.minPrice!) {
        return false;
      }

      // Filtrar por precio máximo
      if (filters.maxPrice != null && product.price > filters.maxPrice!) {
        return false;
      }

      // Filtrar por calificación mínima
      if (filters.minRate != null && product.rating < filters.minRate!) {
        return false;
      }

      // Filtrar por calificación máxima
      if (filters.maxRate != null && product.rating > filters.maxRate!) {
        return false;
      }

      return true;
    }).toList();
  }
}
