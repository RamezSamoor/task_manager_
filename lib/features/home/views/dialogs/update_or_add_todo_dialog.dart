import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/core/utils/cache_helper.dart';
import 'package:task_manager_app/features/home/cubit/todo_cubit.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/utitlities.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loader_widget.dart';
import '../../cubit/todo_state.dart';
import '../../models/todo_model.dart';

class UpdateOrAddTodoDialog extends StatefulWidget {
  UpdateOrAddTodoDialog({super.key, this.isEdit = false, required this.item});

  final bool isEdit;

  final Todos item;

  @override
  State<UpdateOrAddTodoDialog> createState() => _UpdateOrAddTodoDialogState();
}

class _UpdateOrAddTodoDialogState extends State<UpdateOrAddTodoDialog> {
  final _formKey = GlobalKey<FormState>();

  final TodoCubit _todoCubit = getIt<TodoCubit>();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    widget.isEdit ? _descriptionController.text = widget.item.todo ?? '' : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      titlePadding: EdgeInsets.symmetric(horizontal: 4.26.w)
          .copyWith(top: 2.2.h, bottom: 1.h),
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.5.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      elevation: 0,
      title: _buildTitle(context),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 83.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.textColorPrimary),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextField(
                        controller: _descriptionController,
                        onChangedCallback: (s) {},
                        autofocus: true,
                        validator: (value) {
                          return filedRequired(value);
                        },
                        paddingHorizontal: 0.w,
                        maxLine: 4,
                        style: const TextStyle(color: Colors.black),
                        maxLength: Constant.maxLengthForDescription,
                        fontSize: 12.sp,
                        hintText: 'Description...',
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.textColorSecondary
                                      .withOpacity(0.5),
                                  width: 0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.textColorPrimary
                                      .withOpacity(0.5),
                                  width: 0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.textColorPrimary
                                      .withOpacity(0.5),
                                  width: 0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          hintText: 'Description...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.textColorSecondary),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Divider(color: AppColors.grey.withOpacity(0.4)),
        _buildButtons()
      ],
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.4.w, vertical: 1.97.h),
      child: BlocConsumer<TodoCubit, TodoState>(
          bloc: _todoCubit,
          listener: (context, state) {
            state.whenOrNull(
              loaded: () => Navigator.pop(context),
              error: (value) {
                showErrorMessage(value);
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => loaderWidget(),
              orElse: () {
                return Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonColor: Colors.white,
                        height: 5.h,
                        widget: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.textColorSecondary),
                        ),
                        buttonPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 4.26.w,
                    ),
                    Expanded(
                      child: CustomButton(
                        height: 5.h,
                        withBorder: false,
                        buttonColor: AppColors.blue,
                        widget: Text(
                          widget.isEdit ? 'Edit' : 'Add',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        buttonPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            FocusScope.of(context).unfocus();
                            if (widget.isEdit) {
                              _todoCubit.updateTodo(
                                widget.item.id.toString(),
                                Todos(todo: _descriptionController.text),
                                () {
                                  widget.item.todo =
                                      _descriptionController.text;
                                  _todoCubit.refreshPage();
                                },
                              );
                            } else {
                              widget.item.userId =
                                  getIt<CacheHelper>().getUserCredentials()?.id;
                              widget.item.todo = _descriptionController.text;
                              _todoCubit.addTodo(widget.item);

                            }
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.isEdit ? 'Edit' : 'Add',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(
          width: 4.w,
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.close,
            color: AppColors.textColorSecondary,
            size: 6.w,
          ),
        ),
      ],
    );
  }
}
