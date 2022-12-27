import 'package:big_cart/views/home/title_with_arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../shared/helpers.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/home_viewmodel_reserved_parks.dart';
import '../../widgets/dumb/product_card.dart';

class ProductGridListReserved extends ViewModelWidget<HomeViewReservedParksModel> {
  const ProductGridListReserved({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewReservedParksModel viewModel) {
    return Column(
      children: [
        TitleWithArrowButton( title: 'Number Of Free Parks: ${viewModel.freeParks}'),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth(context) > screenHeight(context) ? 4 : 2,
              childAspectRatio: 181 / 234,
              crossAxisSpacing: 18,
              mainAxisSpacing: 20),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
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
        ),
      ],
    );
  }
}
