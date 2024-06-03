defmodule SoggyWaffle.WeatherApi.ResponseParserTest do
  use ExUnit.Case

  alias SoggyWaffle.WeatherAPI.ResponseParser
  alias SoggyWaffle.Weather

  describe "parse_response/1" do
    setup do
      response_as_string =
        File.read!("test/support/weather_api_response.json")

      response_as_map = Jason.decode!(response_as_string)
      %{weather_data: response_as_map}
    end

    test "success: accepts a valid payload, returns a list of structs", %{
      weather_data: weather_data
    } do
      assert {:ok, parsed_response} =
               ResponseParser.parse_response(weather_data)

      for weather_record <- parsed_response do
        assert match?(
                 %Weather{datetime: %DateTime{}, rain?: _rain},
                 weather_record
               )

        assert is_boolean(weather_record.rain?)
      end
    end
  end
end
