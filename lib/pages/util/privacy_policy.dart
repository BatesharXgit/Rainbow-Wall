// import 'package:flutter/material.dart';
// import 'package:luca/components/square_tile.dart';
// import 'package:luca/authentication/services/auth_service.dart';

// class PrivacyPolicyPage extends StatefulWidget {
//   final Function()? onTap;
//   const PrivacyPolicyPage({super.key, required this.onTap});

//   @override
//   State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
// }

// class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF131321),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.01),

//                 // logo
//                 SizedBox(
//                   height: 150,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     // child: Image.asset('assets/images/logo.png'),
//                   ),
//                 ),

//                 const SizedBox(height: 50),

//                 // welcome back, you've been missed!
//                 Text(
//                   'Lets\'s create an account for you!',
//                   style: TextStyle(
//                     color: Colors.grey[500],
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.035),

//                 // username textfield

//                 // forgot password?

//                 SizedBox(height: MediaQuery.of(context).size.height * 0.035),

//                 // or continue with
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Divider(
//                           thickness: 0.5,
//                           color: Colors.grey[200],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Text(
//                           'Or continue with',
//                           style: TextStyle(color: Colors.grey[500]),
//                         ),
//                       ),
//                       Expanded(
//                         child: Divider(
//                           thickness: 0.5,
//                           color: Colors.grey[200],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.035),

//                 // google + apple sign in buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SquareTile(
//                         onTap: () => AuthService().signInWithGoogle(),
//                         imagePath: 'lib/images/google.png', text: '',),

//                     const SizedBox(width: 25),

//                     // apple button
//                   ],
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.030),

//                 // not a member? register now
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have an account?',
//                       style: TextStyle(color: Colors.grey[500]),
//                     ),
//                     const SizedBox(width: 4),
//                     GestureDetector(
//                       onTap: widget.onTap,
//                       child: const Text(
//                         'Login now',
//                         style: TextStyle(
//                           color: Color(0xFFFE5163),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
