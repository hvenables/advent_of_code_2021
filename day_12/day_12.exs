defmodule Day12 do
  def part_one do
    input = parse_input()

    walk_paths(input, starting_paths(input), [], &valid_next_path_p1/2)
  end

  def part_two do
    input = parse_input()

    walk_paths(input, starting_paths(input), [], &valid_next_path_p2/2)
  end

  def walk_paths(_input, [], walked_paths, _comparer) do
    length(walked_paths)
  end

  def walk_paths(input, existing_paths, walked_paths, comparer) do
    [next_path|remaining_paths] = existing_paths
    {_next_start, next_link} = List.first(next_path)

    {new_paths,end_paths} =
      Enum.filter(input, fn {start,_link} -> start == String.to_atom(next_link) end)
      |> Enum.filter(& comparer.(&1, next_path))
      |> Enum.map(fn x -> [x|next_path] end)
      |> Enum.split_with(fn [last|_rest] -> elem(last, 1) != "end" end)

    walk_paths(input, remaining_paths ++ new_paths, walked_paths ++ end_paths, comparer)
  end

  def valid_next_path_p1({_start, link}, next_path) do
    cond do
      large_cave?(link) ->
        true
      true ->
        Keyword.keys(next_path) |> Enum.member?(String.to_atom(link)) |> Kernel.!
    end
  end

  def valid_next_path_p2({start, link}, next_path) do
    cond do
      large_cave?(link) ->
        true
      (keys = Keyword.keys(next_path)) |> Enum.member?(String.to_atom(link)) ->
        small_caves = [start|keys] |> Enum.filter(& !large_cave?(&1)) |> Enum.sort
        small_caves == Enum.dedup(small_caves)
      true ->
        true
    end
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
    |> Enum.filter(fn {x,_} -> x != :end end)
    |> Enum.filter(fn {_,y} -> y != "start" end)
  end

  def starting_paths(input) do
    input
    |> Enum.filter(fn {start,_link} -> start == :start end)
    |> Enum.map(& [&1])
  end

  def large_cave?(cave) do
    to_string(cave) == String.upcase(to_string(cave))
  end
end
