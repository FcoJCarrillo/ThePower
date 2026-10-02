"""
main.py - Ejecuta el pipeline completo en orden:

    1. src/01_limpieza_crimenes.py   -> data/interim/crimenes_limpio.csv
    2. src/02_limpieza_clima.py      -> data/interim/clima_diario.csv
    3. src/03_union_exportacion.py   -> data/processed/chicago_crimen_clima.(csv|xlsx)

Uso (con el .venv activado):
    python main.py
"""
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SCRIPTS = [
    "src/01_limpieza_crimenes.py",
    "src/02_limpieza_clima.py",
    "src/03_union_exportacion.py",
]


def main() -> None:
    inicio = time.time()
    for i, script in enumerate(SCRIPTS, start=1):
        print(f"\n=== Paso {i}/{len(SCRIPTS)}: {script} ===")
        # sys.executable = el Python que ejecuta main.py (el del .venv si está activado)
        resultado = subprocess.run([sys.executable, str(ROOT / script)], cwd=ROOT)
        if resultado.returncode != 0:
            print(f"\nERROR en {script}. Pipeline detenido.")
            sys.exit(resultado.returncode)
    print(f"\nPipeline completado en {time.time() - inicio:.0f} s.")
    print("Dataset final: data/processed/chicago_crimen_clima.xlsx (y .csv)")


if __name__ == "__main__":
    main()
