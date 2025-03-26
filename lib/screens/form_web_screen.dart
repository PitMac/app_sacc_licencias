import 'package:app_sacc_licencias/providers/api_provider.dart';
import 'package:app_sacc_licencias/utils/theme.dart';
import 'package:app_sacc_licencias/widgets/alert_helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class FormWebScreen extends HookWidget {
  const FormWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final existingData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final apiProvider = ApiProvider();

    final clientController = useTextEditingController(
      text: existingData?['client_id'] ?? '',
    );
    final mesesController = useTextEditingController(
      text: existingData?['meses'] ?? '',
    );

    final fechaInstalacion = useState<DateTime>(
      existingData?['fecha_instalacion'] != null
          ? DateTime.parse(existingData!['fecha_instalacion'])
          : DateTime.now(),
    );
    final fechaPago = useState<DateTime>(
      existingData?['fecha_pago'] != null
          ? DateTime.parse(existingData!['fecha_pago'])
          : DateTime.now(),
    );

    Future<void> selectDate(ValueNotifier<DateTime?> fecha) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) => datePickerTheme(context, child),
      );
      if (picked != null) {
        fecha.value = picked;
      }
    }

    createLicencia() async {
      final dataSend = {
        'client_id': clientController.text,
        'meses': mesesController.text,
        'fechainstalacion': DateFormat(
          'yyyy-MM-dd',
        ).format(fechaInstalacion.value),
        'fechapago': DateFormat('yyyy-MM-dd').format(fechaPago.value),
      };
      if (existingData?['id'] != null) {
      } else {
        final data = await apiProvider.postLicenciaWeb(dataSend);
        if (data) {
          showAppAlert(
            context,
            type: 'success',
            title: 'Éxito',
            description: 'Licencia creada exitosamente.',
            duration: 3,
          );
        } else {
          showAppAlert(
            context,
            type: 'error',
            title: 'Error',
            description: 'No se pudo crear la orden.',
            duration: 3,
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${existingData?['client_id'] ?? 'Nueva'}'.toUpperCase()),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'web',
        label: Text('Guardar'),
        onPressed: () {
          createLicencia();
        },
        icon: Icon(Icons.save_rounded),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          spacing: 15,
          children: [
            TextFormField(
              controller: clientController,
              decoration: InputDecoration(labelText: 'Cliente'),
            ),

            TextFormField(
              controller: mesesController,
              decoration: InputDecoration(labelText: 'Meses'),
            ),

            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(fechaInstalacion.value),
              ),
              decoration: InputDecoration(
                labelText: 'Fecha Instalación',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => selectDate(fechaInstalacion),
                ),
              ),
              onTap: () => selectDate(fechaInstalacion),
            ),

            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(fechaPago.value),
              ),
              decoration: InputDecoration(
                labelText: 'Fecha de Pago',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => selectDate(fechaPago),
                ),
              ),
              onTap: () => selectDate(fechaPago),
            ),
          ],
        ),
      ),
    );
  }
}
