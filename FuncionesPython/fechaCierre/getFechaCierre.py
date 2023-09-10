import calendar
from datetime import date, datetime, timedelta

def get_last_day_of_last_month(fecha):
    fecha = datetime.strptime(fecha, "%Y-%m-%d")
    # get the current_year and current_month 
    current_year = fecha.year
    current_month = fecha.month
    if current_month == 1: 
        last_month = 12
        last_year = current_year - 1
    else:
        last_month = current_month - 1
        last_year = current_year
    # Using datetime module
    _, lastDay_OfLastMonth = calendar.monthrange(last_year, last_month)
    # return last_day_of_last_month

    # Fecha Cierre
    fechaCierre_mesAnterior = date(last_year, last_month, lastDay_OfLastMonth)
    print(fechaCierre_mesAnterior)

varFecha = input('Ingrese fecha (YYYY-MM-DD): ')
get_last_day_of_last_month(varFecha)