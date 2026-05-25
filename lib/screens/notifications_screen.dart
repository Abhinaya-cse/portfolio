import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<void> _markAllRead() async {
    final batch = FirebaseFirestore.instance.batch();
    final unread = await FirebaseFirestore.instance
        .collection('contact')
        .where('read', isEqualTo: false)
        .get();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: isDark ? AppColors.textLight : AppColors.textDark,
              size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Messages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            )),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('contact')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading messages',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 64,
                      color: AppColors.textMuted.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('No messages yet',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Text('Contact form submissions will appear here',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc  = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              return FadeInUp(
                duration: const Duration(milliseconds: 300),
                delay: Duration(milliseconds: i * 40),
                child: _MessageCard(
                  docId  : doc.id,
                  data   : data,
                  isDark : isDark,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── MESSAGE CARD ──────────────────────────────────────────────
class _MessageCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;
  final bool isDark;
  const _MessageCard({
    required this.docId,
    required this.data,
    required this.isDark,
  });

  bool get _isRead => data['read'] == true;

  String _timeAgo(Timestamp? ts) {
    if (ts == null) return '';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final d = ts.toDate();
    return '${d.day}/${d.month}/${d.year}';
  }

  Future<void> _markRead() async {
    await FirebaseFirestore.instance
        .collection('contact')
        .doc(docId)
        .update({'read': true});
  }

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('contact')
          .doc(docId)
          .delete();
    }
  }

  void _reply() async {
    final email = data['email'] ?? '';
    final name  = data['name'] ?? '';
    final uri   = Uri.parse('mailto:$email?subject=Re: Your message, $name');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRead ? null : _markRead,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _isRead
              ? (isDark ? AppColors.darkCard : AppColors.lightCard)
              : (isDark
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isRead
                ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                : AppColors.primary.withValues(alpha: 0.35),
            width: _isRead ? 0.5 : 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: avatar + name + time + dot ────
              Row(
                children: [
                  // Avatar initials
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (data['name'] as String? ?? '?')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                        ),
                        Text(
                          data['email'] ?? '',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _timeAgo(data['timestamp'] as Timestamp?),
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      if (!_isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Message ──────────────────────────────────
              Text(
                data['message'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textLight.withValues(alpha: 0.85)
                      : AppColors.textDark.withValues(alpha: 0.8),
                ),
              ),

              const SizedBox(height: 14),

              // ── Action buttons ───────────────────────────
              Row(
                children: [
                  // Reply
                  _ActionBtn(
                    icon: Icons.reply_rounded,
                    label: 'Reply',
                    color: AppColors.primary,
                    onTap: _reply,
                  ),
                  const SizedBox(width: 10),
                  // Mark read (if unread)
                  if (!_isRead)
                    _ActionBtn(
                      icon: Icons.done_all_rounded,
                      label: 'Mark read',
                      color: AppColors.accent,
                      onTap: _markRead,
                    ),
                  const Spacer(),
                  // Delete
                  GestureDetector(
                    onTap: () => _delete(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.red, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── ACTION BUTTON ─────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color)),
          ],
        ),
      ),
    );
  }
}