import 'package:app_sacc_licencias/providers/api_provider.dart';
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
        title: Text('Licencias Movil'),
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
        ],
      ),
      body: ListView.builder(
        itemCount: arrLicencias.value.length,
        itemBuilder: (context, index) {
          final item = arrLicencias.value[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slidable(
              key: ValueKey('${item['id']}_${item['uc']}'),
              endActionPane: ActionPane(
                extentRatio: 0.2,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(12),
                    onPressed: (context) {},
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    icon: Icons.edit_note_rounded,

                    label: 'Editar',
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
          );
        },
      ),
    );
  }
}
