import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/cubit/graphql_cubit.dart';
import 'package:nfungible/services/graphql_service.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CreateSetScreen extends StatefulWidget {
  static String get routeName => "/createSet";
  const CreateSetScreen({super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GraphqlCubit, GraphqlState>(
      listener: (context, state) {
        if (state is GraphqlLoading) {
          context.showPreloader(canPop: false);
        }
        if (state is GraphqlLoaded) {
          context.pop();
          context.pop();
          context.showSnackbar(content: const Text("Congrats💐, Your NFT set created"));
        }
        if (state is GraphqlError) {
          context.pop();
          context.showSnackbar(content: const Text("Unable to create NFT set"));
        }
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: const Text("Create a Set"),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(10.0),
                sliver: MultiSliver(
                  children: [
                    const Text("An NFTSet is a bag of NFTModels"),
                    SizedBox(height: 2.0.h),
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
                          if (_formKey.currentState?.validate() == false) {
                            context.showSnackbar(content: const Text("NFTSet title required"));
                            return;
                          }
                          context.read<GraphqlCubit>().createSet(_controller.text);
                        },
                        child: const Text("Create Set"),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
