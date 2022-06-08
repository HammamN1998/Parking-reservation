import 'package:big_cart/viewmodels/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../shared/helpers.dart';
import '../../widgets/dumb/product_card.dart';

class ProductCategoryGridList extends ViewModelWidget<CategoryViewModel> {
  const ProductCategoryGridList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, CategoryViewModel viewModel) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth(context) > screenHeight(context) ? 4 : 2,
          childAspectRatio: 181 / 234,
          crossAxisSpacing: 18,
          mainAxisSpacing: 20),
      padding: const EdgeInsets.only(left: 17, right: 17, bottom: 17, top: 13),
      itemCount: viewModel.products.length,
      itemBuilder: (context, index) => ProductCard(
        id: viewModel.products[index].id,
        floor: viewModel.products[index].floor,
        state: viewModel.products[index].state,
        waitingListsInside: viewModel.products[index].waitingListsInside,
        onMinusTap: () => viewModel.removeFromCart(viewModel.products[index]),
        onPlusTap: () => viewModel.addToCart(viewModel.products[index]),
        onFavoriteButtonTap: () =>
            viewModel.addOrRemoveFavorites(viewModel.products[index]),
        favoriteToggle: viewModel.isFavorited(viewModel.products[index]),
      ),
      shrinkWrap: true,
      primary: false,
    );
  }
}
