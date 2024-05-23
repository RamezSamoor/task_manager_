
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/core/utils/routing/routes.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/utitlities.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loader_widget.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../../models/login_request_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<LoginPage> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController  _controllerPassword = TextEditingController();


  final FocusNode _focusNodeUsername = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  late final LoginCubit _loginCubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _loginCubit = getIt<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor ,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _titleWidget(),
                      _fieldsWidget(),
                      _loginButtonWidget(),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButtonWidget() {
    return Padding(
      padding: EdgeInsets.only(
        top: 3.h,
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (context , state){
            state.mapOrNull(
              loaded: (loaded){
                Navigator.pushReplacementNamed(context, AppRoutes.homeRoute );
              },
              error: (error){
                showErrorMessage(error.error);
              }
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
                loading: () => loaderWidget(),
                orElse: () {
                  return CustomButton(
                    buttonColor: AppColors.blueGray,
                      buttonPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusScope.of(context).unfocus();
                          await _loginCubit.login(
                              LoginRequestModel(
                                  username: _controllerUsername.text.trim(),
                                  password: _controllerPassword.text.trim()),
                          );
                        }
                      },
                      height: 5.4.h,
                      widget:
                      Text('Login',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlueColor , fontSize: 12.sp ),)
                  );
                });
          }),
    );
  }

  Widget _fieldsWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 4.h,
          ),
          CustomTextField(
            controller: _controllerUsername,
            focusNode: _focusNodeUsername,
            nextFocusNode: _focusNodePassword,
            hintText: 'Username',
            maxLine: 1,
            validator: (name) {
              return filedRequired(name);
            },
          ),
          SizedBox(
            height: 4.h,
          ),
          CustomTextField(
            controller: _controllerPassword,
            focusNode: _focusNodePassword,
            hintText: 'Password',
            isPassword: true,
            maxLine: 1,
            validator: (name) {
              return filedRequired(name);
            },
          )
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: EdgeInsets.only(top:8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize:17.sp, fontWeight: FontWeight.bold ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Text(
              'Enter Your Credentials',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w600 ),
            ),
          ],
        ),
      ),
    );
  }

}
