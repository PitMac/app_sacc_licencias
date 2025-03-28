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

class LicenciasMovil extends HookWidget {
  const LicenciasMovil({super.key});

  @override
  Widget build(BuildContext context) {
    final apiProvider = ApiProvider();
    final authProvider = context.read<AuthProvider>();
    final loadingProvider = context.read<LoadingProvider>();
    final arrLicencias = useState([]);

    loadLicenciasMovil() async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        loadingProvider.show();
        final data = await apiProvider.getLicenciasMobil();
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
      loadLicenciasMovil();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Licencias Movil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      floatingActionButton: SpeedDial(
        heroTag: 'movil',
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
              Navigator.pushNamed(context, '/movil');
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
                key: ValueKey('${item['id']}_${item['uc']}'),
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const ScrollMotion(),
                  children: [
                    CustomSlidableAction(
                      borderRadius: BorderRadius.circular(12),
                      onPressed: (context) {},
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
                        '${item['descripcion'] ?? ''}'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('Clave: ${item['clave'] ?? ''}'),
                      Text('Ruc: ${item['ruc'] ?? ''}'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item['descripcion'] ?? ''}'.toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Clave: ${item['clave'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'RUC: ${item['ruc'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Ruta: ${item['ruta'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Referencia: ${item['referencia'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Fecha Creacion: ${item['fecha_creacion'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Fecha Modificacion: ${item['fecha_modificacion'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Client ID: ${item['client_id'] ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),

                Text(
                  'Client Password: ${item['client_password'] ?? ''}',
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
