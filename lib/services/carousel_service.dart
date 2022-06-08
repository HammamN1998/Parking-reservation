import 'package:big_cart/models/carousel_item_model.dart';
import 'package:injectable/injectable.dart';
import '../constants/asset_constants.dart';

@lazySingleton
class CarouselService {
  List<CarouselItem> getCarouselList() {
    List<CarouselItem> carouselList = <CarouselItem>[];
    carouselList.add(CarouselItem(
        text: '20% off on your\nfirst reservation',
        imagePath: AssetConstants.discountImage));
    carouselList.add(CarouselItem(
        text: 'No free parks ?!\nGo to waiting list',
        imagePath: AssetConstants.waitingList));
    carouselList.add(CarouselItem(
        text: 'Six parks\n in each floor',
        imagePath: AssetConstants.sixParks));
    carouselList.add(CarouselItem(
        text: 'Golden user?\nMore features for you!',
        imagePath: AssetConstants.goldenUser));
    return carouselList;
  }
}
