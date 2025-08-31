import "package:flutter/material.dart";
import "package:myapp/route/app_router.dart";

class Guilde extends StatelessWidget {
  const Guilde({super.key});

  // 1. Sau khi login thành công

  @override
  Widget build(BuildContext context) {
    // 1. Sau khi login thành công
    AppRouter.navigateAfterLogin(context);
    // hoặc với redirect path
    AppRouter.navigateAfterLogin(context, redirectPath: '/profile');

    // 2. Push page mới (có thể back)
    AppRouter.push(context, '/profile');

    // 3. Replace page (không thể back)
    AppRouter.replace(context, '/home');

    // 4. Navigate với params
    AppRouter.navigateWithParams(context, '/user', {
      'id': '123',
      'tab': 'profile',
    });

    // // 5. Show modal page
    // AppRouter.showModal(context, ProfileEditPage());

    // 6. Navigate với delay (sau dialog)
    // showDialog(
    //   context: context,
    //   builder: (context) => SuccessDialog(...),
    // ).then((_) {
    //   AppRouter.navigateWithDelay(context, '/home');
    // });

    // 7. Logout
    AppRouter.logout(context);

    // 8. Back về page trước
    AppRouter.pop(context);

    // 9. Navigate và clear stack
    AppRouter.navigateAndClearStack(context, '/onboarding');
    return Container();
  }
}
