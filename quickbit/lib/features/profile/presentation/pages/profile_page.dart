import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/injection_container.dart';
import 'package:quickbit/features/shared_auth/bloc/auth_bloc.dart';
import 'package:quickbit/features/shared_auth/bloc/auth_event.dart';
import 'package:quickbit/features/shared_auth/bloc/auth_state.dart';
import 'package:quickbit/features/login/presentation/pages/login_page.dart';
import 'package:quickbit/features/profile/presentation/widgets/profile_menu_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(AuthCheckStatusEvent()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          String name = 'Guest User';
          String email = 'guest@campus.edu';

          if (state is AuthAuthenticated) {
            name = state.user.name;
            email = state.user.email;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Profile Info Card
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            name.isNotEmpty ? name[0] : 'U',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xl),

                  // Profile List Options
                  Text(
                    'Account Settings',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  ProfileMenuButton(icon: Icons.person_outline, title: 'Edit Profile', onTap: () {}),
                  ProfileMenuButton(icon: Icons.notifications_none, title: 'Notifications', onTap: () {}),
                  ProfileMenuButton(icon: Icons.payment_outlined, title: 'Payment Methods', onTap: () {}),
                  ProfileMenuButton(icon: Icons.history, title: 'Past Orders', onTap: () {}),
                  ProfileMenuButton(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
                  const SizedBox(height: AppDimensions.xl),

                  // Logout Button
                  SizedBox(
                    height: AppDimensions.buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorContainer,
                        foregroundColor: AppColors.onErrorContainer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutEvent());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: AppDimensions.sm),
                          Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
