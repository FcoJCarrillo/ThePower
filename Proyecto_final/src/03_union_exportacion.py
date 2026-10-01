"""
03 - Unión de crímenes y clima (por día) y exportación del dataset final.

Entradas : data/interim/crimenes_limpio.csv, data/interim/clima_diario.csv
Salidas  : data/processed/chicago_crimen_clima.csv
           data/processed/chicago_crimen_clima.xlsx  (para Power BI)
"""
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
CRIMENES = ROOT / "data" / "interim" / "crimenes_limpio.csv"
CLIMA = ROOT / "data" / "interim" / "clima_diario.csv"
OUT_CSV = ROOT / "data" / "processed" / "chicago_crimen_clima.csv"
OUT_XLSX = ROOT / "data" / "processed" / "chicago_crimen_clima.xlsx"

DICCIONARIO = [
    ("id_crimen", "Crímenes", "Identificador único del registro"),
    ("numero_caso", "Crímenes", "Número de caso del Departamento de Policía de Chicago (RD)"),
    ("fecha_hora", "Crímenes", "Fecha y hora del incidente"),
    ("bloque", "Crímenes", "Dirección parcial (bloque) donde ocurrió"),
    ("iucr", "Crímenes", "Código Illinois Uniform Crime Reporting"),
    ("tipo_crimen", "Crímenes", "Categoría principal del delito (31 tipos)"),
    ("descripcion", "Crímenes", "Descripción secundaria del delito"),
    ("lugar", "Crímenes", "Tipo de lugar del incidente ('DESCONOCIDO' si no consta)"),
    ("arresto", "Crímenes", "Si hubo arresto"),
    ("domestico", "Crímenes", "Si fue un incidente doméstico"),
    ("beat", "Crímenes", "Zona policial mínima (4 dígitos)"),
    ("distrito", "Crímenes", "Distrito policial (3 dígitos)"),
    ("ward", "Crímenes", "Ward (distrito electoral) del ayuntamiento"),
    ("area_comunitaria", "Crímenes", "Número de área comunitaria (1-77)"),
    ("codigo_fbi", "Crímenes", "Clasificación FBI (NIBRS)"),
    ("latitud", "Crímenes", "Latitud (vacía si no hay ubicación válida)"),
    ("longitud", "Crímenes", "Longitud (vacía si no hay ubicación válida)"),
    ("fecha", "Derivada", "Fecha sin hora; clave de unión con el clima"),
    ("hora", "Derivada", "Hora del día (0-23)"),
    ("hora_exacta", "Derivada", "False si la hora es exactamente 00:00 (probable hora desconocida)"),
    ("mes", "Derivada", "Mes (1-12)"),
    ("mes_nombre", "Derivada", "Nombre del mes"),
    ("dia_semana_num", "Derivada", "Día de la semana (0 = lunes ... 6 = domingo)"),
    ("dia_semana", "Derivada", "Nombre del día de la semana"),
    ("fin_de_semana", "Derivada", "True si es sábado o domingo"),
    ("franja_horaria", "Derivada", "Madrugada / Mañana / Tarde / Noche"),
    ("estacion", "Derivada", "Estación meteorológica (inv: dic-feb, prim: mar-may, ver: jun-ago, oto: sep-nov)"),
    ("temp_media", "Clima", "Temperatura del aire media del día (°C), media de estaciones"),
    ("temp_min", "Clima", "Temperatura mínima del día (°C), mínimo entre estaciones"),
    ("temp_max", "Clima", "Temperatura máxima del día (°C), máximo entre estaciones"),
    ("humedad_media", "Clima", "Humedad relativa media (%)"),
    ("lluvia_total_mm", "Clima", "Lluvia acumulada en el día (mm), media entre estaciones"),
    ("viento_medio", "Clima", "Velocidad media del viento (m/s)"),
    ("viento_max", "Clima", "Racha máxima de viento del día (m/s)"),
    ("presion_media", "Clima", "Presión barométrica media (hPa)"),
    ("radiacion_media", "Clima", "Radiación solar media (W/m²)"),
    ("lecturas", "Clima", "Nº de lecturas horarias usadas ese día (todas las estaciones)"),
    ("n_estaciones", "Clima", "Nº de estaciones con datos ese día (1 o 2)"),
    ("amplitud_termica", "Derivada", "temp_max - temp_min (°C)"),
    ("rango_temperatura", "Derivada", "Categoría de temperatura media: Helada / Frío / Templado / Cálido / Caluroso"),
    ("dia_lluvioso", "Derivada", "True si lluvia_total_mm >= 1"),
    ("crimenes_dia", "Derivada", "Total de crímenes registrados ese día en Chicago"),
]


def exportar_excel(df: pd.DataFrame, clima: pd.DataFrame, dic: pd.DataFrame) -> None:
    with pd.ExcelWriter(OUT_XLSX, engine="xlsxwriter", datetime_format="yyyy-mm-dd hh:mm",
                        date_format="yyyy-mm-dd") as xw:
        wb = xw.book
        cab = wb.add_format({"bold": True, "font_name": "Arial", "bg_color": "#1F3864",
                             "font_color": "#FFFFFF", "border": 1})
        for nombre, datos in [("datos_finales", df), ("clima_diario", clima), ("diccionario", dic)]:
            datos.to_excel(xw, sheet_name=nombre, index=False, startrow=0)
            ws = xw.sheets[nombre]
            for j, col in enumerate(datos.columns):
                ws.write(0, j, col, cab)
            ws.freeze_panes(1, 0)
            ws.autofilter(0, 0, len(datos), len(datos.columns) - 1)
            for j, col in enumerate(datos.columns):
                ancho = max(12, min(45, len(str(col)) + 4))
                if nombre == "diccionario":
                    ancho = [22, 12, 90][j]
                ws.set_column(j, j, ancho)


def main() -> pd.DataFrame:
    crim = pd.read_csv(CRIMENES, dtype={"iucr": str, "codigo_fbi": str, "beat": str, "distrito": str},
                       parse_dates=["fecha_hora", "fecha"])
    clima = pd.read_csv(CLIMA, parse_dates=["fecha"])

    df = crim.merge(clima, on="fecha", how="left", validate="many_to_one")

    sin_clima = df["temp_media"].isna().sum()
    print(f"[union] crímenes: {len(crim):,} | días de clima: {len(clima)} | crímenes sin clima: {sin_clima}")
    assert len(df) == len(crim), "La unión ha cambiado el nº de filas"

    df["crimenes_dia"] = df.groupby("fecha")["id_crimen"].transform("count")

    # Orden de columnas según el diccionario
    orden = [c for c, _, _ in DICCIONARIO]
    faltan = set(df.columns) - set(orden)
    assert not faltan, f"Columnas sin documentar: {faltan}"
    df = df[orden]

    filas, cols = df.shape
    print(f"[union] dataset final: {filas:,} filas x {cols} columnas")
    assert filas >= 50_000 and cols >= 20, "No se cumplen los mínimos del proyecto"

    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUT_CSV, index=False)
    print(f"[union] -> {OUT_CSV.relative_to(ROOT)}")

    dic = pd.DataFrame(DICCIONARIO, columns=["columna", "origen", "descripcion"])
    exportar_excel(df, clima, dic)
    print(f"[union] -> {OUT_XLSX.relative_to(ROOT)}")
    return df


if __name__ == "__main__":
    main()
