import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      backgroundColor: AppColors.void_bg,
      appBar: AppBar(
        backgroundColor: const Color(0xD904040A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: GoogleFonts.syne(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark all read',
              style: GoogleFonts.outfit(
                color: AppColors.violet,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              child: CircularProgressIndicator(color: AppColors.violet),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading messages',
                  style: GoogleFonts.outfit(color: AppColors.muted)),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 56,
                      color: AppColors.muted.withValues(alpha: 0.4)),
                  const SizedBox(height: 14),
                  Text('No messages yet',
                      style: GoogleFonts.syne(
                          color: AppColors.muted,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('Contact form submissions will appear here',
                      style: GoogleFonts.outfit(
                          color: AppColors.muted, fontSize: 12)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              return FadeInUp(
                duration: const Duration(milliseconds: 300),
                delay: Duration(milliseconds: i * 40),
                child: _MessageCard(
                    docId: doc.id, data: data),
              );
            },
          );
        },
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;
  const _MessageCard({required this.docId, required this.data});

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
        backgroundColor: AppColors.deep_bg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Delete message?',
            style: GoogleFonts.syne(color: AppColors.white)),
        content: Text('This cannot be undone.',
            style: GoogleFonts.outfit(color: AppColors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.outfit(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete',
                style: GoogleFonts.outfit(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w600)),
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
    final name = data['name'] ?? '';
    final uri =
        Uri.parse('mailto:$email?subject=Re: Your message, $name');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRead ? null : _markRead,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isRead
              ? AppColors.glass
              : AppColors.violet.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isRead
                ? AppColors.glassBorder
                : AppColors.violet.withValues(alpha: 0.3),
            width: _isRead ? 1 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.violet.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (data['name'] as String? ?? '?')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: GoogleFonts.syne(
                        color: AppColors.violet,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
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
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        data['email'] ?? '',
                        style: GoogleFonts.outfit(
                            color: AppColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _timeAgo(data['timestamp'] as Timestamp?),
                      style: GoogleFonts.outfit(
                          color: AppColors.muted, fontSize: 10),
                    ),
                    if (!_isRead) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.violet,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data['message'] ?? '',
              style: GoogleFonts.outfit(
                fontSize: 13,
                height: 1.55,
                color: AppColors.white.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _ActionBtn(
                  label: 'Reply',
                  color: AppColors.violet,
                  onTap: _reply,
                ),
                const SizedBox(width: 8),
                if (!_isRead)
                  _ActionBtn(
                    label: 'Mark read',
                    color: AppColors.cyan,
                    onTap: _markRead,
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _delete(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.coral.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.coral, size: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color),
        ),
      ),
    );
  }
}
