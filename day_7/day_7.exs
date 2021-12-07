defmodule Day7 do
  def part_one do
    positions = parse_input()
    max_position = length(positions)
    for x <- 0..(max_position) do
      Enum.reduce(positions, 0, fn y, acc ->
        (abs(y - x)) + acc
      end)
    end |> Enum.with_index |> Enum.min_by(fn {x,_i} -> x end)
  end

  def part_two do
    positions = parse_input()
    max_position = length(positions)
    for x <- 0..(max_position) do
      Enum.reduce(positions, 0, fn y, acc ->
        fuel_required((abs(y - x)), 0, 0) + acc
      end)
    end |> Enum.with_index |> Enum.min_by(fn {x,_i} -> x end)
  end

  defp fuel_required(0, fuel, distance_travelled) do
    fuel
  end

  defp fuel_required(distance_left, fuel, distance_travelled) do
    fuel_required = distance_travelled + 1

    fuel_required(distance_left - 1, fuel + fuel_required, distance_travelled + 1)
  end

  defp parse_input do
    { :ok, contents } = File.read("input.txt")
    contents |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end
