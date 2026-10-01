"""
02 - Limpieza del clima (Beach Weather Stations - Automated Sensors) y agregación diaria.

Se filtra a 2026 y se agrega de lecturas horarias (2 estaciones: Foster y Oak Street)
a una fila por día: primero se calcula cada estación y después se promedia entre estaciones.

Entrada : data/raw/Beach_Weather_Stations_raw.csv
Salida  : data/interim/clima_diario.csv
"""
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "Beach_Weather_Stations_raw.csv"
OUT = ROOT / "data" / "interim" / "clima_diario.csv"

ANIO = 2026
NUMERICAS = ["Air Temperature", "Humidity", "Interval Rain", "Wind Speed",
             "Maximum Wind Speed", "Barometric Pressure", "Solar Radiation"]


def rango_temperatura(t: float) -> str:
    if pd.isna(t):
        return "Sin dato"
    if t < 0:
        return "Helada (<0°C)"
    if t < 10:
        return "Frío (0-10°C)"
    if t < 20:
        return "Templado (10-20°C)"
    if t < 28:
        return "Cálido (20-28°C)"
    return "Caluroso (≥28°C)"


def main() -> pd.DataFrame:
    df = pd.read_csv(RAW, low_memory=False)
    print(f"[clima] filas brutas: {len(df):,} (todos los años)")

    df["timestamp"] = pd.to_datetime(df["Measurement Timestamp"], format="%m/%d/%Y %I:%M:%S %p")
    df = df[df["timestamp"].dt.year == ANIO].copy()
    df = df.drop_duplicates(subset="Measurement ID")
    print(f"[clima] filas de {ANIO}: {len(df):,} | estaciones: {sorted(df['Station Name'].unique())}")

    # Conversión numérica (Solar Radiation llega como texto)
    for c in NUMERICAS:
        df[c] = pd.to_numeric(df[c], errors="coerce")

    # Valores imposibles o centinela -> NaN
    df.loc[df["Wind Speed"] >= 999, "Wind Speed"] = np.nan            # 999.9 = sensor sin lectura
    df.loc[df["Maximum Wind Speed"] >= 999, "Maximum Wind Speed"] = np.nan
    df.loc[~df["Air Temperature"].between(-40, 45), "Air Temperature"] = np.nan
    df.loc[~df["Humidity"].between(0, 100), "Humidity"] = np.nan
    df.loc[~df["Barometric Pressure"].between(900, 1100), "Barometric Pressure"] = np.nan
    df["Solar Radiation"] = df["Solar Radiation"].clip(lower=0)        # negativos pequeños = ruido nocturno

    df["fecha"] = df["timestamp"].dt.normalize()
    df = df.rename(columns={"Station Name": "estacion"})

    # 1) Agregación diaria por estación
    por_estacion = df.groupby(["fecha", "estacion"]).agg(
        temp_media=("Air Temperature", "mean"),
        temp_min=("Air Temperature", "min"),
        temp_max=("Air Temperature", "max"),
        humedad_media=("Humidity", "mean"),
        lluvia_total_mm=("Interval Rain", "sum"),
        viento_medio=("Wind Speed", "mean"),
        viento_max=("Maximum Wind Speed", "max"),
        presion_media=("Barometric Pressure", "mean"),
        radiacion_media=("Solar Radiation", "mean"),
        lecturas=("Air Temperature", "count"),
    ).reset_index()

    # 2) Agregación entre estaciones: medias entre estaciones; extremos = extremo global
    diario = por_estacion.groupby("fecha").agg(
        temp_media=("temp_media", "mean"),
        temp_min=("temp_min", "min"),
        temp_max=("temp_max", "max"),
        humedad_media=("humedad_media", "mean"),
        lluvia_total_mm=("lluvia_total_mm", "mean"),
        viento_medio=("viento_medio", "mean"),
        viento_max=("viento_max", "max"),
        presion_media=("presion_media", "mean"),
        radiacion_media=("radiacion_media", "mean"),
        lecturas=("lecturas", "sum"),
        n_estaciones=("estacion", "nunique"),
    ).reset_index()

    diario["amplitud_termica"] = diario["temp_max"] - diario["temp_min"]
    diario["rango_temperatura"] = diario["temp_media"].map(rango_temperatura)
    diario["dia_lluvioso"] = diario["lluvia_total_mm"] >= 1.0   # criterio meteorológico: >= 1 mm

    # Comprobación de cobertura: un registro por cada día del rango
    esperados = pd.date_range(diario["fecha"].min(), diario["fecha"].max(), freq="D")
    faltan = esperados.difference(diario["fecha"])
    print(f"[clima] días con dato: {len(diario)} | días sin dato en el rango: {len(faltan)}")

    cols_num = diario.select_dtypes("number").columns.difference(["lecturas", "n_estaciones"])
    diario[cols_num] = diario[cols_num].round(2)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    diario.to_csv(OUT, index=False)
    print(f"[clima] -> {OUT.relative_to(ROOT)} ({len(diario)} filas)")
    return diario


if __name__ == "__main__":
    main()
