import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.router.dart';
import '../../app/locator.dart';
import '../../constants/asset_constants.dart';
import '../../shared/styles.dart';
import '../../views/shopping_cart/shopping_cart_view.dart';

class ProductCard extends StatelessWidget {
  final int? id;
  final String? floor;
  final String? state;
  final String? waitingListsInside;
  bool favoriteToggle;
  VoidCallback onMinusTap;
  VoidCallback onPlusTap;
  VoidCallback onFavoriteButtonTap;

  final _navigator = locator<NavigationService>();

  ProductCard({
    Key? key,
    required this.id,
    required this.floor,
    required this.state,
    required this.waitingListsInside,
    required this.favoriteToggle,
    required this.onMinusTap,
    required this.onPlusTap,
    required this.onFavoriteButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: waitingListsInside == '0' ? Colors.green : Colors.red,
          child: InkWell(
            onTap: () {
              // _navigator.replaceWith(Routes.shoppingCartView,);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ShoppingCartView(id: id, floor: floor, state: state,)),
              );
            },

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 21,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          child: FittedBox(
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    '0xFF',
                                  ),
                                ).withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8, top: 0),
                          child: const FittedBox(
                            child: Icon(Icons.local_parking, size: 40,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Text(
                //   '\$' + (id ?? 0).toString().padRight(4, '0'),
                //   style: paragraph6.copyWith(color: appGreenColor),
                // ),
                Text(
                  floor ?? '',
                  style: heading7.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  state ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'floor ${id! <= 6 ? 1 : id! <= 12 ? 2 : 3  }',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.amberAccent,
                  ),
                ),
                Container(
                  height: 1,
                  color: appGreySecondary,
                ),
              ],
            ),
          )
        ),
        Positioned(
            top: 9,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteButtonTap,
              child: Image.asset(
                favoriteToggle
                    ? AssetConstants.favoriteSelected
                    : AssetConstants.favoriteUnselected,
                width: 18,
                height: 16,
              ),
            ))
      ],
    );
  }
}
