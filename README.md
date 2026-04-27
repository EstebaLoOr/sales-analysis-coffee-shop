# 📊 Sales Analysis to Identify Low-Profitability Products

## Descripción breve

Análisis de ventas de una cafetería real en Cuernavaca, Morelos, para identificar productos de baja rentabilidad, patrones de consumo y oportunidades de crecimiento mediante SQL y Power BI.  
El objetivo principal fue traducir datos históricos en decisiones accionables para aumentar ingresos y optimizar el mix de productos.

---

# 🧠 Problema / Justificación

La cafetería **Corazón de Piedra** contaba con datos históricos de ventas, pero sin una visión clara sobre qué productos generan mayor valor, cuáles tienen bajo desempeño y en qué horarios o días existen oportunidades comerciales.

Este análisis fue motivado por la necesidad de responder preguntas clave como:

- ¿Qué productos impulsan más ingresos?
- ¿Qué artículos venden poco o aportan bajo valor?
- ¿Cuándo se concentran las ventas?
- ¿Cómo aumentar ticket promedio sin atraer más clientes?

### Beneficiarios del análisis:

- Dueño / Dirección del negocio

---

# 📈 Visualización Destacada

El dashboard principal muestra KPIs ejecutivos como ventas netas, ticket promedio, número de tickets y evolución mensual, junto con análisis por categoría, productos top sellers y ventas por horario.

Es importante porque permite detectar rápidamente:

- Días y horas pico
- Productos estrella
- Oportunidades de cross-sell
- Dependencia del fin de semana
- Tendencias de crecimiento

---

# 📂 Conjunto de Datos

**Fuente:** Exportación interna del sistema Punto de Venta (TPV)  
**Tamaño:** 16,656 filas / 23 columnas  
**Formato:** CSV → SQL Database → Power BI

## Variables clave:

- `fecha` → Fecha y hora de la transacción  
- `numero_de_recibo` → ID del ticket  
- `categoria` → Categoría del producto  
- `articulo` → Nombre del producto  
- `cantidad` → Unidades vendidas  
- `ventas_netas` → Venta final después de descuentos  
- `tipo_de_recibo` → Venta o reembolso  
- `tipo_de_pedido` → Comer dentro / Para llevar

## Notas:

- Existían registros duplicados (~3%)
- Valores faltantes en campos de cliente
- Errores de codificación UTF-8
- Algunas categorías incompletas y reclasificadas manualmente

---

# 🔍 Proceso de Análisis

## 1. Exploratory Data Analysis (EDA)

- Distribución de ventas por categoría y producto
- Ventas por día, mes y hora
- Detección de tickets promedio
- Identificación de productos top sellers
- Evaluación de ventas cruzadas (bebida + alimento)

## 2. Preprocesamiento

- Limpieza de nulos
- Eliminación de duplicados
- Conversión de tipos de datos
- Normalización de texto
- Corrección de encoding
- Reclasificación manual de productos

## 3. Análisis / Modelado
N/A

---

# 💡 Principales Hallazgos

📌 La cafetería generó **$1.20M MXN** en menos de un año.  

📌 El ticket promedio fue **$258 MXN**, nivel sólido para cafetería local.  

📌 Solo **48.85%** de tickets combinaron bebida + alimento, mostrando oportunidad clara de cross-selling.  

📌 Viernes, sábado y domingo concentran mayor demanda.  

📌 Existe potencial estimado de **+10% en ingresos** aumentando ticket promedio y optimizando días lentos.

---

# 🛠️ Tecnologías Utilizadas

- SQL (MySQL)
- Power BI
- Excel
- Git
- GitHub

---

# 📁 Estructura del Repositorio

```
📦 sales-analysis-coffee-shop
┣ 📂 SQL
┃ ┗ 📄 coffee_shop_analysis.sql
┣ 📂 dashboard
┃ ┗ 📄 coffee_shop_dashboard.pbix
┣ 📂 data
┃ ┗ 📄 clean_coffee_shop_data.csv
┣ 📂 images
┃ ┗ 📄 dashboard_preview.png
┣ 📄 README.md
┗ 📄 LICENSE
``` 

🚀 Cómo Usar este Proyecto

1. Clonar repositorio
git clone https://github.com/EstebaLoOr/sales-analysis-coffee-shop.git
cd sales-analysis-coffee-shop

## Archivos del proyecto

- 📄 [SQL Analysis](SQL/coffee_shop_analysis.sql)
- 📊 [Power BI Dashboard](dashboard/coffee_shop_dashboard.pbix)
- 🖼️ [Dashboard Preview](images/dashboard_preview.PNG)

👤 Autor
Esteban López Ortega
LinkedIn: https://www.linkedin.com/in/esteban-lopez-711527102/
GitHub: https://github.com/EstebaLoOr

⭐ Notas Finales
Limitaciones
No se contó con costos unitarios confiables por producto
No se incluyeron variables externas (clima, eventos, estacionalidad)
Mejoras Futuras
Análisis de recurrencia de clientes
Rentabilidad real por producto
Forecast de demanda
Dashboard ejecutivo automatizado
Programa de lealtad basado en datos
