import 'package:flutter/material.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/services/graphql_service.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CreateSetScreen extends StatefulWidget {
  static String get routeName => "/createSet";
  const CreateSetScreen({super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text("Create a Set"),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: MultiSliver(
              children: [
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Set Title",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "*required";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.maxFinite,
                  child: FilledButton(
                    onPressed: () {
                      GraphqlService()
                          .createSet(_controller.text)
                          .then((value) {
                        context.showSnackbar(
                            content: const Text("NFT Set created"));
                        context.pop();
                      }).catchError((err) {
                        context.showSnackbar(
                            content: const Text("Unable to create NFT Set"));
                        context.pop();
                      });
                    },
                    child: const Text("Create Set"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
