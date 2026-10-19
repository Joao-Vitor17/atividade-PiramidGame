import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../domain/entities/app_user.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  final AuthViewModel viewModel;

  const AuthScreen({required this.viewModel, super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isRegistering) {
      await widget.viewModel.register(_emailController.text, _passwordController.text);
    } else {
      await widget.viewModel.login(_emailController.text, _passwordController.text);
    }
    if (!mounted) return;
    final state = _isRegistering
        ? widget.viewModel.registerCommand.state.value
        : widget.viewModel.loginCommand.state.value;
    if (state is SuccessCommandState<AppUser>) context.go('/home');
  }

  Future<void> _googleLogin() async {
    await widget.viewModel.loginWithGoogle();
    if (!mounted) return;
    if (widget.viewModel.googleLoginCommand.state.value
        is SuccessCommandState<AppUser>) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SignalBuilder(
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school, size: 64),
                  const SizedBox(height: 16),
                  Text('PirâmidGame IFPR-Pgua',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(_isRegistering ? 'Criar conta' : 'Entrar',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(labelText: 'E-mail'),
                          validator: (value) => value == null || !value.contains('@')
                              ? 'Informe um e-mail válido'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          autofillHints: [_isRegistering ? AutofillHints.newPassword : AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _hidePassword = !_hidePassword),
                              icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) => value == null || value.length < 6
                              ? 'Use pelo menos 6 caracteres'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  if (widget.viewModel.errorMessage case final message?) ...[
                    const SizedBox(height: 12),
                    Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: widget.viewModel.isLoading ? null : _submit,
                    child: widget.viewModel.isLoading
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_isRegistering ? 'Criar conta' : 'Entrar'),
                  ),
                  TextButton(
                    onPressed: widget.viewModel.isLoading
                        ? null
                        : () => setState(() => _isRegistering = !_isRegistering),
                    child: Text(_isRegistering ? 'Já tenho uma conta' : 'Criar conta'),
                  ),
                  const Divider(height: 32),
                  OutlinedButton.icon(
                    onPressed: widget.viewModel.isLoading ? null : _googleLogin,
                    icon: const Icon(Icons.account_circle_outlined),
                    label: const Text('Entrar com Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}