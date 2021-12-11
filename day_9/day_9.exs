defmodule Day9 do
  def part_one do
    input = parse_input()

    input
    |> Enum.with_index
    |> Enum.reduce(0, fn {depths,y}, acc ->
      depths
      |> Enum.with_index
      |> Enum.filter(fn {depth, x} -> !(lower_points(input, x, y) |> Enum.any?) end)
      |> Enum.map(fn {x, _y} -> (x |> String.to_integer) + 1 end) |> Enum.sum |> Kernel.+(acc)
    end)
  end

  def part_two do
    input = parse_input()

    lowest_points =
      input
      |> Enum.with_index
      |> Enum.map(fn {depths,y} ->
        depths
        |> Enum.with_index
        |> Enum.filter(fn {depth, x} -> !(lower_points(input, x, y) |> Enum.any?) end)
        |> Enum.map(fn {depth, x} -> {{x,y}, depth |> String.to_integer} end)
      end)
      |> List.flatten

    basin_sizes =
      lowest_points
      |> Enum.map(fn x -> basin_size(x) end)
      |> Enum.sort_by(& -&1)

    basin_sizes |> Enum.take(3) |> Enum.reduce(1, & &1 * &2)
  end

  def basin_size(first = {{x,y}, depth}) do
    input = parse_input()

    calculate_basin(adjacent_points(input, x, y), [first], input)
  end


  def calculate_basin([], existing, input) do
    existing |> length
  end

  def calculate_basin(adjacent, existing, input) do
    [next_point|other_adjacent] = adjacent
    all_points = existing ++ other_adjacent
    new_adjcent = with {{x,y}, depth} <- next_point do
      adjacent_points(input, x, y) -- all_points
    end
    calculate_basin(new_adjcent ++ other_adjacent, [next_point|existing], input)
  end

  def parse_input do
    { :ok, contents } = File.read("input.txt")

    contents
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  end

  def lower_points(input, x, y) do
    depth = Enum.at(input, y) |> Enum.at(x) |> String.to_integer

    for delta <- [-1, 1] do
      current_y = y + delta
      current_x = x + delta

      [lower_point(current_x, y, depth, input), lower_point(x, current_y, depth, input)]
    end |> List.flatten |> Enum.filter(& !is_nil(&1))
  end

  def adjacent_points(input, x, y) do
    depth = Enum.at(input, y) |> Enum.at(x) |> String.to_integer

    for delta <- [-1, 1] do
      current_y = y + delta
      current_x = x + delta

      [adjacent_point(current_x, y, depth, input), adjacent_point(x, current_y, depth, input)]
    end |> List.flatten |> Enum.filter(& !is_nil(&1))
  end

  def adjacent_point(x, y, _depth, input) do
    max_y = length(input) - 1
    max_x = length(List.first(input)) - 1

    if !out_of_range?(y, max_y) && !out_of_range?(x, max_x) do
      current_depth = Enum.at(input, y) |> Enum.at(x) |> String.to_integer
      if current_depth != 9 do
        { { x, y }, current_depth }
      end
    end
  end

  def lower_point(x, y, depth, input) do
    max_y = length(input) - 1
    max_x = length(List.first(input)) - 1

    if !out_of_range?(y, max_y) && !out_of_range?(x, max_x) do
      current_depth = Enum.at(input, y) |> Enum.at(x) |> String.to_integer
      if current_depth < depth do
        { { x, y }, current_depth }
      end
    end
  end

  def out_of_range?(pos, max) when pos > max, do: true
  def out_of_range?(pos, _max) when pos < 0, do: true
  def out_of_range?(_pos, _max), do: false
end
