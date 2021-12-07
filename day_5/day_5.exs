defmodule Day5 do
  def part_one do
    coordinates = parse_input()
    # coordinates = filter_diagonal(coordinates)
    result = draw_lines(coordinates)

    count_two_or_more_overlaps(result)
  end

  def draw_lines(coordinates) do
    Enum.reduce(coordinates, %{}, fn([{x1,y1}, {x2,y2}], acc) ->
      Enum.reduce(y1..y2, acc, fn y, acc ->
        Enum.reduce(x1..x2, acc, fn x, acc ->
          with {:ok, ys } <- Map.fetch(acc, y) do
            with {:ok, xs} <- Map.fetch(ys, x) do
              Map.put(acc, y, Map.put(ys, x, xs + 1))
            else
              _ ->
                Map.put(acc, y, Map.put_new(ys, x, 1))
            end
          else
            _ ->
              Map.put_new(acc, y, %{x => 1})
          end
        end)
      end)
    end)
  end

  def count_two_or_more_overlaps(map) do
    map
    |> Enum.reduce(0, fn {y, x}, acc ->
      x |> Enum.reduce(acc, fn {x,count}, acc -> if count > 1, do: acc + 1, else: acc end)
    end)
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

a = Day5.part_one()
require IEx; IEx.pry
