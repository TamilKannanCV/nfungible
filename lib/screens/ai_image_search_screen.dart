import 'package:flutter/material.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/gen/assets.gen.dart';
import 'package:nfungible/screens/ai_images_result_screen.dart';
import 'package:sizer/sizer.dart';

class AIImagesSearchScreen extends StatelessWidget {
  AIImagesSearchScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.pandaWithMobile.image(
                  width: 40.0.w,
                  height: 40.0.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 2.0.h),
                Text(
                  "Create your own NFT picture",
                  style: TextStyle(fontSize: 17.0.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 85.0.w,
                  child: Text(
                    "Just type your picture concept, we create it for you",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0.sp),
                  ),
                ),
                SizedBox(height: 4.0.h),
                SizedBox(
                  width: 90.0.w,
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "An Impressionist oil painting of sunflowers in a purple vase...",
                    ),
                    maxLines: 3,
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "*required";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 2.0.h),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == false) {
                        return;
                      }
                      context
                          .push<String>(
                        MaterialPageRoute(
                          builder: (context) => AIImagesResultScreen(
                            query: _controller.text,
                          ),
                        ),
                      )
                          .then(
                        (value) {
                          if (value != null) {
                            context.pop(value);
                          }
                        },
                      );
                    },
                    child: const Text("Generate"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
