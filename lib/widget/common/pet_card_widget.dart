import 'package:flutter/material.dart';
import 'package:myapp/widget/index.dart';

class PetCard extends StatelessWidget {
  final String petName;
  final bool isSelected;
  final VoidCallback onTap;

  const PetCard({
    super.key,
    required this.petName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: const Color(0xFF4A90A4), width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? const Color(0xFF4A90A4).withOpacity(0.5)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/kakashi.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.pets,
                    size: 40,
                    color: Color(0xFF4A90A4),
                  );
                },
              ),
            ),
          ),
          AppSpacing.verticalSM,
          Text(
            petName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF4A90A4) : Colors.black87,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: AppSpacing.xs),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF4A90A4),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
