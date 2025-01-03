from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

WEATHER_API_URL = "https://api.open-meteo.com/v1/forecast"

@app.route("/weather", methods=["GET"])
def get_weather():
    city = request.args.get("city")
    lat = request.args.get("lat")
    lon = request.args.get("lon")

    if not (lat and lon):
        return jsonify({"error": "Latitude and Longitude are required"}), 400

    try:
        response = requests.get(
            WEATHER_API_URL,
            params={
                "latitude": lat,
                "longitude": lon,
                "current_weather": "true",
            },
        )
        response.raise_for_status()
        weather_data = response.json()
        return jsonify(weather_data.get("current_weather", {}))
    except requests.exceptions.RequestException as e:
        return jsonify({"error": "Failed to fetch weather data", "details": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
