import 'package:flutter/material.dart';

/// Único campo de texto de la app.
class AppTextField extends StatelessWidget {
  final String etiqueta;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? teclado;
  final bool oculto;
  final IconData? icono;
  final Widget? sufijo;
  final int maxLineas;
  final ValueChanged<String>? onEnviar;
  const AppTextField({
    super.key,
    required this.etiqueta,
    this.controller,
    this.validator,
    this.teclado,
    this.oculto = false,
    this.icono,
    this.sufijo,
    this.maxLineas = 1,
    this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: teclado,
      obscureText: oculto,
      maxLines: oculto ? 1 : maxLineas,
      validator: validator,
      onFieldSubmitted: onEnviar,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: icono == null ? null : Icon(icono),
        suffixIcon: sufijo,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Único selector desplegable de la app (usa solo APIs estables de DropdownButton).
class AppSelect<T> extends StatelessWidget {
  final String etiqueta;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  const AppSelect({
    super.key,
    required this.etiqueta,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: etiqueta,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
