import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/transaction_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hideBalance = false;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountLoadRequested());
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          final balance = accountState is AccountLoaded
              ? accountState.account.balance
              : 0.0;
          final txns = accountState is AccountLoaded
              ? accountState.transactions
              : <TransactionEntity>[];
          final loading = accountState is AccountLoading;

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<AccountBloc>().add(AccountRefreshRequested()),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(balance, loading),
                  const SizedBox(height: 24),
                  _buildFeatureGrid(),
                  const SizedBox(height: 20),
                  _buildPromoSection(),
                  const SizedBox(height: 20),
                  _buildDiscountBanner(),
                  const SizedBox(height: 24),
                  _buildTransactions(txns),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(double balance, bool loading) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        final firstName = user?.firstName ?? 'Kamu';
        final fullName = user?.name ?? 'User';

        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).padding.top + 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: avatar + greeting + notif
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    child: Text(
                      fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat siang,',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          firstName,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            size: 20, color: Colors.white),
                      ),
                      Positioned(
                        top: 9,
                        right: 10,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Balance label
              const Text(
                'Balance',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),

              // Saldo
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _hideBalance
                        ? CurrencyFormatter.maskBalance()
                        : CurrencyFormatter.format(balance),
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _hideBalance = !_hideBalance),
                    child: Icon(
                      _hideBalance
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionButton(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan',
                    onTap: () => context.go('/payment'),
                  ),
                  _ActionButton(
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Top up',
                    onTap: () => context.go('/topup'),
                  ),
                  _ActionButton(
                    icon: Icons.send_rounded,
                    label: 'Send',
                    onTap: () => context.go('/transfer'),
                  ),
                  _ActionButton(
                    icon: Icons.south_rounded,
                    label: 'Receive',
                    onTap: () => context.go('/topup'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': Icons.bolt_outlined, 'label': 'PLN', 'tone': 'amber'},
      {'icon': Icons.water_drop_outlined, 'label': 'PDAM', 'tone': 'blue'},
      {'icon': Icons.wifi_rounded, 'label': 'Internet', 'tone': 'green'},
      {'icon': Icons.smartphone_outlined, 'label': 'Credits', 'tone': 'violet'},
      {
        'icon': Icons.account_balance_wallet_outlined,
        'label': 'Top up',
        'tone': 'blue'
      },
      {'icon': Icons.sports_esports_outlined, 'label': 'Game', 'tone': 'red'},
      {
        'icon': Icons.volunteer_activism_outlined,
        'label': 'Zakat',
        'tone': 'green'
      },
      {'icon': Icons.more_horiz_rounded, 'label': 'More', 'tone': 'slate'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.shadowSoft,
        ),
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: features
                  .sublist(0, 4)
                  .map((f) => _buildFeatureItem(f))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: features
                  .sublist(4, 8)
                  .map((f) => _buildFeatureItem(f))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> f) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FeatureIcon(
            icon: f['icon'] as IconData,
            tone: f['tone'] as String,
            size: 50,
            iconSize: 24,
          ),
          const SizedBox(height: 6),
          Text(
            f['label'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.slate600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Check New Promo',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'Easy with promo code',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  color: AppColors.slate400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.go('/promo'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBorder),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'VIEW ALL',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF5448D6), Color(0xFF8A82E7)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Ilustrasi placeholder
            SizedBox(
              width: 150,
              height: 80, 
              child: Image.asset(
                'assets/images/banner.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const Text(
                    '30%',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data package payment',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'WALLTPAY30',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactions(List<TransactionEntity> txns) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest transaction',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/history'),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.shadowSoft,
            ),
            child: txns.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Belum ada transaksi',
                        style: TextStyle(
                          color: AppColors.slate400,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: txns
                        .take(4)
                        .toList()
                        .asMap()
                        .entries
                        .map((e) =>
                            TransactionRow(txn: e.value, divider: e.key > 0))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

// Action button di header
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
