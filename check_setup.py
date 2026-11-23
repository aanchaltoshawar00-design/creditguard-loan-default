"""Run this after installing requirements to confirm everything works."""
import sys
import sqlite3

print(f"Python version: {sys.version.split()[0]}")
if sys.version_info < (3, 10):
    print("  WARNING: Python 3.10 or newer is recommended.")

libs = ["pandas", "numpy", "matplotlib", "seaborn", "sklearn"]
ok = True
for lib in libs:
    try:
        mod = __import__(lib)
        print(f"  OK  {lib} {getattr(mod, '__version__', '')}")
    except ImportError:
        ok = False
        print(f"  MISSING  {lib}  ->  pip install -r requirements.txt")

print(f"  OK  sqlite3 {sqlite3.sqlite_version} (built into Python)")
print("\nAll set!" if ok else "\nFix the missing libraries above, then run again.")
