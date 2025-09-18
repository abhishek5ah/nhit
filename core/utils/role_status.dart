import 'package:flutter/material.dart';

/// Returns a pair of colors (background and text) for a permission string
class PermissionColors {
  final Color background;
  final Color text;

  const PermissionColors(this.background, this.text);
}

/// Get color scheme for a permission string
PermissionColors getPermissionColors(String perm, BuildContext context) {
  final scheme = Theme.of(context).colorScheme;

  if (perm.contains("delete") || perm.contains("error")) {
    return PermissionColors(scheme.errorContainer, scheme.onErrorContainer);
  } else if (perm.contains("edit") ||
      perm.contains("active") ||
      perm.contains("view")) {
    return PermissionColors(
      scheme.secondaryContainer,
      scheme.onSecondaryContainer,
    );
  } else if (perm.contains("create") || perm.contains("new")) {
    return PermissionColors(
      scheme.tertiaryContainer,
      scheme.onTertiaryContainer,
    );
  }
  // Default
  return PermissionColors(scheme.primaryContainer, scheme.onPrimaryContainer);
}
