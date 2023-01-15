import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.router.dart';
import '../../app/locator.dart';
import '../../shared/styles.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/home_viewmodel_reserved_parks.dart';

class CustomHomeDrawerReserved extends ViewModelWidget<HomeViewReservedParksModel> {
  CustomHomeDrawerReserved({
    Key? key,
  }) : super(key: key);

  final _navigator = locator<NavigationService>();
  @override
  Widget build(BuildContext context, HomeViewReservedParksModel viewModel) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: appGreyColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      color: appGreySecondary,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: appGreySecondary,
                    size: 50,
                  ),
                ),
                Text(
                  viewModel.email ?? '',
                  style: paragraph1.copyWith(color: appGreySecondary),
                ),
                const SizedBox(height: 17),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   'Balance',
                //   style: heading7.copyWith(color: appGreyColor),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 1),
                //   child: Text(
                //     'Rs.3566',
                //     style: heading7.copyWith(color: appGreyColor),
                //   ),
                // )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 1,
            color: appGreyColor,
          ),
          ListTile(
            onTap: () {
              _navigator.replaceWith(Routes.homeView);
            },
            leading: const Icon(
              Icons.local_parking,
              color: appGreyColor,
            ),
            title: Text(
              'All Parks',
              style: heading7.copyWith(color: appGreyColor),
            ),
          ),
          ListTile(
            onTap: () {
              _navigator.replaceWith(Routes.homeViewReserved);
            },
            leading: const Icon(
              Icons.local_parking,
              color: appGreyColor,
            ),
            title: Text(
              'Free Parks',
              style: heading7.copyWith(color: appGreyColor),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              FocusManager.instance.primaryFocus?.unfocus();
              viewModel.logoutUser();
            },
            leading: const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Icon(
                Icons.logout,
                color: appGreyColor,
              ),
            ),
            title: Text(
              'Logout',
              style: heading7.copyWith(color: appGreyColor),
            ),
          ),
        ],
      ),
    );
  }
}
