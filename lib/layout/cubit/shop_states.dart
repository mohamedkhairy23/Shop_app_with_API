

import 'package:shop_application/models/change_favorite_model.dart';
import 'package:shop_application/models/login_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavBarState extends ShopStates{}

class ChangeThemeModeState extends ShopStates{}

class LoadingHomeState extends ShopStates{}

class SuccessHomeState extends ShopStates{}

class ErrorHomeState extends ShopStates{}

class SuccessCategoriesState extends ShopStates {}

class ErrorCategoriesState extends ShopStates {}

class SuccessChangeFavoritesState extends ShopStates
{
  final ChangeFavoritesModel model;

  SuccessChangeFavoritesState(this.model);
}

class ChangeFavoritesState extends ShopStates{}

class ErrorChangeFavoritesState extends ShopStates {}

class LoadingGetFavoritesState extends ShopStates {}

class SuccessGetFavoritesState extends ShopStates {}

class ErrorGetFavoritesState extends ShopStates {}

class LoadingUserDataState extends ShopStates {}

class SuccessUserDataState extends ShopStates {
  final LoginModel loginModel;

  SuccessUserDataState(this.loginModel);
}

class ErrorUserDataState extends ShopStates {}

class LoadingUpdateDataState extends ShopStates {}

class SuccessUpdateDataState extends ShopStates {
  final LoginModel loginModel;

  SuccessUpdateDataState(this.loginModel);
}

class ErrorUpdateDataState extends ShopStates {}

