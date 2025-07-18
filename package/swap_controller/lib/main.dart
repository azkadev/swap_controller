// ignore_for_file: empty_catches

import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:swap_controller/core/core.dart';

void main() {
  SwapControllerClientFlutter.swapControllerClientFlutter.ensureIntiialied();
  runApp(const SwapControllerApplication());
}

/// By Azkadev

class SwapControllerApplication extends StatelessWidget {
  /// By Azkadev

  const SwapControllerApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: SwapControllerHomePage(),
    );
  }
}

/// By Azkadev

class SwapControllerHomePage extends StatefulWidget {
  /// By Azkadev
  const SwapControllerHomePage({super.key});

  @override
  State<SwapControllerHomePage> createState() => _SwapControllerHomePageState();
}

class _SwapControllerHomePageState extends State<SwapControllerHomePage> {
  bool isLoading = false;
  List controllers = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refresh();
    });
  }

  Future<void> refresh() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future(() {
      final result = SwapControllerClientFlutter.swapControllerClientFlutter.invoke({
        "@type": "getControllersAzkadevGamePadNative",
      });

      if (result["@type"] == "controllersAzkadevGamePadNative" && result["controllers"] is List) {
        controllers = result["controllers"] as List;
      } else {
        controllers = [];
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void handleFunction({
    required FutureOr<dynamic> Function(BuildContext context) onFunction,
    FutureOr<dynamic> Function(BuildContext context, Object error, StackTrace stackTrace)? onErrorFunction,
  }) {
    Future(() async {
      try {
        await onFunction(context);
      } catch (e, stack) {
        // ignore: non_constant_identifier_names
        final on_error_function = onErrorFunction;
        if (on_error_function != null) {
          on_error_function(context, e, stack);
        }
      }
    });
  }

  FutureOr<AnyValue> task<AnyValue>({
    required BuildContext context,
    required FutureOr<AnyValue?> Function(BuildContext context) onTask,
    required FutureOr<AnyValue?> Function(BuildContext context, Object error, StackTrace stackTrace) onError,
    required FutureOr<AnyValue> Function(BuildContext context) onNull,
  }) async {
    final result = await taskOrNull(
      context: context,
      onTask: onTask,
      onError: onError,
    );
    if (result != null) {
      return result;
    }
    return await onNull(context);
  }

  SwapControllerClientFlutter get swapControllerClientFlutter {
    return SwapControllerClientFlutter.swapControllerClientFlutter;
  }

  FutureOr<AnyValue?> taskOrNull<AnyValue>({
    required BuildContext context,
    required FutureOr<AnyValue?> Function(BuildContext context) onTask,
    required FutureOr<AnyValue?> Function(BuildContext context, Object error, StackTrace stackTrace) onError,
  }) async {
    if (isLoading) {
      return null;
    }
    setState(() {
      isLoading = true;
    });
    final result = () async {
      try {
        return await onTask(context);
      } catch (e, stack) {
        return await onError(context, e, stack);
      }
    }();
    setState(() {
      isLoading = false;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final ThemeData themeData = Theme.of(context);

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              CircularProgressIndicator(),
              Text("Loading"),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Swap Controller - Azkadev",
          style: themeData.textTheme.titleLarge,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: mediaQueryData.size.width,
              minHeight: mediaQueryData.size.height,
            ),
            child: Column(
              children: [
                SimpleButtonWidget(
                  title: "Add Controller",
                  onPressed: () {
                    handleFunction(
                      onFunction: (context) async {
                        final result = swapControllerClientFlutter.invoke({
                          "@type": "getDevicesAzkadevGamePadNative",
                        });
                        final List devices = () {
                          if (result["devices"] is List) {
                            return result["devices"];
                          }

                          return [];
                        }();
                        AzkadevDialogFlutter.showDialogWidget(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: [
                                AzkadevDialogFlutter.titleSimpleWidget(
                                  context: context,
                                  title: "Devices ${devices.length}",
                                ),
                                for (final element in devices) ...[
                                  () {
                                    if (element is Map) {
                                      final String title = switch (element["name"]) {
                                        String value => value,
                                        // TODO: Handle this case.
                                        Object() => "",
                                        // TODO: Handle this case.
                                        null => "",
                                      };
                                      if (title.isEmpty) {
                                        return SizedBox.shrink();
                                      }
                                      return SimpleContainerWidget(
                                        margin: EdgeInsets.all(5),
                                        child: ListTile(
                                          title: Text(
                                            title.trim(),
                                            style: themeData.textTheme.titleSmall,
                                          ),
                                          onTap: () {
                                            final result = swapControllerClientFlutter.invoke({"@type": "setControllerByDeviceNameAzkadevGamePadNative", "controller_id": 0, "controller_type": "xbox_360", "name": title});
                                            if (result["@type"] != "ok") {}
                                            Navigator.pop(context);
                                            refresh();
                                          },
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  }()
                                ],
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                if (controllers.isEmpty) ...[
                  Padding(
                    padding: EdgeInsetsGeometry.all(5),
                    child: Text(
                      "Controller Not Found",
                      style: themeData.textTheme.titleMedium,
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: EdgeInsetsGeometry.all(5),
                    child: Text(
                      "Controllers ${controllers.length}",
                      style: themeData.textTheme.titleMedium,
                    ),
                  ),
                  for (final controller in controllers) ...[
                    () {
                      if (controller is Map) {
                        final num controllerId = switch (controller["controller_id"]) {
                          num value => value,
                          Object() => 0,
                          null => 0,
                        };
                        final String controllerType = switch (controller["controller_type"]) {
                          String value => value,
                          Object() => "",
                          null => "",
                        };
                        final Map device = switch (controller["device"]) {
                          Map value => value,
                          Object() => {},
                          null => {},
                        };
                        final String deviceTitle = switch (device["name"]) {
                          String value => value,
                          // TODO: Handle this case.
                          Object() => "",
                          // TODO: Handle this case.
                          null => "",
                        };
                        final String subtitle = """
Controller Type: ${controllerType}
Device: ${deviceTitle}
"""
                            .trim();
                        return SimpleContainerWidget(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(
                              "${controllerId + 1}",
                              style: themeData.textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              subtitle,
                              style: themeData.textTheme.bodySmall,
                            ),
                            onTap: () {
                              handleFunction(
                                onFunction: (context) async {
                                  final result = swapControllerClientFlutter.invoke({
                                    "@type": "getAvailableControllersAzkadevGamePadNative",
                                  });
                                  final List controllersTypes = () {
                                    if (result["controllers"] is List) {
                                      return result["controllers"];
                                    }

                                    return [];
                                  }();
                                  AzkadevDialogFlutter.showDialogWidget(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          AzkadevDialogFlutter.titleSimpleWidget(
                                            context: context,
                                            title: "Controller Types ${controllersTypes.length}",
                                          ),
                                          for (final controller_type in controllersTypes) ...[
                                            () {
                                              if (controller_type is String) {
                                                if (controller_type.isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return SimpleContainerWidget(
                                                  margin: EdgeInsets.all(5),
                                                  child: ListTile(
                                                    title: Text(
                                                      controller_type.trim(),
                                                      style: themeData.textTheme.titleSmall,
                                                    ),
                                                    onTap: () {
                                                      final result = swapControllerClientFlutter.invoke({
                                                        "@type": "setControllerByDeviceNameAzkadevGamePadNative",
                                                        "controller_id": 0,
                                                        "controller_type": controller_type,
                                                        "name": deviceTitle,
                                                      });
                                                      if (result["@type"] != "ok") {}
                                                      Navigator.pop(context);
                                                      refresh();
                                                    },
                                                  ),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            }()
                                          ],
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }

                      return SizedBox.shrink();
                    }()
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// by Azkadev
class AzkadevDialogFlutter {
  /// by Azkadev
  static Widget titleWidget({
    required Widget leading,
    required Widget title,
    required Widget trailing,
  }) {
    return Padding(
      padding: EdgeInsetsGeometry.all(1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading,
          title,
          trailing,
        ],
      ),
    );
  }

  /// by Azkadev
  static Widget titleSimpleWidget({
    required BuildContext context,
    required String title,
  }) {
    final themeData = Theme.of(context);
    return titleWidget(
      leading: IgnorePointer(
        child: Opacity(
          opacity: 0,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.close,
            ),
          ),
        ),
      ),
      title: Text(
        title.trim(),
        style: themeData.textTheme.titleMedium,
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.close,
        ),
      ),
    );
  }

  ///
  static void showDialogWidget({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    showGeneralDialog(
      context: context,
      // barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        final ThemeData themeData = Theme.of(context);
        return SimpleContainerWidget(
          color: themeData.scaffoldBackgroundColor,
          margin: EdgeInsets.all(20),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: builder(
              context,
            ),
          ),
        );
      },
    );
  }
}

/// By Azkadev

class SimpleContainerWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Color? color;

  /// By Azkadev
  final Widget child;

  /// By Azkadev

  const SimpleContainerWidget({
    super.key,
    this.color,
    this.margin,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? themeData.splashColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: themeData.dividerColor,
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// By Azkadev

class SimpleButtonWidget extends StatelessWidget {
  /// By Azkadev

  final String title;

  /// By Azkadev

  final void Function()? onPressed;

  /// By Azkadev

  const SimpleButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SimpleContainerWidget(
      margin: EdgeInsets.all(
        5,
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        onPressed: onPressed,
        minWidth: mediaQueryData.size.width,
        clipBehavior: Clip.antiAlias,
        child: Text(title),
      ),
    );
  }
}
