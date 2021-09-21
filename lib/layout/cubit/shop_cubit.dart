import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/cubit/shop_states.dart';
import 'package:shop_application/models/categories_model.dart';
import 'package:shop_application/models/change_favorite_model.dart';
import 'package:shop_application/models/favorites_model.dart';
import 'package:shop_application/models/home_model.dart';
import 'package:shop_application/models/login_model.dart';
import 'package:shop_application/modules/categories/categories_screen.dart';
import 'package:shop_application/modules/favorites/favorites_screen.dart';
import 'package:shop_application/modules/products/products_screen.dart';
import 'package:shop_application/modules/settings/settings_screen.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/network/end_points.dart';
import 'package:shop_application/shared/network/remote/dio_helper.dart';


class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavBarState());
  }

  /*bool isDark=false;

  void changeThemeMode({bool fromShared}){
    if(fromShared!=null){
      isDark=fromShared;
      emit(ChangeThemeModeState());
    }else{
      isDark=!isDark;
      CacheHelper.sharedPreferences.setBool("isDark", isDark).then((value) {
        emit(ChangeThemeModeState());
      });
    }
  }*/

  HomeModel homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(LoadingHomeState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      print(favorites.toString());
      emit(SuccessHomeState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorHomeState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategoriesModel() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(SuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoriesState());
    });
  }

  ChangeFavoritesModel changeFavoritesModel;

  void toggleFavorites(productId) {
    favorites[productId] = !favorites[productId];
    emit(ChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        "product_id": productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (!changeFavoritesModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavorites();
      }
      emit(SuccessChangeFavoritesState(changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId];
      emit(ErrorChangeFavoritesState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(LoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(SuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetFavoritesState());
    });
  }

  LoginModel userModel;

  void getUserData() {
    emit(LoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(SuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUserDataState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(LoadingUpdateDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(SuccessUpdateDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateDataState());
    });
  }
}
