defmodule Day12 do
  def part_one do
    input = parse_input()

    starting_paths =
      Enum.filter(input, fn {start,link} -> start == :start end)
      |> Enum.map(& [&1])

    walk_paths_1(input, starting_paths, [])
  end

  def part_two do
    input = parse_input()

    starting_paths =
      Enum.filter(input, fn {start,link} -> start == :start end)
      |> Enum.map(& [&1])

    walk_paths_2(input, starting_paths, [])
  end

  def walk_paths_1(_input, [], walked_paths) do
    length(walked_paths)
  end

  def walk_paths_1(input, existing_paths, walked_paths) do
    [next_path|remaining_paths] = existing_paths
    {next_start, next_link} = List.first(next_path)

    {new_paths,end_paths} =
      Enum.filter(input, fn {start,link} -> start == String.to_atom(next_link) end)
      |> Enum.filter(fn {start, link} ->
        cond do
          large_cave?(link) ->
            true
          (keys = Keyword.keys(next_path)) |> Enum.member?(String.to_atom(link)) ->
            false
          true ->
            true
        end
      end)
      |> Enum.map(fn x -> [x|next_path] end)
      |> Enum.split_with(fn [last|_rest] -> elem(last, 1) != "end" end)

    walk_paths_1(input, remaining_paths ++ new_paths, walked_paths ++ end_paths)
  end

  def walk_paths_2(_input, [], walked_paths) do
    length(walked_paths)
  end

  def walk_paths_2(input, existing_paths, walked_paths) do
    [next_path|remaining_paths] = existing_paths
    {next_start, next_link} = List.first(next_path)

    {new_paths,end_paths} =
      Enum.filter(input, fn {start,link} -> start == String.to_atom(next_link) end)
      |> Enum.filter(fn {start, link} ->
        cond do
          large_cave?(link) ->
            true
          (keys = Keyword.keys(next_path)) |> Enum.member?(String.to_atom(link)) ->
            small_caves = [start|keys] |> Enum.filter(& !large_cave?(&1)) |> Enum.sort
            small_caves == Enum.dedup(small_caves)
          true ->
            true
        end
      end)
      |> Enum.map(fn x -> [x|next_path] end)
      |> Enum.split_with(fn [last|_rest] -> elem(last, 1) != "end" end)

    walk_paths_2(input, remaining_paths ++ new_paths, walked_paths ++ end_paths)
  end

  def parse_input do
    { :ok, contents } = File.read("test_input_2.txt")

    contents
    |> String.trim
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split("-", trim: true)
    end)
    |> Enum.map(fn [x,y] -> [{ String.to_atom(x), y }, { String.to_atom(y), x }] end)
    |> List.flatten
    |> Enum.filter(fn {x,y} -> x != :end end)
    |> Enum.filter(fn {x,y} -> y != "start" end)
  end

  def large_cave?(cave) do
    to_string(cave) == String.upcase(to_string(cave))
  end
end
