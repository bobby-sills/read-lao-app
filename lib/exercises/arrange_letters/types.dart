enum Section { upper, lower }

typedef DropLocation = (int, Section);

extension CopyableDropLocation on DropLocation {
  DropLocation copyWith({int? index, Section? section}) =>
      (index ?? this.$1, section ?? this.$2);
}
