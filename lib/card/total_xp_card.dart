import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/api/skill_icons.dart';
import 'package:osrs_bot_dashboard/api/xp.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

/// A card widget that displays an account's total XP gained in a grid format.
class TotalXpCard extends StatefulWidget {
  final String accountId;

  const TotalXpCard({super.key, required this.accountId});

  @override
  State<TotalXpCard> createState() => _TotalXpCardState();
}

class _TotalXpCardState extends State<TotalXpCard> {
  Xp? _xp;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _fetchXp();
  }

  Future<void> _fetchXp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final settingsModel = Provider.of<SettingsModel>(context, listen: false);
      final api = BotAPI(settingsModel.apiIp);
      final xp = await api.getAccountXp(widget.accountId);

      if (mounted) {
        setState(() {
          _xp = xp;
          _isLoading = false;
          if (xp == null) {
            _errorMessage = 'Failed to load XP data';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading XP data';
        });
      }
    }
  }

  String _formatXp(int xp) {
    if (xp >= 1000000) {
      return '${(xp / 1000000).toStringAsFixed(1)}M';
    } else if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return xp.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total XP Gained',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (_xp != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Total: ${_formatXp(_xp!.totalXp)} XP',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 18),
                        onPressed: _fetchXp,
                        tooltip: 'Refresh XP',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              _buildContent(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _fetchXp,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_xp == null || _xp!.totalXp == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.trending_up,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No XP data available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildXpGrid();
  }

  Widget _buildXpGrid() {
    // Only show skills with non-zero XP
    final nonZeroSkills = _xp!.nonZeroSkillEntries;

    if (nonZeroSkills.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.trending_up,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No XP gained yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate columns based on available width
        int crossAxisCount;
        if (constraints.maxWidth > 800) {
          crossAxisCount = 8;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 7;
        } else if (constraints.maxWidth > 400) {
          crossAxisCount = 6;
        } else {
          crossAxisCount = 5;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.85,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: nonZeroSkills.length,
          itemBuilder: (context, index) {
            final skill = nonZeroSkills[index];
            return _buildXpTile(skill.key, skill.value);
          },
        );
      },
    );
  }

  Widget _buildXpTile(String skillName, int xp) {
    final icon = SkillIcons.getIcon(skillName);
    final color = SkillIcons.getColor(skillName);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withAlpha(100),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(height: 1),
          Text(
            _formatXp(xp),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 11,
                ),
          ),
          Text(
            skillName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 8,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
