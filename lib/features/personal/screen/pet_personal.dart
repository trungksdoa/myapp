import 'package:flutter/material.dart';
import 'package:myapp/features/personal/screen/pet_personal_detail.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/pet.dart' as pmodel;
import 'package:myapp/shared/widgets/common/custom_card.dart';
// TODO: Comment out when API is ready
import 'package:myapp/data/mock/pets_mock.dart';
import 'package:myapp/data/service_locator.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final _petService = ServiceLocator().petService;
  List<pmodel.Pet> pets = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // TODO: Replace with service call when API is ready
      final loadedPets = await _petService.getAllPets();

      setState(() {
        pets = loadedPets;
        isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data
      setState(() {
        pets = mockPets;
        isLoading = false;
        error = 'Không thể tải danh sách thú cưng: $e';
      });
    }
  }

  Future<void> _refreshPets() async {
    await _loadPets();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadPets,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (pets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có thú cưng nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thêm thú cưng đầu tiên của bạn',
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => NavigateHelper.goToAddPet(context),
              icon: const Icon(Icons.add),
              label: const Text('Thêm thú cưng'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thú cưng của tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => NavigateHelper.goToAddPet(context),
            tooltip: 'Thêm thú cưng',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigateHelper.pop(context),
          tooltip: 'Quay lại',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPets,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            final pet = pets[i];
            return CustomCard.service(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              onTap: () async {
                final result = await NavigateHelper.showBottomModal(
                  context,
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: PetDetailCard(pet: pet),
                    ),
                  ),
                );
                // Refresh list if pet was updated
                if (result == 'updated') {
                  await _loadPets();
                }
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: pet.petImage != null
                      ? AssetImage(pet.petImage!)
                      : null,
                  child: pet.petImage == null
                      ? Icon(Icons.pets, color: Colors.grey[600])
                      : null,
                ),
                title: Text(
                  pet.petNameNullable ?? '—',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pet.petTypeNullable ?? 'N/A'} • ${pet.sizeNullable ?? 'Medium'}',
                    ),
                    if (pet.dateOfBirth != null)
                      Text(
                        '${_calculateAge(pet.dateOfBirth!)} tuổi',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: pets.length,
        ),
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return (age - 1).toString();
    }
    return age.toString();
  }
}
