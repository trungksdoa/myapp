// Pet Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_pet_service.dart';
import 'package:myapp/shared/model/pet.dart';
import 'package:myapp/data/mock/pets_mock.dart';

class PetService implements IPetService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<List<Pet>> getAllPets() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/pets');
    // return response.data.map((json) => Pet.fromJson(json)).toList();

    return mockPets;
  }

  @override
  Future<Pet?> getPetById(int petId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/pets/$petId');
    // return Pet.fromJson(response.data);

    try {
      return mockPets.firstWhere((pet) => pet.petId == petId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Pet> addPet(Pet pet) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.post('/api/pets', data: pet.toJson());
    // return Pet.fromJson(response.data);

    // Generate new ID for mock
    final newId = mockPets.length + 1;
    final newPet = Pet(
      petId: newId,
      accountId: pet.accountId,
      petName: pet.petName,
      dateOfBirth: pet.dateOfBirth,
      petImage: pet.petImage,
      petType: pet.petType,
      size: pet.size,
      gender: pet.gender,
    );

    mockPets.add(newPet);
    return newPet;
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.put('/api/pets/${pet.petId}', data: pet.toJson());
    // return Pet.fromJson(response.data);

    final index = mockPets.indexWhere((p) => p.petId == pet.petId);
    if (index != -1) {
      mockPets[index] = pet;
      return pet;
    }
    throw Exception('Pet not found');
  }

  @override
  Future<void> deletePet(int petId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: await httpClient.delete('/api/pets/$petId');

    mockPets.removeWhere((pet) => pet.petId == petId);
  }

  @override
  Future<List<Pet>> getPetsByAccountId(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/accounts/$accountId/pets');
    // return response.data.map((json) => Pet.fromJson(json)).toList();

    return mockPets.where((pet) => pet.accountId == accountId).toList();
  }
}
