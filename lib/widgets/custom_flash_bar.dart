import 'package:authentication_bloc/cubit/cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

customFlashBar(String text) {
  return BotToast.showCustomNotification(
    align: Alignment.center,
    toastBuilder: (void Function() cancelFunc) {
      return BlocBuilder<DarkModeCubit, bool>(
        builder: (context, state) {
          return Card(
            color: Colors.black26.withOpacity(0.6),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Flexible(
                    child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          );
        },
      );
    },
  );
}
