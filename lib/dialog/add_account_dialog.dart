import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/account.dart';
import 'package:osrs_bot_dashboard/api/bot_api.dart';

class AddAccountDialog extends StatefulWidget {
  final String apiIp;
  final VoidCallback onAccountAdded;

  const AddAccountDialog({
    Key? key,
    required this.apiIp,
    required this.onAccountAdded,
  }) : super(key: key);

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;
  AccountStatus _selectedStatus = AccountStatus.ACTIVE;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Account'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                hintText: 'Enter username',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Username is required';
                }
                if (value.trim().length < 3) {
                  return 'Username must be at least 3 characters';
                }
                return null;
              },
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                // Email validation regex pattern
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AccountStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Account Status',
                border: OutlineInputBorder(),
              ),
              items: AccountStatus.values.map((AccountStatus status) {
                return DropdownMenuItem<AccountStatus>(
                  value: status,
                  child: Text(_getStatusLabel(status)),
                );
              }).toList(),
              onChanged: _isSubmitting
                  ? null
                  : (AccountStatus? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Add Account'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final api = BotAPI(widget.apiIp);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();

    final success = await api.createAccount(username, email, _selectedStatus);

    if (!mounted) return;

    if (success) {
      // Notify parent to refresh the accounts list
      widget.onAccountAdded();
      
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account "$username" added successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _isSubmitting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add account. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  String _getStatusLabel(AccountStatus status) {
    switch (status) {
      case AccountStatus.ACTIVE:
        return 'Active';
      case AccountStatus.INACTIVE:
        return 'Inactive';
      case AccountStatus.BANNED:
        return 'Banned';
    }
  }
}
