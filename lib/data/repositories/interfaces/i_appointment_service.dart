// Interface for Appointment Service
class Appointment {
  final String appointmentId;
  final String petId;
  final String serviceId;
  final String shopId;
  final DateTime appointmentDate;
  final String status;
  final String notes;
  final double price;

  const Appointment({
    required this.appointmentId,
    required this.petId,
    required this.serviceId,
    required this.shopId,
    required this.appointmentDate,
    required this.status,
    required this.notes,
    required this.price,
  });
}

abstract class IAppointmentService {
  /// Get all appointments for current user
  Future<List<Appointment>> getAllAppointments();

  /// Get appointment by ID
  Future<Appointment?> getAppointmentById(String appointmentId);

  /// Book new appointment
  Future<Appointment> bookAppointment(Appointment appointment);

  /// Update appointment
  Future<Appointment> updateAppointment(Appointment appointment);

  /// Cancel appointment
  Future<void> cancelAppointment(String appointmentId);

  /// Get appointments by status
  Future<List<Appointment>> getAppointmentsByStatus(String status);

  /// Get upcoming appointments
  Future<List<Appointment>> getUpcomingAppointments();
}
