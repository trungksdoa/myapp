import "package:flutter/material.dart";
import "package:myapp/route/navigate_helper.dart";

class Guilde extends StatelessWidget {
  const Guilde({super.key});

  // 1. Sau khi login thành công

  @override
  Widget build(BuildContext context) {
    // 1. Sau khi login thành công
    NavigateHelper.navigateAfterLogin(context);
    // hoặc với redirect path
    NavigateHelper.navigateAfterLogin(context, redirectPath: '/profile');

    // 2. Push page mới (có thể back)
    NavigateHelper.push(context, '/profile');

    // 3. Replace page (không thể back)
    NavigateHelper.replace(context, '/home');

    // 4. Navigate với params
    NavigateHelper.navigateWithParams(context, '/user', {
      'id': '123',
      'tab': 'profile',
    });

    // // 5. Show modal page
    // NavigateHelper.showModal(context, ProfileEditPage());

    // 6. Navigate với delay (sau dialog)
    // showDialog(
    //   context: context,
    //   builder: (context) => SuccessDialog(...),
    // ).then((_) {
    //   NavigateHelper.navigateWithDelay(context, '/home');
    // });

    // 7. Logout
    NavigateHelper().logoutAndNavigateToLogin(context);

    // 8. Back về page trước
    NavigateHelper.pop(context);

    // 9. Navigate và clear stack
    NavigateHelper.navigateAndClearStack(context, '/onboarding');
    return Container();
  }
}
