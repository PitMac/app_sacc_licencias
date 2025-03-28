import 'package:app_sacc_licencias/providers/api_provider.dart';
import 'package:app_sacc_licencias/providers/auth_provider.dart';
import 'package:app_sacc_licencias/providers/loading_provider.dart';
import 'package:app_sacc_licencias/utils/colors.dart';
import 'package:app_sacc_licencias/widgets/alert_helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class LicenciasWeb extends HookWidget {
  const LicenciasWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final apiProvider = ApiProvider();
    final loadingProvider = context.read<LoadingProvider>();
    final authProvider = context.read<AuthProvider>();
    final arrLicencias = useState([]);

    loadLicenciasWeb() async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        loadingProvider.show();
        final data = await apiProvider.getLicenciasWeb();
        loadingProvider.hide();
        if (data != null) {
          arrLicencias.value = data;
        } else {
          if (context.mounted) {
            showAppAlert(
              context,
              type: 'error',
              title: 'Error',
              description: 'Error con el servidor.',
              duration: 3,
            );
          }
        }
      });
    }

    useEffect(() {
      loadLicenciasWeb();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Licencias Web',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      floatingActionButton: SpeedDial(
        heroTag: 'web',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes redondeados
        ),
        spacing: 20,
        activeIcon: Icons.close,
        icon: Icons.open_in_full_rounded,
        childrenButtonSize: Size(52, 62),
        children: [
          SpeedDialChild(
            elevation: 5,
            child: Icon(Icons.add),
            label: 'Crear',
            onTap: () {
              Navigator.pushNamed(context, '/web');
            },
          ),
          SpeedDialChild(
            elevation: 5,
            child: Icon(Icons.file_copy),
            label: 'Reporte',
            onTap: () {
              Navigator.pushNamed(context, '/reporte');
            },
          ),
          SpeedDialChild(
            elevation: 5,
            child: Icon(Icons.logout),
            label: 'Cerrar Sesión',
            onTap: () {
              authProvider.logOut(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: arrLicencias.value.length,
        itemBuilder: (context, index) {
          final item = arrLicencias.value[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onLongPress: () => _showPreviewDialog(context, item),
              child: Slidable(
                key: ValueKey('${item['id']}_${item['fecha_instalacion']}'),
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const ScrollMotion(),
                  children: [
                    CustomSlidableAction(
                      borderRadius: BorderRadius.circular(12),
                      onPressed: (context) {
                        Navigator.pushNamed(context, '/web', arguments: item);
                      },
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note_rounded, size: 35),
                          Text('Editar'),
                        ],
                      ),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['client_id'] ?? ''}'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Fecha de instalación: ${item['fecha_instalacion'] ?? ''}',
                      ),
                      Text('Fecha de pago: ${item['fecha_pago'] ?? ''}'),
                      Text('Meses: ${item['meses'] ?? ''}'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['client_id'] ?? ''}'.toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Meses: ${item['meses'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Fecha Instalación: ${item['fecha_instalacion'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Fecha Pago: ${item['fecha_pago'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
