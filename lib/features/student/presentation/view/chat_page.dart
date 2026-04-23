import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';

class _MockChat {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  const _MockChat({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
  });
}

const _chats = <_MockChat>[
  _MockChat(
    name: 'James Mitchell',
    lastMessage: 'See you at the test centre tomorrow.',
    time: '09:41',
    unread: 2,
  ),
  _MockChat(
    name: 'Sarah Hughes',
    lastMessage: 'Thanks for the swap!',
    time: 'Yesterday',
  ),
  _MockChat(
    name: 'David Clarke',
    lastMessage: 'Let me know how it went.',
    time: 'Mon',
  ),
];

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.verticalSpace,
            Text(
              'My chats',
              style: AppTextStyles.style34_700
                  .copyWith(color: AppColors.primary),
            ),
            Text(
              'Message your instructor here',
              style: AppTextStyles.style14
                  .copyWith(fontSize: 15.sp, color: Colors.grey),
            ),
            20.verticalSpace,
            Expanded(
              child: _chats.isEmpty
                  ? const Center(child: Text('No chats available'))
                  : ListView.separated(
                      padding: EdgeInsets.only(bottom: 100.h),
                      itemCount: _chats.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade300,
                      ),
                      itemBuilder: (context, i) =>
                          _ChatRow(chat: _chats[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  final _MockChat chat;
  const _ChatRow({required this.chat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppSnackbar.show(
        context,
        title: 'Chat with ${chat.name}',
        message: 'Opening chat — coming soon',
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.primary,
              child: Text(
                chat.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: AppTextStyles.style17_600
                        .copyWith(color: AppColors.black),
                  ),
                  4.verticalSpace,
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.style14.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: AppTextStyles.style14.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                6.verticalSpace,
                if (chat.unread > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '${chat.unread}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
