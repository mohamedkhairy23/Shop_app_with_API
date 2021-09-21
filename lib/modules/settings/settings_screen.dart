import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/cubit/shop_cubit.dart';
import 'package:shop_application/layout/cubit/shop_states.dart';
import 'package:shop_application/shared/components/components.dart';
import 'package:shop_application/shared/components/constants.dart';
import 'package:shop_application/shared/styles/colors.dart';


// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  SettingsScreen({key}) : super(key: key);
  var formKey=GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if(state is LoadingUpdateDataState)
                      LinearProgressIndicator(),
                    SizedBox(height: 20,),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Name must not be empty";
                        }
                        return null;
                      },
                      label: "Name",
                      prefix: Icons.person,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Email must not be empty";
                        }
                        return null;
                      },
                      label: "Email",
                      prefix: Icons.email,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Phone must not be empty";
                        }
                        return null;
                      },
                      label: "Phone",
                      prefix: Icons.phone,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    defaultButton(
                      function: () {
                        signOut(context);
                      },
                      background: defaultColor,
                      text: "SIGN OUT",
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    defaultButton(
                      function: () {
                        if(formKey.currentState.validate())
                        ShopCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      },
                      background: defaultColor,
                      text: "UPDATE",
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
