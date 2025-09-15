#!/usr/bin/env python3
import os
import re
from pathlib import Path

def sort_imports_in_file(file_path):
    """Sort import statements in a Dart file by line length."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    import_lines = []
    non_import_lines = []
    import_section_ended = False

    for line in lines:
        stripped = line.strip()

        # Check if this is an import line
        if stripped.startswith('import ') and not import_section_ended:
            import_lines.append(line)
        else:
            # If we hit a non-import line after imports, mark section as ended
            if import_lines and not stripped.startswith('import ') and stripped != '':
                import_section_ended = True
            non_import_lines.append(line)

    # Sort imports by length (shortest to longest for staircase effect)
    import_lines.sort(key=len)

    # Reconstruct the file content
    result_lines = import_lines + non_import_lines
    new_content = '\n'.join(result_lines)

    # Only write if content changed
    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

def main():
    """Process all Dart files in the project."""
    project_root = Path('.')
    dart_files = list(project_root.glob('**/*.dart'))

    processed_count = 0
    modified_count = 0

    for dart_file in dart_files:
        # Skip test files and generated files
        if 'test/' in str(dart_file) or '.g.dart' in str(dart_file):
            continue

        try:
            was_modified = sort_imports_in_file(dart_file)
            processed_count += 1
            if was_modified:
                modified_count += 1
                print(f"✓ Sorted imports in {dart_file}")
            else:
                print(f"- No changes needed in {dart_file}")
        except Exception as e:
            print(f"✗ Error processing {dart_file}: {e}")

    print(f"\nProcessed {processed_count} files, modified {modified_count} files")

if __name__ == "__main__":
    main()