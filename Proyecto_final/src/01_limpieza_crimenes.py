"""
01 - Limpieza y transformación del dataset de crímenes de Chicago (2026).

Entrada : data/raw/Crimes_2026_raw.csv
Salida  : data/interim/crimenes_limpio.csv
"""
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "Crimes_2026_raw.csv"
OUT = ROOT / "data" / "interim" / "crimenes_limpio.csv"

# Último día con registro completo (ver nota en main)
FECHA_CORTE = pd.Timestamp("2026-09-21 23:59:59")

MESES = {1: "Enero", 2: "Febrero", 3: "Marzo", 4: "Abril", 5: "Mayo", 6: "Junio",
         7: "Julio", 8: "Agosto", 9: "Septiembre", 10: "Octubre", 11: "Noviembre", 12: "Diciembre"}
DIAS = {0: "Lunes", 1: "Martes", 2: "Miércoles", 3: "Jueves", 4: "Viernes", 5: "Sábado", 6: "Domingo"}
ESTACIONES = {12: "Invierno", 1: "Invierno", 2: "Invierno", 3: "Primavera", 4: "Primavera",
              5: "Primavera", 6: "Verano", 7: "Verano", 8: "Verano", 9: "Otoño", 10: "Otoño", 11: "Otoño"}

RENOMBRAR = {
    "ID": "id_crimen", "Case Number": "numero_caso", "Date": "fecha_hora", "Block": "bloque",
    "IUCR": "iucr", "Primary Type": "tipo_crimen", "Description": "descripcion",
    "Location Description": "lugar", "Arrest": "arresto", "Domestic": "domestico",
    "Beat": "beat", "District": "distrito", "Ward": "ward", "Community Area": "area_comunitaria",
    "FBI Code": "codigo_fbi", "Latitude": "latitud", "Longitude": "longitud",
}


def franja(h: int) -> str:
    if h < 6:
        return "Madrugada (0-5h)"
    if h < 12:
        return "Mañana (6-11h)"
    if h < 18:
        return "Tarde (12-17h)"
    return "Noche (18-23h)"


def main() -> pd.DataFrame:
    # Códigos que deben conservar ceros a la izquierda se leen como texto
    df = pd.read_csv(RAW, dtype={"IUCR": str, "FBI Code": str, "Beat": str, "District": str,
                                 "Latitude": str, "Longitude": str})
    print(f"[crimenes] filas brutas: {len(df):,} | columnas: {df.shape[1]}")

    # Columnas que no aportan: coordenadas proyectadas (redundantes con lat/lon),
    # 'Location' (texto duplicado de lat/lon), 'Year' (constante) y 'Updated On' (metadato).
    df = df.drop(columns=["X Coordinate", "Y Coordinate", "Location", "Year", "Updated On"])
    df = df.rename(columns=RENOMBRAR)

    # Corte por retraso de registro: los últimos días del extracto están incompletos
    # (22-sep: 14 registros, 23 a 25-sep: 0, 26-sep: 1, frente a una mediana de ~650/día).
    fecha_tmp = pd.to_datetime(df["fecha_hora"], format="%m/%d/%Y %I:%M:%S %p")
    incompletos = fecha_tmp > FECHA_CORTE
    print(f"[crimenes] registros posteriores a {FECHA_CORTE.date()} descartados por estar incompletos: {incompletos.sum()}")
    df = df[~incompletos].copy()

    # Duplicados
    n = len(df)
    df = df.drop_duplicates(subset="id_crimen")
    print(f"[crimenes] duplicados por id eliminados: {n - len(df)}")

    # Texto: espacios y mayúsculas homogéneas
    for c in ["numero_caso", "bloque", "iucr", "tipo_crimen", "descripcion", "lugar", "codigo_fbi"]:
        df[c] = df[c].astype("string").str.strip().str.upper()

    # Formatos de código
    df["beat"] = df["beat"].str.strip().str.zfill(4)
    df["distrito"] = df["distrito"].str.strip().str.zfill(3)
    df["ward"] = df["ward"].astype("Int64")
    df["area_comunitaria"] = df["area_comunitaria"].astype("Int64")

    # Fecha y hora
    df["fecha_hora"] = pd.to_datetime(df["fecha_hora"], format="%m/%d/%Y %I:%M:%S %p")

    # Coordenadas: vienen con coma decimal ("41,9095") -> float; fuera de Chicago -> NaN
    for c in ["latitud", "longitud"]:
        df[c] = pd.to_numeric(df[c].str.replace(",", ".", regex=False), errors="coerce")
    fuera = df["latitud"].notna() & (~df["latitud"].between(41.6, 42.1) | ~df["longitud"].between(-87.95, -87.5))
    df.loc[fuera, ["latitud", "longitud"]] = np.nan
    print(f"[crimenes] sin coordenadas válidas: {df['latitud'].isna().sum():,}")

    # Nulos de 'lugar' -> categoría explícita
    print(f"[crimenes] 'lugar' nulo: {df['lugar'].isna().sum()} -> 'DESCONOCIDO'")
    df["lugar"] = df["lugar"].fillna("DESCONOCIDO")

    # Variables derivadas
    f = df["fecha_hora"]
    df["fecha"] = f.dt.normalize()
    df["hora"] = f.dt.hour
    df["hora_exacta"] = ~((f.dt.hour == 0) & (f.dt.minute == 0))  # 00:00 suele ser "hora desconocida"
    df["mes"] = f.dt.month
    df["mes_nombre"] = df["mes"].map(MESES)
    df["dia_semana_num"] = f.dt.dayofweek
    df["dia_semana"] = df["dia_semana_num"].map(DIAS)
    df["fin_de_semana"] = df["dia_semana_num"] >= 5
    df["franja_horaria"] = df["hora"].map(franja)
    df["estacion"] = df["mes"].map(ESTACIONES)

    df = df.sort_values("fecha_hora").reset_index(drop=True)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUT, index=False)
    print(f"[crimenes] filas limpias: {len(df):,} | columnas: {df.shape[1]} -> {OUT.relative_to(ROOT)}")
    return df


if __name__ == "__main__":
    main()
