# City Temperature Script

This Bash script retrieves weather information using the OpenWeatherMap API and displays it in the terminal. It can provide weather details for a specified city or automatically detect the city based on your IP address.

## Features

- Fetches current weather data, including temperature, weather description, and more.
- Supports automatic city detection based on your IP address.
- Displays weather icons for better visualization.
- Includes sunrise and sunset times.
- Logs weather information with timestamps in a `.now.log` file.

## Usage

### Retrieving Weather Information for a Specific City

To retrieve weather information for a specific city, provide the city name as an argument when running the script. For example:

```bash
./weather.sh Indore
```
Replace `Indore` with the desired city name.

### Automatic City Detection

If you run the script without any arguments, it will automatically detect your city based on your IP address:

```bash
./weather.sh
```

## Prerequisites

Before using this script, make sure you have the following prerequisites installed:

- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)

You also need an API key from OpenWeatherMap. Replace `$APIKEY` with your API key in the script.

## License

This script is open-source and available under the [MIT License](LICENSE). Feel free to use, modify, and distribute it.

## Author

- [Jash Sharma](https://github.com/jxsrma/)

## Acknowledgments

- Weather data provided by [OpenWeatherMap](https://openweathermap.org/).
