import 'package:flutter/material.dart';
import 'package:myapp/features/personal/screen/pet_personal_detail.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/pet.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  //Will be replaced by API data
  final List<Pet> pets = [
    Pet(
      petId: 1,
      petName: 'Bobby',
      dateOfBirth: DateTime(2020, 5, 20),
      petType: 'Chó',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, i) {
        final pet = pets[i];
        return CustomCard.service(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(radius: 24),
            title: Text(pet.petNameNullable ?? '—'),
            subtitle: Text(pet.petTypeNullable ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => NavigateHelper.showBottomModal(
              context,
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: PetDetailCard(pet: pet),
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: pets.length,
    );
  }
}
