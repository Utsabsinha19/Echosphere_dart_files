import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Text(post.author[0].toUpperCase()),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post.author,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${post.timestamp.hour}:${post.timestamp.minute}',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(post.content),
              if (post.emotion != null) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(post.emotion!),
                  backgroundColor: Colors.blue[100],
                ),
              ],
              if (post.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: post.tags
                      .map((tag) => Chip(
                            label: Text('#$tag'),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
