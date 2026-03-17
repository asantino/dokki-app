import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/business.dart';
// Исправлен путь импорта: добавлено ../
import '../../providers/bot_management_providers.dart';

class AppointmentsScreen extends ConsumerWidget {
  final Business business;

  const AppointmentsScreen({
    super.key,
    required this.business,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider(business));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Записи на приём'),
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Ошибка загрузки: $err', textAlign: TextAlign.center),
          ),
        ),
        data: (appointments) {
          if (appointments.isEmpty) {
            return const Center(
              child: Text('Список записей пуст'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final status = appointment['status']?.toString() ?? 'pending';
              final dateString =
                  appointment['datetime_utc']?.toString() ?? 'Дата не указана';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        _getStatusColor(status).withValues(alpha: 0.1),
                    child: Icon(
                      Icons.calendar_today,
                      color: _getStatusColor(status),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    appointment['client_name']?.toString() ??
                        'Клиент без имени',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(dateString),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
