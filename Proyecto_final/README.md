# Crimen y clima en Chicago (2026)

Proyecto final: EDA + dashboard sobre la relación entre los crímenes registrados en Chicago y las condiciones meteorológicas durante 2026.

> **Estado del proyecto:** limpieza, unión y exportación del dataset final completadas. Pendientes: análisis descriptivo y estadístico, dashboard en Power BI e informe (secciones marcadas con ⏳ más abajo).

## 1. Objetivo y preguntas de análisis

Analizar si el clima influye en la criminalidad de Chicago. Preguntas de partida:

1. ¿Hay más crímenes los días de más calor? ¿Es significativa la correlación temperatura–crímenes?
2. ¿Afecta la lluvia o el viento al volumen de crímenes?
3. ¿Responden igual todos los tipos de delito (robos, agresiones, daño a la propiedad...)?
4. ¿Cómo varía el patrón por hora, día de la semana, distrito y estación?
5. ¿Cambia la tasa de arrestos según el clima?

## 2. Estructura del repositorio

```
Proyecto_final/
├── data/
│   ├── raw/          # Datos en bruto (2 fuentes), sin modificar
│   ├── interim/      # Datos limpios por fuente
│   └── processed/    # Dataset final (CSV y Excel para Power BI)
├── src/              # Scripts de limpieza, unión y exportación
├── notebooks/        # EDA y análisis estadístico ⏳
├── dashboard/        # Archivo .pbix de Power BI ⏳
├── docs/             # Informe ⏳
├── images/           # Capturas del dashboard y gráficos ⏳
├── requirements.txt
└── README.md
```

## 3. Datos

| Fuente | Archivo | Descripción |
|---|---|---|
| Chicago Data Portal – *Crimes 2026* | `data/raw/Crimes_2026_raw.csv` | 168.766 incidentes (1 ene – 26 sep 2026), 22 columnas |
| Chicago Data Portal – *Beach Weather Stations – Automated Sensors* ([catalog.data.gov](https://catalog.data.gov/dataset/beach-weather-stations-automated-sensors)) | `data/raw/Beach_Weather_Stations_raw.csv` | Lecturas horarias de estaciones meteorológicas (2015–2026), 18 columnas |

**Dataset final:** `data/processed/chicago_crimen_clima.csv` / `.xlsx` → **168.751 filas × 42 columnas** (requisito: ≥ 50.000 × 20). El Excel incluye tres hojas: `datos_finales`, `clima_diario` y `diccionario` (descripción de las 42 columnas).

## 4. Cómo ejecutarlo (Windows + VS Code)

```powershell
cd C:\ThePower\Proyecto_final
python -m venv .venv
.venv\Scripts\activate          # si PowerShell lo bloquea: Set-ExecutionPolicy -Scope Process RemoteSigned
pip install -r requirements.txt

python src/01_limpieza_crimenes.py
python src/02_limpieza_clima.py
python src/03_union_exportacion.py
```

En VS Code: `Ctrl+Shift+P` → *Python: Select Interpreter* → elegir el de `.venv`.

## 5. Proceso de limpieza y transformación

### Crímenes (`src/01_limpieza_crimenes.py`)
- **Corte por datos incompletos:** los últimos días del extracto estaban sin registrar (22-sep: 14 registros; 23 a 25-sep: 0; 26-sep: 1; mediana diaria ≈ 650). Se descartan los 15 registros posteriores al **21-sep-2026** para no distorsionar los conteos diarios.
- Eliminadas columnas redundantes o constantes: `X/Y Coordinate`, `Location`, `Year`, `Updated On`.
- Columnas renombradas a `snake_case` en español.
- Códigos (`iucr`, `codigo_fbi`, `beat`, `distrito`) tratados como texto para conservar los ceros a la izquierda.
- Latitud/longitud venían con coma decimal → convertidas a número y validadas dentro de los límites de Chicago. **343 registros sin coordenadas** (se mantienen, solo quedan fuera de los mapas).
- 760 nulos en `lugar` → categoría `DESCONOCIDO`. 1 nulo en `area_comunitaria` (se mantiene como vacío).
- Duplicados por `id_crimen`: 0.
- Variables derivadas: `fecha`, `hora`, `hora_exacta` (False si es exactamente 00:00, probable hora desconocida), `mes`, `mes_nombre`, `dia_semana`, `fin_de_semana`, `franja_horaria`, `estacion`.

### Clima (`src/02_limpieza_clima.py`)
- Filtrado a 2026 (11.931 lecturas horarias de las estaciones **Foster** y **Oak Street**; la 63rd Street no tiene datos en 2026).
- `Solar Radiation` llegaba como texto → numérico. Valores centinela `999.9` de viento → nulo. Radiación negativa (ruido nocturno) → 0.
- Las variables que solo mide una estación (p. ej. bulbo húmedo) se descartan del análisis.
- **Agregación diaria:** primero por estación y luego entre estaciones (media para temperatura media, humedad, lluvia, viento, presión y radiación; mínimo/máximo global para `temp_min`, `temp_max` y `viento_max`). Resultado: 273 días, sin huecos.
- Derivadas: `amplitud_termica`, `rango_temperatura` (Helada / Frío / Templado / Cálido / Caluroso), `dia_lluvioso` (≥ 1 mm).

### Unión (`src/03_union_exportacion.py`)
- `merge` *left* de crímenes con clima diario por `fecha` (relación muchos a uno). **Ningún crimen quedó sin clima.**
- Se añade `crimenes_dia` (total de crímenes de Chicago ese día).
- Se exporta CSV y Excel (con hoja de diccionario) listo para importar en Power BI.

## 6. Limitaciones conocidas

- **Clima a nivel ciudad:** se asigna el mismo clima a todos los crímenes de un día, sin distinguir distritos (solo hay 2 estaciones, ambas junto al lago).
- **Diferencias entre estaciones:** Foster registra bastante más lluvia acumulada que Oak Street (correlación diaria de 0,84 entre ambas). La lluvia diaria es la media de las dos y debe interpretarse como orientativa.
- **Un solo año (ene–sep 2026):** no cubre octubre–diciembre ni permite comparar con otros años.
- **Correlación ≠ causalidad:** la temperatura se solapa con la estacionalidad (vacaciones, horas de luz, eventos).
- **Hora desconocida:** parte de los registros con hora 00:00 son horas no informadas; hay que tenerlo en cuenta en análisis por hora (`hora_exacta`).

## 7. Análisis descriptivo y estadístico ⏳

_Pendiente: notebook en `notebooks/` con estadística descriptiva, correlaciones (Pearson/Spearman), contrastes de hipótesis y comparativas por tipo de delito._

## 8. Dashboard ⏳

_Pendiente: Power BI importando `data/processed/chicago_crimen_clima.xlsx` (hoja `datos_finales`)._

## 9. Informe y conclusiones ⏳

_Pendiente._
