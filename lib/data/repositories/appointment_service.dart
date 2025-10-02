// Appointment Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_appointment_service.dart';
import 'package:myapp/data/mock/appointments_mock.dart';

class AppointmentService implements IAppointmentService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<List<Appointment>> getAllAppointments() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/appointments');
    // return response.data.map((json) => Appointment.fromJson(json)).toList();

    return mockAppointments;
  }

  @override
  Future<Appointment?> getAppointmentById(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/appointments/$appointmentId');
    // return Appointment.fromJson(response.data);

    try {
      return mockAppointments.firstWhere(
        (appointment) => appointment.appointmentId == appointmentId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Appointment> bookAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.post('/api/appointments', data: appointment.toJson());
    // return Appointment.fromJson(response.data);

    mockAppointments.add(appointment);
    return appointment;
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.put('/api/appointments/${appointment.appointmentId}', data: appointment.toJson());
    // return Appointment.fromJson(response.data);

    final index = mockAppointments.indexWhere(
      (a) => a.appointmentId == appointment.appointmentId,
    );
    if (index != -1) {
      mockAppointments[index] = appointment;
      return appointment;
    }
    throw Exception('Appointment not found');
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: await httpClient.delete('/api/appointments/$appointmentId');

    final index = mockAppointments.indexWhere(
      (a) => a.appointmentId == appointmentId,
    );
    if (index != -1) {
      // Update status instead of removing
      mockAppointments[index] = Appointment(
        appointmentId: mockAppointments[index].appointmentId,
        petId: mockAppointments[index].petId,
        serviceId: mockAppointments[index].serviceId,
        shopId: mockAppointments[index].shopId,
        appointmentDate: mockAppointments[index].appointmentDate,
        status: 'cancelled',
        notes: mockAppointments[index].notes,
        price: mockAppointments[index].price,
      );
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/appointments?status=$status');
    // return response.data.map((json) => Appointment.fromJson(json)).toList();

    return mockAppointments
        .where((appointment) => appointment.status == status)
        .toList();
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/appointments/upcoming');
    // return response.data.map((json) => Appointment.fromJson(json)).toList();

    final now = DateTime.now();
    return mockAppointments
        .where(
          (appointment) =>
              appointment.appointmentDate.isAfter(now) &&
              appointment.status != 'cancelled',
        )
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }
}
