import 'package:big_cart/shared/styles.dart';
import 'package:big_cart/viewmodels/home_viewmodel.dart';
import 'package:big_cart/views/home/product_grid_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/dumb/expandable_fab.dart';
import '../../widgets/dumb/loading_indicator.dart';
import '../../widgets/dumb/page_error_indicator.dart';
import 'banner_carousel.dart';
import 'category_containers.dart';
import 'custom_home_drawer.dart';
import 'floating_cart_button.dart';
import 'logout_loading_screen.dart';
import 'search_bar.dart';
import 'title_with_arrow_button.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      );
    });
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) => {
        viewModel.onModelReady(),
      },
      fireOnModelReadyOnce: false,
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (model.onlyProducts) {
            model.onlyProducts = false;
            model.onModelReady();
            FocusManager.instance.primaryFocus?.unfocus();
            return false;
          } else {
            return true;
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              Scaffold(
                drawer: CustomHomeDrawer(),
                body: Column(
                  children: [
                    // const SearchBar(),
                    const SizedBox(height: 40,),
                    Expanded(
                      child: model.hasError
                          ? const PageErrorIndicator()
                          : model.isLoading
                              ? const LoadingIndicator()
                              : ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    if (!model.onlyProducts) ...[
                                      BannerCarousel(items: model.carouselList),
                                    ],
                                    if (model.onlyProducts &&
                                        model.products.isEmpty)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 13),
                                          child: Text(
                                            'No products found',
                                            style: paragraph1,
                                          ),
                                        ),
                                      ),
                                    const ProductGridList(),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
              const LogoutLoadingScreen(),
            ],
          ),
        ),
      ),
    );
  }
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }
}
