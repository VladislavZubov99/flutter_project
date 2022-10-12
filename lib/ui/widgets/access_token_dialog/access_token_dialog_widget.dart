import 'package:flutter/material.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/app_settings/app_text_styles.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:project/domain/data_providers/session_data_provider.dart';

class AccessTokenDialogWidget extends StatefulWidget {
  const AccessTokenDialogWidget({Key? key}) : super(key: key);

  @override
  State<AccessTokenDialogWidget> createState() =>
      _AccessTokenDialogWidgetState();
}

class _AccessTokenDialogWidgetState extends State<AccessTokenDialogWidget> {
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();
  String accessToken = '';

  @override
  void initState() {
    _sessionDataProvider.getAccessToken().then((value) {
      if (value != null) {
        accessToken = value.trim();
      }
    });
    super.initState();
  }

  closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  onChanged(String text) {
    setState(() {
      accessToken = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      final appTextStyles = AppTextStyles(scaling: sx);
      return TextButton(
        child: Text(
          'Edit Accees Token',
          style: appTextStyles.commonTitleText,
        ),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Edit Access Token'),
              titlePadding: EdgeInsets.all(sx(AppSpace.padding)),
              contentPadding: EdgeInsets.all(sx(AppSpace.padding)),
              children: [
                SizedBox(
                  width: sx(350),
                  child: _DecoratedAccessTokenField(
                    accessToken: accessToken,
                    onChanged: onChanged,
                    clearAccessToken: () {
                      setState(() {
                        accessToken = '';
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: sx(AppSpace.padding),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: sx(40),
                        child: ElevatedButton(
                          onPressed: () => closeDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: Text(
                            'Cancel',
                            style: appTextStyles.commonButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: sx(AppSpace.padding),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: sx(40),
                        child: ElevatedButton(
                          onPressed: () {
                            _sessionDataProvider
                                .setAccessToken(accessToken)
                                .then((value) {
                              closeDialog(context);
                            });
                          },
                          child: Text(
                            'Confirm',
                            style: appTextStyles.commonButtonText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    });
    ;
  }
}

class _DecoratedAccessTokenField extends StatefulWidget {
  final String accessToken;
  final void Function(String text) onChanged;
  final void Function() clearAccessToken;

  const _DecoratedAccessTokenField({
    Key? key,
    required this.accessToken,
    required this.onChanged,
    required this.clearAccessToken,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DecoratedAccessTokenFieldState();
}

class _DecoratedAccessTokenFieldState
    extends State<_DecoratedAccessTokenField> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xff1e988a).withOpacity(0.3),
                offset: const Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 50)
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: TextFormField(
          initialValue: widget.accessToken,
          onChanged: widget.onChanged,
          keyboardType: TextInputType.text,
          maxLines: 6,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            // suffixIcon: GestureDetector(
            //   onTap: widget.clearAccessToken,
            //   behavior: HitTestBehavior.translucent,
            //   child: const AbsorbPointer(
            //     child: Icon(
            //       Icons.cancel,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            // isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
    );
  }
}
