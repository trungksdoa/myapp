// Interface for Pet Service
import 'package:myapp/shared/model/pet.dart';

abstract class IPetService {
  /// Get all pets for current user
  Future<List<Pet>> getAllPets();

  /// Get pet by ID
  Future<Pet?> getPetById(int petId);

  /// Add new pet
  Future<Pet> addPet(Pet pet);

  /// Update pet information
  Future<Pet> updatePet(Pet pet);

  /// Delete pet
  Future<void> deletePet(int petId);

  /// Get pets by account ID
  Future<List<Pet>> getPetsByAccountId(String accountId);
}
