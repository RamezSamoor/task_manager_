import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/core/di/injection_container.dart';
import 'package:task_manager_app/features/home/cubit/todo_cubit.dart';
import 'package:task_manager_app/features/home/views/dialogs/update_or_add_todo_dialog.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loader_widget.dart';
import '../../cubit/todo_state.dart';
import '../../models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TodoCubit _todoCubit;

  @override
  void initState() {
    _todoCubit = getIt<TodoCubit>();
    _todoCubit.initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: Text(
            'Task Manager',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.darkBlueColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.darkBlueColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  CustomButton(
                      buttonPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return UpdateOrAddTodoDialog(
                                isEdit: false,
                                item: Todos() ,
                              );
                            });
                      },
                      withBorder: false,
                      buttonColor: AppColors.blue,
                      width: null,
                      widget: Row(
                        children: [
                          Icon(Icons.add_circle_outline_sharp,
                              size: 5.w, color: AppColors.textColorPrimary),
                          SizedBox(width: 2.w),
                          Text(
                            'Add New Task',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppColors.textColorPrimary),
                          )
                        ],
                      )),
                ],
              ),
            ),
            BlocBuilder<TodoCubit, TodoState>(
              bloc: _todoCubit,
              builder: (context, state) {
                return Expanded(
                  child: PagedListView(
                    pagingController: _todoCubit.todoController!,
                    padding: EdgeInsets.only(bottom: 2.h),
                    builderDelegate: PagedChildBuilderDelegate<Todos>(
                        animateTransitions: false,
                        firstPageProgressIndicatorBuilder: (_) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: loaderWidget(),
                            ),
                        newPageProgressIndicatorBuilder: (_) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: loaderWidget(),
                            ),
                        firstPageErrorIndicatorBuilder: (_) =>
                            const Center(child: Text('Error Message')),
                        itemBuilder: (context, item, index) {
                          if ((item.isDeleted ?? false) == false) {
                            return Card(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: AppColors.lightOffWhite),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 2.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(item.todo ?? '', style: Theme.of(context).textTheme.bodyLarge?.copyWith(),)),
                                    _moreOptions(item,context)
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        noItemsFoundIndicatorBuilder: (_) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  'No Items Available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppColors.lightBlue),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                );
              },
            ),
          ]),
        ));
  }

  Widget _moreOptions(Todos item,BuildContext ctx) {
    List<String> data = ['Edit', 'Delete'];
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          height: 30,
          onTap: () {
              Future.delayed(const Duration(seconds: 1),() =>showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return UpdateOrAddTodoDialog(
                      isEdit: true,
                      item: item,
                    );
                  }) ,);
          },
          child: Text(
            data[0],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700, color: AppColors.textColorPrimary),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {
            _todoCubit.deleteTodo(item.id ?? 1,() {
              item.isDeleted = true;
              _todoCubit.refreshPage();
            },);

          },
          height: 30,
          child: Text(
            data[1],
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700, color: Colors.red),
          ),
        ),
      ],
      child: Icon(
        Icons.pending_outlined,
        color: AppColors.textColorSecondary,
        size: 6.w,
      ),
    );
  }
}
