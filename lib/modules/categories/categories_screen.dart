import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/cubit/shop_cubit.dart';
import 'package:shop_application/layout/cubit/shop_states.dart';
import 'package:shop_application/models/categories_model.dart';
import 'package:shop_application/shared/components/components.dart';
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),

          itemBuilder: (BuildContext context, int index) => buildCatItem(
              ShopCubit.get(context).categoriesModel.data.data[index]),
          separatorBuilder: (BuildContext context, int index) => myDivider(),
          itemCount: ShopCubit.get(context).categoriesModel.data.data.length,
        );
      },
    );
  }

  Widget buildCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                model.image,
              ),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              model.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}
