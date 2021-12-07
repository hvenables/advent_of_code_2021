defmodule Day5 do
  def part_one do
    coordinates = parse_input()
    coordinates = filter_diagonal(coordinates)
    result = draw_lines(coordinates)

    count_two_or_more_overlaps(result)
  end

  def part_two do
    coordinates = parse_input()
    result = draw_lines(coordinates)

    count_two_or_more_overlaps(result)
  end

  def draw_lines(coordinates) do
    Enum.flat_map(coordinates, fn([{x1,y1}, {x2,y2}]) ->
      line_length = [abs(x1-x2), abs(y1-y2)] |> Enum.max
      x_delta = delta(x1, x2)
      y_delta = delta(y1, y2)

      for x <- 0..line_length, do: { x1 + (x * x_delta), y1 + (x * y_delta) }
    end)
  end

  def delta(x1, x2) do
    cond do
      x1 < x2 -> 1
      x1 == x2 -> 0
      x1 > x2 -> -1
    end
  end

  def count_two_or_more_overlaps(map) do
    map
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Enum.reduce(0, fn {_co, count}, acc -> if count > 1, do: acc + 1, else: acc end)
  end

  def parse_input do
    { :ok, contents } = File.read("input.txt")
    contents
    |> String.trim
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, " -> ") |> Enum.map(fn y -> String.split(y, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple end)
    end)
  end

  def filter_diagonal(coordinates) do
    Enum.filter(coordinates, fn [{x1,y1}, {x2,y2}] -> x1 == x2 || y1 == y2 end)
  end
end
