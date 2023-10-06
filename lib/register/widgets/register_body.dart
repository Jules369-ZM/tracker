import 'package:flutter/material.dart';
import 'package:my_expense_tracker/register/cubit/cubit.dart';
import 'package:my_expense_tracker/utils/size_config.dart';
import 'package:my_expense_tracker/utils/utils.dart';
import 'package:my_expense_tracker/widgets/widgets.dart';

/// {@template register_body}
/// Body of the RegisterPage.
///
/// Add what it does
/// {@endtemplate}
class RegisterBody extends StatefulWidget {
  /// {@macro register_body}
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) async {
        if (state.status == CurrentStatus.error) {
          await EasyLoadingService.error(text: state.message);
        }
        if (state.status == CurrentStatus.success && state.message.isNotEmpty) {
          await EasyLoadingService.success(text: state.message);
          // await Future.delayed(const Duration(milliseconds: 3300), () {
          //   Navigator.pop(context);
          // });
        }
      },
      builder: (context, state) {
        if (state.status == CurrentStatus.other) {
          return const LoadingScreen();
        }
        if (state.status == CurrentStatus.receivingError) {
          return MessageScreen(message: state.message);
        }
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(32),
              vertical: getProportionateScreenWidth(32),
            ),
            children: [
              buildFeildHeader('Email'),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                textInputAction: TextInputAction.next,
                validator: (value) => validateTxtFiled(value: value),
                decoration: kTextFieldDecoration,
              ),
              const SizedBox(height: 16),
              buildFeildHeader('Password'),
              PasswordField(password),
              const SizedBox(height: 32),
              if (state.status == CurrentStatus.loading)
                const LoadingButton()
              else
                PrimaryButton(
                  title: 'Register',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<RegisterCubit>()
                          .createUserWithEmailAndPassword(
                            _email.text,
                            password.text,
                          );
                    }
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
