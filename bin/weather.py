#!/usr/bin/env python3
import sys
import urllib.request
import json

def get_weather(lat=22.3193, lon=114.1694, location='Hong Kong'):
    try:
        url = f'https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m&timezone=Asia%2FShanghai'
        with urllib.request.urlopen(url) as response:
            data = json.load(response)
        c = data.get('current', {})
        if not c:
            return f'❌ Weather data unavailable for {location}.'
        
        temp = c.get('temperature_2m', 'N/A')
        wc = c.get('weather_code', -1)
        wind = c.get('wind_speed_10m', 'N/A')
        rh = c.get('relative_humidity_2m', 'N/A')
        
        # Weather code descriptions (subset)
        desc = {
            0: '☀️ clear', 1: '🌤️ mainly clear', 2: '⛅ partly cloudy', 3: '☁️ overcast',
            45: '🌫️ fog', 48: '🌫️ depositing rime fog',
            51: '🌦️ light drizzle', 53: '🌧️ moderate drizzle', 55: '🌧️ dense drizzle',
            61: '🌦️ slight rain', 63: '🌧️ moderate rain', 65: '⛈️ heavy rain',
            71: '❄️ slight snow', 73: '🌨️ moderate snow', 75: '☃️ heavy snow',
            80: '☔ slight rain showers', 81: '🌧️ moderate rain showers',
            95: '⚡ thunderstorm', 96: '⛈️ thunderstorm + hail'
        }
        
        weather_desc = desc.get(wc, f'❓ code {wc}')
        return f'{weather_desc}, {temp}°C | 💨 {wind} km/h | 💧 {rh}% RH'
    except Exception as e:
        return f'⚠️ Error fetching weather: {type(e).__name__}'

if __name__ == '__main__':
    print(get_weather())